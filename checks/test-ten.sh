# Checks for Practice Test Ten (Server10)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_ten() {
    man   "Q1: root password reset to 'ten' (not verifiable)"

    # Q2: local repo from ISO at /mnt/repo10 with gpgcheck=1
    check "Q2: /mnt/repo10 mount in fstab" 'grep -q "/mnt/repo10" /etc/fstab'
    check "Q2: BaseOS repo file:///mnt/repo10/BaseOS" 'grep -rqs "file:///mnt/repo10/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///mnt/repo10/AppStream" 'grep -rqs "file:///mnt/repo10/AppStream" /etc/yum.repos.d/'
    check "Q2: gpgcheck enabled" 'grep -rqs "gpgcheck=1" /etc/yum.repos.d/'

    # Q3: NetworkManager profile net10
    check "Q3: connection net10 exists" 'nmcli -t con show net10'
    check "Q3: IPv4 192.168.10.10/24" 'nm_field ipv4.addresses | grep -q "192.168.10.10/24"'
    check "Q3: IPv4 gateway 192.168.10.1" 'nm_field ipv4.gateway | grep -q "192.168.10.1"'
    check "Q3: IPv6 fd0a::10/64" 'nm_field ipv6.addresses | grep -q "fd0a::10/64"'
    check "Q3: IPv6 gateway fd0a::1" 'nm_field ipv6.gateway | grep -q "fd0a::1"'
    check "Q3: IPv6 DNS fd0a::53" 'nm_field ipv6.dns | grep -q "fd0a::53"'

    # Q4: time
    check "Q4: timezone Australia/Sydney" '[ "$(timedatectl show -p Timezone --value)" = "Australia/Sydney" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q5: packet forwarding
    check "Q5: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q5: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q5: forwarding persisted" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q6: LVM vg10/lv10 custom PE size + extents
    check "Q6: volume group vg10 exists" 'vgs vg10'
    check "Q6: vg10 PE size 16 MiB" 'vgdisplay vg10 2>/dev/null | grep "PE Size" | grep -q "16.00"'
    check "Q6: lv10 has 50 extents" 'lvdisplay /dev/vg10/lv10 2>/dev/null | grep "Current LE" | grep -qw 50'
    check "Q6: /data10 mounted" 'findmnt /data10'
    check "Q6: /data10 persistent in fstab" 'grep -q "/data10" /etc/fstab'

    # Q7: systemd timer cleanup10 at 16:15
    check "Q7: /usr/local/bin/cleanup10.sh executable" 'test -x /usr/local/bin/cleanup10.sh'
    check "Q7: cleanup10.service exists" 'test -f /etc/systemd/system/cleanup10.service'
    check "Q7: cleanup10.timer enabled" 'systemctl is-enabled cleanup10.timer'
    check "Q7: cleanup10.timer scheduled 16:15" 'grep -q "16:15" /etc/systemd/system/cleanup10.timer'

    # Q8: web server + firewall http/https
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html content" 'grep -q "Server10 OK" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall allows http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'
    check "Q8: firewall allows https (permanent)" 'firewall-cmd --permanent --list-services | grep -qw https'

    # Q9: find 777 files
    check "Q9: /root/world10.txt exists" 'test -f /root/world10.txt'

    # Q10: GRUB timeout 10
    check "Q10: GRUB_TIMEOUT set to 10" 'grep -Eq "^GRUB_TIMEOUT=10" /etc/default/grub'

    # Q11: upper10.sh
    check "Q11: upper10.sh upper-cases arg (hi = HI)" \
        '[ "$(/usr/local/bin/upper10.sh hi 2>/dev/null)" = "HI" ]'

    # Q12: user policy
    check "Q12: /etc/skel/START10.txt exists" 'test -f /etc/skel/START10.txt'
    check "Q12: PASS_MAX_DAYS 90" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+90" /etc/login.defs'
    check "Q12: PASS_MIN_DAYS 2" 'grep -Eq "^[[:space:]]*PASS_MIN_DAYS[[:space:]]+2" /etc/login.defs'

    # Q13: collaboration dir + default ACL
    check "Q13: group alpha10 exists" 'getent group alpha10'
    check "Q13: group beta10 exists" 'getent group beta10'
    check "Q13: /groups/alpha10 perms 2770 (SGID)" '[ "$(stat -c %a /groups/alpha10)" = "2770" ]'
    check "Q13: beta10 ACL on /groups/alpha10" 'getfacl -p /groups/alpha10 2>/dev/null | grep -q "group:beta10:r-x"'
    check "Q13: beta10 default ACL on /groups/alpha10" 'getfacl -p /groups/alpha10 2>/dev/null | grep -q "default:group:beta10:r-x"'

    # Q14: bzip2 archive with exclude
    check "Q14: /root/home10.tar.bz2 exists" 'test -f /root/home10.tar.bz2'
    check "Q14: archive is bzip2" 'file /root/home10.tar.bz2 | grep -qi bzip2'
    check "Q14: archive excludes .tmp files" '! tar tf /root/home10.tar.bz2 2>/dev/null | grep -q "\.tmp$"'

    # Q15: swap by UUID
    check "Q15: swap space active" 'swapon --show | grep -q .'
    check "Q15: swap via UUID in fstab" 'grep -i swap /etc/fstab | grep -q "UUID="'

    # Q16: SSH hardening
    check "Q16: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'
    check "Q16: PermitRootLogin no" 'sshd -T 2>/dev/null | grep -qi "^permitrootlogin no"'

    # Q17: tuned
    check "Q17: tuned profile virtual-guest" 'tuned-adm active | grep -q virtual-guest'

    # Q18: NFS fstab mount
    check "Q18: /mnt/shared10 in fstab" 'grep -q "/mnt/shared10" /etc/fstab'
    check "Q18: _netdev option used" 'grep "/mnt/shared10" /etc/fstab | grep -q "_netdev"'

    # Q19: wheel user
    check "Q19: user wheel10 exists" 'id wheel10'
    check "Q19: wheel10 in wheel group" 'id -nG wheel10 2>/dev/null | grep -qw wheel'

    # Q20: SELinux fcontext samba_share_t
    check "Q20: /srv/secure10 exists" 'test -d /srv/secure10'
    check "Q20: fcontext rule for /srv/secure10 samba_share_t" \
        'semanage fcontext -l 2>/dev/null | grep "/srv/secure10" | grep -q samba_share_t'
    check "Q20: /srv/secure10 labeled samba_share_t" 'ls -Zd /srv/secure10 2>/dev/null | grep -q samba_share_t'

    # Q21: journald persistence + size cap
    check "Q21: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q21: journald SystemMaxUse=500M" 'grep -Eq "^[[:space:]]*SystemMaxUse=500M" /etc/systemd/journald.conf'

    # Q22: carol cron every 10 min
    check "Q22: user carol exists" 'id carol'
    check "Q22: carol crontab runs every 10 min" \
        'crontab -l -u carol 2>/dev/null | grep -Eq "^[[:space:]]*\*/10[[:space:]]"'

    # Q23: ACL
    check "Q23: /var/tmp/fstab10 exists" 'test -f /var/tmp/fstab10'
    check "Q23: ACL grants dave rw" 'getfacl -p /var/tmp/fstab10 2>/dev/null | grep -q "user:dave:rw"'
    check "Q23: ACL grants alpha10 r" 'getfacl -p /var/tmp/fstab10 2>/dev/null | grep -Eq "group:alpha10:r"'

    # Q24: evenodd10.sh
    check "Q24: evenodd10.sh detects even (4 = even)" \
        '[ "$(/usr/local/bin/evenodd10.sh 4 2>/dev/null)" = "even" ]'
    check "Q24: evenodd10.sh detects odd (7 = odd)" \
        '[ "$(/usr/local/bin/evenodd10.sh 7 2>/dev/null)" = "odd" ]'

    # Q25: grep -c nologin
    check "Q25: /root/nologin10.txt exists" 'test -f /root/nologin10.txt'

    # Q26: default target + hostname
    check "Q26: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'
    check "Q26: hostname server10.example.com" '[ "$(hostnamectl --static)" = "server10.example.com" ]'

    # Q27: SELinux port 9090 + firewall
    check "Q27: SELinux http_port_t includes 9090" 'semanage port -l 2>/dev/null | grep http_port_t | grep -qw 9090'
    check "Q27: firewall allows 9090/tcp (permanent)" 'firewall-cmd --permanent --list-ports | grep -qw 9090/tcp'

    # Q28: system-wide umask
    check "Q28: /etc/profile.d umask 077" 'grep -rqs "umask[[:space:]]\+077" /etc/profile.d/'

    # Q29: links
    check "Q29: hard link /root/fstab10.hard shares inode with /etc/fstab" \
        '[ "$(stat -c %i /etc/fstab 2>/dev/null)" = "$(stat -c %i /root/fstab10.hard 2>/dev/null)" ]'
    check "Q29: soft link /root/fstab10.soft exists" 'test -L /root/fstab10.soft'

    # Q30: diskfree10.sh
    check "Q30: /usr/local/bin/diskfree10.sh executable" 'test -x /usr/local/bin/diskfree10.sh'
}
