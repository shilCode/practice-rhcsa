# Checks for Practice Test Nine (Server9)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_nine() {
    man   "Q1: root password reset to 'nine' (not verifiable)"

    # Q2: local repo from /dev/sr0 at /mnt/cdrom
    check "Q2: /mnt/cdrom mount in fstab" 'grep -q "/mnt/cdrom" /etc/fstab'
    check "Q2: BaseOS repo file:///mnt/cdrom/BaseOS" 'grep -rqs "file:///mnt/cdrom/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///mnt/cdrom/AppStream" 'grep -rqs "file:///mnt/cdrom/AppStream" /etc/yum.repos.d/'

    # Q3: NetworkManager profile net9
    check "Q3: connection net9 exists" 'nmcli -t con show net9'
    check "Q3: IPv4 192.168.9.10/24" 'nm_field ipv4.addresses | grep -q "192.168.9.10/24"'
    check "Q3: IPv4 gateway 192.168.9.1" 'nm_field ipv4.gateway | grep -q "192.168.9.1"'
    check "Q3: IPv6 fd09::10/64" 'nm_field ipv6.addresses | grep -q "fd09::10/64"'
    check "Q3: secondary IPv6 fd09::20/64" 'nm_field ipv6.addresses | grep -q "fd09::20/64"'
    check "Q3: IPv6 gateway fd09::1" 'nm_field ipv6.gateway | grep -q "fd09::1"'

    # Q4: time
    check "Q4: timezone America/Denver" '[ "$(timedatectl show -p Timezone --value)" = "America/Denver" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q5: user podadmin + linger
    check "Q5: user podadmin exists" 'id podadmin'
    check "Q5: linger enabled for podadmin" \
        'test -f /var/lib/systemd/linger/podadmin || loginctl show-user podadmin 2>/dev/null | grep -q "Linger=yes"'

    # Q6: LVM vg9/lv9 on /data9
    check "Q6: volume group vg9 exists" 'vgs vg9'
    check "Q6: logical volume lv9 exists" 'lvs vg9/lv9'
    check "Q6: /data9 mounted" 'findmnt /data9'
    check "Q6: /data9 persistent in fstab" 'grep -q "/data9" /etc/fstab'

    # Q7: rootless container Quadlet web9
    check "Q7: Quadlet web9.container exists" \
        'test -f /home/podadmin/.config/containers/systemd/web9.container'
    check "Q7: Quadlet references ubi9/ubi image" \
        'grep -Eq "^[[:space:]]*Image=.*ubi9/ubi" /home/podadmin/.config/containers/systemd/web9.container'
    check "Q7: Quadlet sets ContainerName=web9" \
        'grep -Eq "^[[:space:]]*ContainerName=web9" /home/podadmin/.config/containers/systemd/web9.container'
    check "Q7: ubi9/ubi image pulled by podadmin" \
        'su - podadmin -c "podman images" 2>/dev/null | grep -q "ubi9/ubi"'

    # Q8: web server
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html content" 'grep -q "Server9 Running" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall allows http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q9: find recent files
    check "Q9: /root/recent9.txt exists" 'test -f /root/recent9.txt'

    # Q10: bootloader rhgb/quiet removed
    check "Q10: rhgb/quiet removed from default kernel" \
        '! grubby --info=DEFAULT 2>/dev/null | grep "^args=" | grep -Eq "rhgb|quiet"'

    # Q11: rev9.sh
    check "Q11: rev9.sh reverses two args" \
        '[ "$(/usr/local/bin/rev9.sh red blue 2>/dev/null)" = "blue red" ]'

    # Q12: user policy
    check "Q12: /etc/skel/HELLO9.txt exists" 'test -f /etc/skel/HELLO9.txt'
    check "Q12: PASS_MAX_DAYS 60" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+60" /etc/login.defs'
    check "Q12: pwquality minlen 8" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*8" /etc/security/pwquality.conf'

    # Q13: collaboration dir
    check "Q13: group dev9 exists" 'getent group dev9'
    check "Q13: /opt/dev9 group owner dev9" '[ "$(stat -c %G /opt/dev9)" = "dev9" ]'
    check "Q13: /opt/dev9 perms 2770 (SGID)" '[ "$(stat -c %a /opt/dev9)" = "2770" ]'

    # Q14: log archive
    check "Q14: /root/log9.tar.gz exists" 'test -f /root/log9.tar.gz'
    check "Q14: archive contains var/log" 'tar tf /root/log9.tar.gz | grep -q "var/log"'

    # Q15: swap
    check "Q15: swap space active" 'swapon --show | grep -q .'
    check "Q15: swap entry in fstab" 'grep -qi swap /etc/fstab'

    # Q16: user + SSH hardening
    check "Q16: user sshuser9 exists" 'id sshuser9'
    check "Q16: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q17: tuned
    check "Q17: tuned profile throughput-performance" 'tuned-adm active | grep -q throughput-performance'

    # Q18: autofs
    check "Q18: autofs installed" 'rpm -q autofs'
    check "Q18: /misc9 configured in auto.master" 'grep -rqs "/misc9" /etc/auto.master /etc/auto.master.d/ 2>/dev/null'
    check "Q18: autofs enabled" 'systemctl is-enabled autofs'

    # Q19: sudo for ops9
    check "Q19: user ops9 exists" 'id ops9'
    check "Q19: ops9 NOPASSWD systemctl sudo rule" 'grep -rqs "NOPASSWD:.*systemctl" /etc/sudoers /etc/sudoers.d/'

    # Q20: LVM extend (lv9 grown beyond original 400M)
    check "Q20: lv9 extended (>=590 MiB)" \
        '[ "$(lvs --noheadings --units m --nosuffix -o lv_size vg9/lv9 2>/dev/null | cut -d. -f1 | tr -dc 0-9)" -ge 590 ]'
    check "Q20: /data9 filesystem grown (>=590 MiB)" \
        '[ "$(df -m --output=size /data9 2>/dev/null | tail -1 | tr -dc 0-9)" -ge 590 ]'

    # Q21: journald persistence
    check "Q21: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q21: /var/log/journal exists" 'test -d /var/log/journal'

    man   "Q22: transient process SIGSTOP - not verifiable"

    # Q23: ACL
    check "Q23: /var/tmp/hostname9 exists" 'test -f /var/tmp/hostname9'
    check "Q23: ACL grants nora r" 'getfacl -p /var/tmp/hostname9 2>/dev/null | grep -Eq "user:nora:r"'

    # Q24: listgroups9.sh
    check "Q24: /usr/local/bin/listgroups9.sh executable" 'test -x /usr/local/bin/listgroups9.sh'

    # Q25: grep comment lines
    check "Q25: /root/comments9.txt exists" 'test -f /root/comments9.txt'

    # Q26: default target
    check "Q26: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'

    # Q27: httpd on port 8909
    check "Q27: httpd Listen 8909" 'grep -Eq "^[[:space:]]*Listen[[:space:]]+8909" /etc/httpd/conf/httpd.conf'
    check "Q27: SELinux http_port_t includes 8909" 'semanage port -l 2>/dev/null | grep http_port_t | grep -qw 8909'
    check "Q27: firewall allows 8909/tcp (permanent)" 'firewall-cmd --permanent --list-ports | grep -qw 8909/tcp'

    # Q28: umask leo
    check "Q28: leo umask 022" 'grep -Eq "umask[[:space:]]+022" /home/leo/.bashrc'

    man   "Q29: container 'web9' running as podadmin (verify: su - podadmin -c 'podman ps' shows web9 Up)"

    # Q30: pinghost9.sh
    check "Q30: /usr/local/bin/pinghost9.sh executable" 'test -x /usr/local/bin/pinghost9.sh'
}
