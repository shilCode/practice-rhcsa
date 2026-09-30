#!/usr/bin/env bash
#
# rhcsa-validator.sh - Simple TUI validator for the RHCSA practice tests.
#
# Runs LIVE checks against the current system to verify that the tasks in the
# practice-test-*.md files were completed correctly. Pure Bash, no dependencies.
#
# Usage:  sudo ./rhcsa-validator.sh
#
# Run this ON the RHEL machine you are configuring. Most checks require root.

set -o pipefail

# --- Resolve script directory so checks/ can be sourced -----------------------
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Colors -------------------------------------------------------------------
if [[ -t 1 ]]; then
    GREEN=$'\e[32m'; RED=$'\e[31m'; YELLOW=$'\e[33m'
    CYAN=$'\e[36m'; BOLD=$'\e[1m'; RESET=$'\e[0m'
else
    GREEN=''; RED=''; YELLOW=''; CYAN=''; BOLD=''; RESET=''
fi

# --- Result counters (reset before each test run) -----------------------------
_PASS=0; _FAIL=0; _MANUAL=0

reset_counters() { _PASS=0; _FAIL=0; _MANUAL=0; }

ok()  { printf "  ${GREEN}[PASS]${RESET} %s\n"   "$1"; _PASS=$((_PASS+1)); }
no()  { printf "  ${RED}[FAIL]${RESET} %s\n"     "$1"; _FAIL=$((_FAIL+1)); }
man() { printf "  ${YELLOW}[MANUAL]${RESET} %s\n" "$1"; _MANUAL=$((_MANUAL+1)); }

# check "description" 'shell command'  -> PASS if command exits 0, else FAIL
# Runs with pipefail disabled: checks like `tar tf ... | grep -q x` make grep
# exit early, sending SIGPIPE (141) to the left side; under pipefail that would
# be a false FAIL even though the match was found.
check() {
    if ( set +o pipefail; eval "$2" ) >/dev/null 2>&1; then
        ok "$1"
    else
        no "$1"
    fi
}

summary() {
    local total=$((_PASS+_FAIL))
    echo
    printf "${BOLD}Result:${RESET} ${GREEN}%d passed${RESET}, ${RED}%d failed${RESET}" "$_PASS" "$_FAIL"
    printf " (of %d automated checks)" "$total"
    [[ $_MANUAL -gt 0 ]] && printf ", ${YELLOW}%d need manual review${RESET}" "$_MANUAL"
    echo
}

# --- Helpers reused across tests ----------------------------------------------
# Print the requested nmcli field value across ALL connection profiles, so IP
# checks work regardless of the connection name the user chose.
# --escape no is REQUIRED: nmcli terse/-g mode escapes every ':' as '\:', which
# turns "fd00::10/64" into "fd00\:\:10/64" and breaks all IPv6 substring greps.
nm_field() {
    local f="$1" n
    nmcli --escape no -t -f NAME connection show 2>/dev/null | while IFS= read -r n; do
        nmcli --escape no -g "$f" connection show "$n" 2>/dev/null
    done
}

# --- Load per-test check functions --------------------------------------------
for f in "$DIR"/checks/*.sh; do
    # shellcheck source=/dev/null
    [[ -r "$f" ]] && source "$f"
done

run_test() {
    reset_counters
    clear
    printf "${BOLD}${CYAN}=== Validating %s ===${RESET}\n\n" "$1"
    "$2"
    summary
}

run_all() {
    clear
    printf "${BOLD}${CYAN}=== Validating ALL practice tests ===${RESET}\n"
    local g_pass=0 g_fail=0 g_manual=0
    for t in one two three four five six seven eight nine ten; do
        reset_counters
        printf "\n${BOLD}--- Practice Test %s ---${RESET}\n" "$t"
        "check_test_${t}"
        g_pass=$((g_pass+_PASS)); g_fail=$((g_fail+_FAIL)); g_manual=$((g_manual+_MANUAL))
    done
    echo
    printf "${BOLD}GRAND TOTAL:${RESET} ${GREEN}%d passed${RESET}, ${RED}%d failed${RESET}, ${YELLOW}%d manual${RESET}\n" \
        "$g_pass" "$g_fail" "$g_manual"
}

pause() { echo; read -rp "Press Enter to return to the menu... " _; }

main_menu() {
    while true; do
        clear
        printf "${BOLD}${CYAN}"
        cat <<'BANNER'
  ____  _   _  ____ ____    _    __     __    _ _     _       _
 |  _ \| | | |/ ___/ ___|  / \   \ \   / /_ _| (_) __| | __ _| |_ ___  _ __
 | |_) | |_| | |   \___ \ / _ \   \ \ / / _` | | |/ _` |/ _` | __/ _ \| '__|
 |  _ <|  _  | |___ ___) / ___ \   \ V / (_| | | | (_| | (_| | || (_) | |
 |_| \_\_| |_|\____|____/_/   \_\   \_/ \__,_|_|_|\__,_|\__,_|\__\___/|_|
BANNER
        printf "${RESET}\n"
        [[ $EUID -ne 0 ]] && printf "  ${YELLOW}Note: not running as root - some checks may report FAIL.${RESET}\n\n"
        echo "  Select a practice test to validate against this system:"
        echo
        echo "    1) Practice Test One"
        echo "    2) Practice Test Two"
        echo "    3) Practice Test Three"
        echo "    4) Practice Test Four"
        echo "    5) Practice Test Five"
        echo "    6) Practice Test Six"
        echo "    7) Practice Test Seven  (SELinux)"
        echo "    8) Practice Test Eight  (Scheduling: cron & at)"
        echo "    9) Practice Test Nine   (Containers: rootless podman)"
        echo "   10) Practice Test Ten    (LVM: create & extend)"
        echo
        echo "    R) Reboot / persistence readiness"
        echo "    A) Validate ALL tests"
        echo "    Q) Quit"
        echo
        read -rp "  Choice: " choice
        case "${choice,,}" in
            1) run_test "Practice Test One"   check_test_one;   pause ;;
            2) run_test "Practice Test Two"   check_test_two;   pause ;;
            3) run_test "Practice Test Three" check_test_three; pause ;;
            4) run_test "Practice Test Four"  check_test_four;  pause ;;
            5) run_test "Practice Test Five"  check_test_five;  pause ;;
            6) run_test "Practice Test Six"   check_test_six;   pause ;;
            7) run_test "Practice Test Seven" check_test_seven; pause ;;
            8) run_test "Practice Test Eight" check_test_eight; pause ;;
            9) run_test "Practice Test Nine"  check_test_nine;  pause ;;
            10) run_test "Practice Test Ten"  check_test_ten;   pause ;;
            r) run_test "Reboot / Persistence Readiness" check_reboot_readiness; pause ;;
            a) run_all; pause ;;
            q) clear; exit 0 ;;
            *) ;;
        esac
    done
}

main_menu
