# Checks for Practice Test One (ServerA)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_one() {
    man   "Q1: root password reset (cannot be verified automatically)"

    # Q2: Local DNF repo from ISO mounted at /mnt
    check "Q2: BaseOS repo points to file:///mnt/BaseOS" \
        'grep -rqs "file:///mnt/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo points to file:///mnt/AppStream" \
        'grep -rqs "file:///mnt/AppStream" /etc/yum.repos.d/'

    # Q3: NetworkManager profile lab-link
    check "Q3: connection 'lab-link' exists" 'nmcli -t con show lab-link'
    check "Q3: IPv4 192.168.1.10/24 present" 'nm_field ipv4.addresses | grep -q "192.168.1.10/24"'
    check "Q3: secondary IPv4 10.0.0.5/24 present" 'nm_field ipv4.addresses | grep -q "10.0.0.5/24"'
    check "Q3: IPv6 fd00::10/64 present" 'nm_field ipv6.addresses | grep -q "fd00::10/64"'
    check "Q3: IPv4 gateway 192.168.1.1" 'nm_field ipv4.gateway | grep -q "192.168.1.1"'

    # Q4: Time services
    check "Q4: timezone America/New_York" \
        '[ "$(timedatectl show -p Timezone --value)" = "America/New_York" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'
    check "Q4: pool.ntp.org configured" 'grep -Eqrs "pool.ntp.org" /etc/chrony.conf'

    # Q5: Flatpak
    check "Q5: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q5: org.gnome.TextEditor installed" 'flatpak list | grep -qi org.gnome.TextEditor'

    # Q6: LVM myvg/mylv on /mylv (extended to ~1G)
    check "Q6: volume group myvg exists" 'vgs myvg'
    check "Q6: logical volume mylv exists" 'lvs myvg/mylv'
    check "Q6: /mylv is mounted" 'findmnt /mylv'
    check "Q6: /mylv persistent in fstab" 'grep -q "mylv" /etc/fstab'

    # Q7: systemd timer system-check
    check "Q7: /usr/local/bin/system-check.sh executable" 'test -x /usr/local/bin/system-check.sh'
    check "Q7: system-check.service exists" 'test -f /etc/systemd/system/system-check.service'
    check "Q7: system-check.timer enabled" 'systemctl is-enabled system-check.timer'

    # Q8: Web server
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html content" 'grep -q "Welcome to RHEL 10" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall allows http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q9: find large files
    check "Q9: /find/largefiles directory exists" 'test -d /find/largefiles'

    # Q10: bootloader rhgb/quiet removed
    check "Q10: rhgb/quiet removed from default kernel" \
        '! grubby --info=DEFAULT 2>/dev/null | grep "^args=" | grep -Eq "rhgb|quiet"'

    # Q11: flipargs.sh
    check "Q11: flipargs.sh reverses two args" \
        '[ "$(/usr/local/bin/flipargs.sh red blue 2>/dev/null)" = "blue red" ]'

    # Q12: user policy
    check "Q12: /etc/skel/Welcome.txt exists" 'test -f /etc/skel/Welcome.txt'
    check "Q12: PASS_MAX_DAYS 90" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+90" /etc/login.defs'
    check "Q12: pwquality minlen 8" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*8" /etc/security/pwquality.conf'

    # Q13: developers collaboration dir
    check "Q13: group developers exists" 'getent group developers'
    check "Q13: /opt/dev-data group owner developers" '[ "$(stat -c %G /opt/dev-data)" = "developers" ]'
    check "Q13: /opt/dev-data perms 2770 (SGID)" '[ "$(stat -c %a /opt/dev-data)" = "2770" ]'

    # Q14: ssh config backup archive
    check "Q14: /root/config_backup.tar.gz exists" 'test -f /root/config_backup.tar.gz'
    check "Q14: archive contains etc/ssh" 'tar tf /root/config_backup.tar.gz | grep -q "etc/ssh"'

    # Q15: swap
    check "Q15: swap space active" 'swapon --show | grep -q .'
    check "Q15: swap entry in fstab" 'grep -qi swap /etc/fstab'

    # Q16: SSH hardening
    check "Q16: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q17: tuned
    check "Q17: tuned profile throughput-performance" 'tuned-adm active | grep -q throughput-performance'

    # Q18: autofs NFS
    check "Q18: autofs installed" 'rpm -q autofs'
    check "Q18: /data configured in auto.master" 'grep -rqs "/data" /etc/auto.master /etc/auto.master.d/ 2>/dev/null'
    check "Q18: autofs enabled" 'systemctl is-enabled autofs'

    # Q19: sudo for alex
    check "Q19: user alex exists" 'id alex'
    check "Q19: alex NOPASSWD dnf sudo rule" 'grep -rqs "NOPASSWD:.*dnf" /etc/sudoers /etc/sudoers.d/'

    # Q20: VDO
    check "Q20: VDO logical volume vdo_lv exists" 'lvs | grep -qw vdo_lv'
    check "Q20: /vdo_data mounted" 'findmnt /vdo_data'

    # Q21: journald persistence
    check "Q21: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q21: /var/log/journal exists" 'test -d /var/log/journal'
    check "Q21: /var/log/ssh_boot.log exists" 'test -f /var/log/ssh_boot.log'

    man   "Q22: transient process management (start/renice/kill) - not verifiable"

    # Q23: ACL
    check "Q23: /var/tmp/fstab_copy exists" 'test -f /var/tmp/fstab_copy'
    check "Q23: ACL grants alex rw" 'getfacl -p /var/tmp/fstab_copy 2>/dev/null | grep -q "user:alex:rw"'

    # Q24: audit loop script
    check "Q24: /usr/local/bin/user_audit.sh executable" 'test -x /usr/local/bin/user_audit.sh'

    # Q25: grep Host lines
    check "Q25: /root/ssh_hosts.txt exists" 'test -f /root/ssh_hosts.txt'

    # Q26: default target
    check "Q26: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'

    # Q27: httpd on port 82
    check "Q27: httpd Listen 82" 'grep -Eq "^[[:space:]]*Listen[[:space:]]+82" /etc/httpd/conf/httpd.conf'
    check "Q27: SELinux http_port_t includes 82" 'semanage port -l 2>/dev/null | grep http_port_t | grep -qw 82'
    check "Q27: firewall allows 82/tcp (permanent)" 'firewall-cmd --permanent --list-ports | grep -qw 82/tcp'

    # Q28: umask for harry
    check "Q28: harry umask 027" 'grep -Eq "umask[[:space:]]+027" /home/harry/.bashrc'

    man   "Q29: scp/rsync transfer - transient, not verifiable"

    # Q30: checkfile.sh
    check "Q30: /usr/local/bin/checkfile.sh executable" 'test -x /usr/local/bin/checkfile.sh'
}
