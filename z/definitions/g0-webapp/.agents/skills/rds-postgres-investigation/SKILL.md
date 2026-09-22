---
name: rds-postgres-investigation
description: Investigate RDS PostgreSQL performance incidents by correlating CloudWatch metrics, RDS PostgreSQL logs, RDS Enhanced Monitoring (RDSOSMetrics), and Datadog. Tool-agnostic 6-step loop that delegates invocation to whatever the harness exposes (MCP, aws CLI, pup). Triggers on "RDS issue", "database slow", "PostgreSQL performance", "high ReadIOPS/WriteIOPS", "DiskQueueDepth", "RDS failover", "database memory", "checkpoint slow", "connection timeouts", "lock contention", "replication lag", or investigating database degradation on GPTZero RDS instances.
---

# RDS PostgreSQL Incident Investigation

Investigate RDS PostgreSQL performance incidents by correlating signals across
CloudWatch metrics, RDS PostgreSQL logs, RDS Enhanced Monitoring (RDSOSMetrics),
and (optionally) Datadog.

This skill owns **what to check** and **how to report**. It does **not** hardcode
how to invoke any tool — see [Tooling resolution](#tooling-resolution).

## Response contract

You are frequently invoked while a human on-caller investigates in parallel.
Structure the final response so the hand-off is useful:

- **Lead with the conclusion.** First paragraph = one-sentence root-cause hypothesis:
  failure mode + the offending entity
  (e.g. "Read query pile-up driven by the scan-history `WITH base AS …` query").
- **Map to the failure-mode taxonomy.** State which mode from
  [references/failure-modes.md](references/failure-modes.md) this matches.
- **Surface the kill-switch, if any.** If the mitigation is
  `pg_cancel_backend` / `pg_terminate_backend`, include the exact SQL with matching
  PIDs or a by-runtime kill rule. The on-caller will paste it. You are usually on a
  read-only role and cannot execute it yourself — hand it over.
- **Flag what does NOT match.** Explicitly rule out modes the data excludes
  (e.g. "FreeableMemory stable + SwapUsage ~0, so this is *not* memory collapse").
- **Evidence last.** Timeline, log excerpts, and metric snapshots go in the second half.

## Required information

- **RDS instance identifier** (e.g. `prod-gptzero-logging-db-lite-v3`)
- **Incident window in UTC** (e.g. `18:00–18:25 UTC`). Prefer epoch seconds when
  querying logs to avoid timezone ambiguity.
- **AWS region** — default `us-east-1`.
- **Datadog service name** (optional, only for Step 1).

### Known instances

| Instance | Role | Notes |
|----------|------|-------|
| `prod-gptzero-logging-db-lite-v3` | Production write primary | Handles all writes; most susceptible to resource exhaustion. Default target. |
| `prod-gptzero-logging-db-lite-v3-ro` | Production read replica | Check when read-heavy workloads are affected. |
| `prod-gptzero-logging-db-lite-v3-ro2` | Production read replica | Secondary read replica. |
| `training-test-db-lite-experimental` | Training database | Training/test workload issues. |

**Default:** production incident without specifics → start with the write primary
`prod-gptzero-logging-db-lite-v3`.

## Tooling resolution

The checks below are written as **abstract operations**. Bind each operation to
whatever your harness exposes — **discover availability dynamically, as needed**;
do not assume a fixed tool or a fixed preference order.

| Abstract operation | What it returns | Bind to (examples) |
|--------------------|-----------------|--------------------|
| `GET_METRIC(instance, metric, stat, window)` | CloudWatch metric time series | CloudWatch MCP `get_metric_data`, **or** the `aws-cli` skill → `references/cloudwatch-metrics.md` |
| `LOGS_QUERY(log_group, query, window)` | CloudWatch Logs Insights results | CloudWatch MCP `execute_log_insights_query`, **or** the `aws-cli` skill → `references/cloudwatch-logs-insights.md` |
| `DESCRIBE_DB(instance)` | RDS instance config | RDS MCP, **or** the `aws-cli` skill → `references/rds.md` |
| `DD_LOGS(query, window)` | Datadog application logs | Datadog MCP `search_datadog_logs`, **or** the `datadog-pup` skill → `references/logs.md` |

If nothing satisfies an operation, say so and continue with the operations you can
run — see [Minimum viable investigation](#minimum-viable-investigation).

## Key log groups

| Log group | Contains |
|-----------|----------|
| `/aws/rds/instance/<instance-id>/postgresql` | PostgreSQL server logs (errors, checkpoints, connections, slow queries) |
| `RDSOSMetrics` | Enhanced Monitoring: OS-level metrics + per-process `processList` |

## Investigation loop

Run in order; stop early once a failure mode is confirmed and its evidence is solid.

### 1. Establish the timeline
Pin exact **UTC** start/end. When the incident is ongoing, "now" is the end.
When querying logs, use **epoch seconds** (unambiguous). Beware: some tools return
metric timestamps in the caller's **local timezone** — see the `aws-cli` skill's
timezone note before reading timestamps off metric output.

### 2. Application symptoms (optional — Datadog)
`DD_LOGS("service:<svc> status:error", window)` — error patterns (timeouts,
connection refused/reset), which queries fail, latency distribution. Skip if Datadog
is unavailable; the rest of the loop still identifies root cause.

### 3. PostgreSQL logs
`LOGS_QUERY("/aws/rds/instance/<id>/postgresql", <q>, window)` where `<q>` filters for
`ERROR|FATAL|WARNING|checkpoint|could not|Connection reset|duration:`.
Then quantify the suspect query: `parse … "duration: * ms" as dur` + `stats count(*),
avg(dur), max(dur), pct(dur,95)` and `stats count(*) by bin(1m)` for its rate.
See red-flag patterns in [references/failure-modes.md](references/failure-modes.md).

### 4. Instance metrics
`GET_METRIC(...)` for the vitals. Pull as a batch:
`ReadIOPS, WriteIOPS, ReadThroughput, DiskQueueDepth, ReadLatency, WriteLatency,
CPUUtilization, FreeableMemory, SwapUsage, DatabaseConnections`, plus
`EBSIOBalance%`/`EBSByteBalance%` for gp2/gp3. Thresholds in
[references/failure-modes.md](references/failure-modes.md).

### 5. OS-level process detail (RDSOSMetrics) — most decisive
`LOGS_QUERY("RDSOSMetrics", 'filter instanceID="<id>" | sort @timestamp desc', window)`.
Each `@message` is a JSON string: parse it and inspect `processList` for high
`cpuUsedPc` / `memoryUsedPc`, parallel workers (`parallel worker for PID …`), and
`memory`/`swap`/`cpuUtilization` (watch I/O `wait`). See the RDSOSMetrics parsing
recipe in the `aws-cli` skill (`references/cloudwatch-logs-insights.md`) — it handles
`null` process fields.

### 6. Correlate & conclude
Build a UTC timeline across metrics + PG logs + RDSOSMetrics (+ Datadog). Match to a
failure mode, then write the response per the [Response contract](#response-contract).

### Correlating PID → query
If slow-query logging is on and the log_line_prefix includes `%p`, the PG log line
carries the PID: `…:[<pid>]:LOG: duration: … ms statement: …`. Take a memory/CPU-hungry
PID from RDSOSMetrics `processList` and grep the PostgreSQL log group for
`/\[<pid>\]:LOG:.*duration:/` in the same window to recover the exact query text.

## Minimum viable investigation

- Only CloudWatch reachable (no Datadog): skip Step 2; Steps 3–6 still identify root
  cause via RDSOSMetrics `processList` + PG slow-query logs.
- Read-only credentials are expected and sufficient — this skill only reads. Mitigation
  SQL is handed to the on-caller.
