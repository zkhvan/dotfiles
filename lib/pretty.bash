# Source me

__kz_echo()    { printf '          %s\033[0;m\n' "$1"; }
__kz_status()  { printf '\033[0;34m==>       %s\033[0;m\n' "$1"; }
__kz_status_() { printf '\033[0;34m          %s\033[0;m\n' "$1"; }
__kz_ok()      { printf '\033[0;32m==> OK:   %s\033[0;m\n' "$1"; }
__kz_ok_()     { printf '\033[0;32m==>       %s\033[0;m\n' "$1"; }
__kz_err()     { printf '\033[0;31m==> ERR:  %s\033[0;m\n' "$1" >&2; }
__kz_err_()    { printf '\033[0;31m          %s\033[0;m\n' "$1" >&2; }
__kz_warn()    { printf '\033[0;33m==> WARN: %s\033[0;m\n' "$1" >&2; }
__kz_warn_()   { printf '\033[0;33m          %s\033[0;m\n' "$1" >&2; }
__kz_usage()   { printf '\033[0;34m==> USAGE: \033[0;32m%s\033[0;m\n' "$1"; }
__kz_usage_()  { printf '\033[0;29m           %s\033[0;m\n' "$1"; }
