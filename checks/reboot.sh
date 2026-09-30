# Reboot / persistence readiness checks
# Sourced by rhcsa-validator.sh -- verifies the system will survive a reboot.
# On the real EX200 the machine is REBOOTED before grading, so anything that is
# only applied at runtime (and not persisted) scores zero. These checks catch
# the common "works now, gone after reboot" mistakes.

_fstab_mountpoints() {
    awk '$1 !~ /^#/ && NF>=3 && $3!="swap" && $2!="none" && $2!="swap" {print $2}' /etc/fstab 2>/dev/null
}

_all_fstab_mounted() {
    local mp
    while read -r mp; do
        [ -z "$mp" ] && continue
        findmnt "$mp" >/dev/null 2>&1 || return 1
    done < <(_fstab_mountpoints)
    return 0
}

_fstab_swap_ok() {
    grep -qE '[[:space:]]swap[[:space:]]' /etc/fstab 2>/dev/null || return 0
    swapon --show 2>/dev/null | grep -q .
}

_selinux_persist_ok() {
    local rt cfg
    rt=$(getenforce 2>/dev/null | tr 'A-Z' 'a-z')
    cfg=$(grep -E '^SELINUX=' /etc/selinux/config 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
    [ -n "$rt" ] && [ "$rt" = "$cfg" ]
}

_firewalld_persist_ok() {
    rpm -q firewalld >/dev/null 2>&1 || return 0
    systemctl is-enabled firewalld >/dev/null 2>&1
}

_no_failed_units() {
    [ "$(systemctl --failed --no-legend 2>/dev/null | wc -l)" -eq 0 ]
}

check_reboot_readiness() {
    check "/etc/fstab is valid (findmnt --verify)" 'findmnt --verify >/dev/null 2>&1'
    check "all /etc/fstab filesystems are mounted now" '_all_fstab_mounted'
    check "fstab swap is active (if any defined)" '_fstab_swap_ok'
    check "SELinux runtime matches /etc/selinux/config" '_selinux_persist_ok'
    check "default systemd target is set" 'systemctl get-default'
    check "firewalld enabled so rules load at boot" '_firewalld_persist_ok'
    check "no failed systemd units" '_no_failed_units'
    man   "Now REBOOT, then re-run each test - a PASS after reboot proves it persists."
}
