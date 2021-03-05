# ============================================================================
# POSIX-compliant helper scripts
# ============================================================================

# Silently checks the existence of an executable.
__kz_has() {
  command -v "$1" >/dev/null 2>&1;
}

# Enforces the requirement of an executable to exist.
__kz_require() {
  __kz_has "$1" && __kz_status "FOUND: ${1}" && return 0
  __kz_err "MISSING: ${1}"
  __kz_err_ "Please install before proceeding."
  return 1
}
