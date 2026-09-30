#!/usr/bin/env bash
#
# run-test.sh - Non-interactive grader for a single practice test.
#
# Sources rhcsa-validator.sh (without launching the menu) and runs one check
# function, printing PASS/FAIL/MANUAL and a summary. Handy for scripting/CI.
#
# Usage:  sudo ./run-test.sh <one|two|...|ten|reboot>
#         sudo ./run-test.sh all

set -o pipefail
# Use a dedicated var: sourcing the validator below reassigns its own $DIR.
RTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load all validator functions/helpers but strip the final menu launch.
# (When sourced via process substitution the validator's own $DIR resolves to
# the pipe FD, so its checks/ auto-load is skipped -- we re-source them here.)
source <(sed '/^main_menu$/d' "$RTDIR/rhcsa-validator.sh")
for f in "$RTDIR"/checks/*.sh; do
    [ -r "$f" ] && source "$f"
done

case "${1:-}" in
    all)     run_all ;;
    reboot)  reset_counters; check_reboot_readiness; summary ;;
    "" )     echo "Usage: $0 <one..ten|reboot|all>"; exit 2 ;;
    *)       reset_counters; "check_test_${1}"; summary ;;
esac
