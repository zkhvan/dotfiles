#!/usr/bin/env bash
#
# build.sh — create and provision an isolated OrbStack sandbox VM.
#
# Usage:
#   ./build.sh [name]        # name defaults to "sandbox"
#
# Overrides:
#   ORB_DISTRO       distro[:version]            (default: ubuntu)
#   ORB_CLOUDINIT    cloud-init user-data file   (default: cloud-init/sandbox.yaml)

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

NAME="${1:-sandbox}"
DISTRO="${ORB_DISTRO:-ubuntu}"
CLOUDINIT="${ORB_CLOUDINIT:-${SCRIPT_DIR}/cloud-init.yaml}"

# --isolated         no host file sharing, no command integration
# --isolate-network  blocked from the host and other machines (internet still works)
orb create "$DISTRO" "$NAME" -c "$CLOUDINIT" --isolated --isolate-network

# Block until cloud-init finishes provisioning before we touch the machine.
orb -m "$NAME" cloud-init status --wait

if infocmp -x xterm-ghostty >/dev/null 2>&1; then
  infocmp -x xterm-ghostty | orb -m "$NAME" -u root tic -x -o /etc/terminfo /dev/stdin
fi
