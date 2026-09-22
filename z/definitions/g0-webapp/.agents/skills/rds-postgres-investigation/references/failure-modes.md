# RDS PostgreSQL failure-mode taxonomy

Loaded on demand by `rds-postgres-investigation`. Match the incident to one mode,
name it in the conclusion, and rule out the others explicitly.

## Metric thresholds (quick reference)

| Metric | Normal | Problem indicator |
|--------|--------|-------------------|
| `ReadIOPS` | 100–800 | > 2000 sustained |
| `WriteIOPS` | 200–800 | > 3000 sustained |
| `DiskQueueDepth` | 0–2 | > 10 sustained |
| `ReadLatency` / `WriteLatency` | < 5 ms | > 50 ms |
| `CPUUtilization` | < 60% | > 80% sustained |
| `FreeableMemory` | stable, GBs | sharp drop toward hundreds of MB |
| `SwapUsage` | ~0 | sustained spikes |
| `EBSIOBalance%` / `EBSByteBalance%` (gp2/gp3) | > 90% | < 50% (burst credits depleted → throttled) |
| `DatabaseConnections` | steady baseline | sudden climb toward max |

Interpretation notes:
- High `ReadIOPS`/`ReadThroughput` with **low `ReadLatency`** = the storage is keeping
  up; the problem is read *volume*, not disk. Look for a heavy/looping read query.
- High CPU **I/O wait** (from RDSOSMetrics `cpuUtilization.wait`) with low user CPU =
  disk-bound, not compute-bound.

## Failure modes

### 1. Read query pile-up
**Symptoms:** `ReadIOPS`/`ReadThroughput` spike, `DiskQueueDepth` elevated, memory and
connections stable, low `ReadLatency`, CPU I/O-wait up. RDSOSMetrics shows ordinary
`SELECT` backends (often + `parallel worker for PID …`). PG logs show one query shape
repeating from multiple client IPs, some long-running.
**Confirm:** `stats count(*), avg(dur), max(dur), pct(dur,95)` on the suspect query;
a few very long runners (tens of seconds to minutes) overlapping frequent short ones.
**Kill-switch:** by-runtime cancel/terminate (below).
**Fix:** add `statement_timeout`; cap `max_parallel_workers_per_gather`; select only
needed columns (avoid pulling large JSON/TOAST blobs for listings); route to read
replicas; add/verify indexes.

### 2. Memory collapse / runaway parallel query
**Symptoms:** `FreeableMemory` drops sharply (e.g. 20GB → 1GB in minutes),
`SwapUsage` spikes, buffer cache evicted (RDSOSMetrics `memory.cached` collapses),
checkpoint `sync` time rises as a victim. RDSOSMetrics shows a single query + its
parallel workers consuming a large share of memory.
**Fix:** cap `max_parallel_workers_per_gather`; set `work_mem` explicitly; enable
`log_min_duration_statement`; optimize the offending query.

### 3. WAL flood / autovacuum storm
**Symptoms:** `WriteIOPS` sustained high, checkpoints frequent/slow, PG logs show
`checkpoint complete: … sync=<big> s` and `autovacuum worker took too long to start`.
**Fix:** tune checkpoint/WAL settings; investigate bulk writes; tune autovacuum.

### 4. Connection storm
**Symptoms:** many `could not accept SSL connection: EOF detected` errors,
`DatabaseConnections` climbing, CPU spike from SSL handshakes, memory stable initially.
**Fix:** connection pooling (PgBouncer / RDS Proxy); app-side connection limits; TCP keepalives.

### 5. Lock contention / long transaction
**Symptoms:** queries waiting on locks, autovacuum blocked, gradual degradation,
specific tables involved.
**Fix:** identify blockers with `pg_blocking_pids()`; add `statement_timeout`;
review isolation levels / long-open transactions.

### 6. Replication lag
**Symptoms:** replica `ReplicaLag` rises, read replicas serve stale data, often
downstream of a write flood or a long transaction on the primary.
**Fix:** address the primary-side driver; scale replica; reduce long transactions.

### 7. Manual / Multi-AZ failover
**Symptoms:** PG logs show `FATAL: the database system is in recovery mode` then
`database system is ready to accept connections`; mass app errors during the gap.
**Fix:** confirm cause of failover; verify app reconnect/retry behavior.

## Checkpoint reference

Normal:
```
checkpoint complete: wrote 90275 buffers (9.0%); sync=0.061 s, total=269.857 s; sync files=819, longest=0.007 s, average=0.001 s
```
Problematic (I/O stall):
```
checkpoint complete: wrote 88198 buffers (8.8%); sync=20.863 s, total=291.035 s; sync files=867, longest=14.373 s, average=0.025 s
```
Red flags: `sync` > 1s (normal < 0.1s); `longest` > 1s (normal < 0.01s); large gap
between write and total time.

## Kill-switches (hand to the on-caller)

Inspect first:
```sql
SELECT pid, now() - query_start AS runtime, state, client_addr, left(query, 100)
FROM pg_stat_activity
WHERE state = 'active' AND query LIKE '%<query fragment>%'
ORDER BY query_start;
```
Cancel (gentle) queries running longer than a threshold:
```sql
SELECT pg_cancel_backend(pid) FROM pg_stat_activity
WHERE state = 'active' AND query LIKE '%<query fragment>%'
  AND now() - query_start > interval '60 seconds';
```
Force-terminate stragglers:
```sql
SELECT pg_terminate_backend(pid) FROM pg_stat_activity
WHERE state = 'active' AND query LIKE '%<query fragment>%'
  AND now() - query_start > interval '120 seconds';
```

## Slow-query logging knobs (for future correlation)

| Parameter | Logs | Use |
|-----------|------|-----|
| `log_min_duration_statement` | queries over N ms + PID | slow-query capture, PID→query |
| `log_lock_waits = on` | lock wait events | identify blockers |
| `log_temp_files = 65536` | temp files > 64KB | queries spilling to disk |
| `idle_in_transaction_session_timeout` | kills idle-in-txn sessions | connection-pool leaks |
