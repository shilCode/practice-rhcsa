# Checks for Practice Test Eight (Server8)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_eight() {
    man   "Q1: root password reset to 'eight' (not verifiable)"

    # Q2: HTTP repos from 192.168.8.1
    check "Q2: BaseOS repo http://192.168.8.1/rhel10/BaseOS" 'grep -rqs "http://192.168.8.1/rhel10/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo http://192.168.8.1/rhel10/AppStream" 'grep -rqs "http://192.168.8.1/rhel10/AppStream" /etc/yum.repos.d/'

    # Q3: NetworkManager profile net8
    check "Q3: connection net8 exists" 'nmcli -t con show net8'
    check "Q3: IPv4 192.168.8.10/24" 'nm_field ipv4.addresses | grep -q "192.168.8.10/24"'
    check "Q3: secondary IPv4 10.8.0.5/24" 'nm_field ipv4.addresses | grep -q "10.8.0.5/24"'
    check "Q3: IPv4 gateway 192.168.8.1" 'nm_field ipv4.gateway | grep -q "192.168.8.1"'
    check "Q3: IPv6 fd08::10/64" 'nm_field ipv6.addresses | grep -q "fd08::10/64"'
    check "Q3: IPv6 gateway fd08::1" 'nm_field ipv6.gateway | grep -q "fd08::1"'
    check "Q3: autoconnect enabled" 'nmcli -g connection.autoconnect connection show net8 2>/dev/null | grep -qi yes'

    # Q4: time
    check "Q4: timezone Europe/Paris" '[ "$(timedatectl show -p Timezone --value)" = "Europe/Paris" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q5: flatpak
    check "Q5: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q5: org.gnome.TextEditor installed" 'flatpak list | grep -qi org.gnome.TextEditor'

    # Q6: LVM vg8/lv8 on /data8
    check "Q6: volume group vg8 exists" 'vgs vg8'
    check "Q6: logical volume lv8 exists" 'lvs vg8/lv8'
    check "Q6: /data8 mounted" 'findmnt /data8'
    check "Q6: /data8 persistent in fstab" 'grep -q "/data8" /etc/fstab'

    # Q7: cron job backup8
    check "Q7: /usr/local/bin/backup8.sh executable" 'test -x /usr/local/bin/backup8.sh'
    check "Q7: /etc/cron.d/backup8 runs 02:30 as root" \
        'grep -E "^[[:space:]]*30[[:space:]]+2[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+root" /etc/cron.d/backup8 2>/dev/null | grep -q "backup8.sh"'

    # Q8: web server
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html content" 'grep -q "Server8 Web" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall allows http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q9: find files owned by bob
    check "Q9: /root/bobfiles8 directory exists" 'test -d /root/bobfiles8'

    # Q10: GRUB timeout 5
    check "Q10: GRUB_TIMEOUT set to 5" 'grep -Eq "^GRUB_TIMEOUT=5" /etc/default/grub'

    # Q11: sumargs8.sh
    check "Q11: sumargs8.sh sums two args (7 8 = 15)" \
        '[ "$(/usr/local/bin/sumargs8.sh 7 8 2>/dev/null)" = "15" ]'

    # Q12: user policy
    check "Q12: /etc/skel/NOTES8.txt exists" 'test -f /etc/skel/NOTES8.txt'
    check "Q12: PASS_MAX_DAYS 30" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+30" /etc/login.defs'
    check "Q12: pwquality minlen 12" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*12" /etc/security/pwquality.conf'

    # Q13: collaboration dir
    check "Q13: group ops8 exists" 'getent group ops8'
    check "Q13: /srv/ops8 group owner ops8" '[ "$(stat -c %G /srv/ops8)" = "ops8" ]'
    check "Q13: /srv/ops8 perms 2770 (SGID)" '[ "$(stat -c %a /srv/ops8)" = "2770" ]'

    # Q14: bzip2 archive
    check "Q14: /root/repos8.tar.bz2 exists" 'test -f /root/repos8.tar.bz2'
    check "Q14: archive is bzip2" 'file /root/repos8.tar.bz2 | grep -qi bzip2'

    # Q15: swap
    check "Q15: swap space active" 'swapon --show | grep -q .'
    check "Q15: swap entry in fstab" 'grep -qi swap /etc/fstab'

    # Q16: SSH deny root
    check "Q16: PermitRootLogin no" 'sshd -T 2>/dev/null | grep -qi "^permitrootlogin no"'

    # Q17: tuned
    check "Q17: tuned profile powersave" 'tuned-adm active | grep -q powersave'

    # Q18: NFS fstab mount
    check "Q18: /mnt/nfs8 in fstab" 'grep -q "/mnt/nfs8" /etc/fstab'
    check "Q18: _netdev option used" 'grep "/mnt/nfs8" /etc/fstab | grep -q "_netdev"'

    # Q19: sudo group admin8
    check "Q19: group admin8 exists" 'getent group admin8'
    check "Q19: user pat in admin8" 'id -nG pat 2>/dev/null | grep -qw admin8'
    check "Q19: admin8 group sudo rule" 'grep -rqs "%admin8[[:space:]].*ALL" /etc/sudoers /etc/sudoers.d/'

    # Q20: LVM thin
    check "Q20: thin pool thinpool8 exists" 'lvs | grep -qw thinpool8'
    check "Q20: thin volume thinvol8 exists" 'lvs | grep -qw thinvol8'
    check "Q20: /thin8 mounted" 'findmnt /thin8'

    # Q21: journald persistence + size cap
    check "Q21: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q21: journald SystemMaxUse=200M" 'grep -Eq "^[[:space:]]*SystemMaxUse=200M" /etc/systemd/journald.conf'

    # Q22: at job
    check "Q22: an at job is queued" 'atq 2>/dev/null | grep -q .'

    # Q23: ACL
    check "Q23: /var/tmp/hosts8 exists" 'test -f /var/tmp/hosts8'
    check "Q23: ACL grants quinn rw" 'getfacl -p /var/tmp/hosts8 2>/dev/null | grep -q "user:quinn:rw"'
    check "Q23: ACL denies sam" 'getfacl -p /var/tmp/hosts8 2>/dev/null | grep -Eq "user:sam:---"'

    # Q24: countargs8.sh
    check "Q24: countargs8.sh counts args (a b c = 3)" \
        '[ "$(/usr/local/bin/countargs8.sh a b c 2>/dev/null)" = "3" ]'

    # Q25: grep bash users
    check "Q25: /root/bashusers8.txt exists" 'test -f /root/bashusers8.txt'

    # Q26: default target graphical
    check "Q26: default target graphical" '[ "$(systemctl get-default)" = "graphical.target" ]'

    # Q27: SELinux fcontext + boolean
    check "Q27: /web8 exists" 'test -d /web8'
    check "Q27: fcontext rule for /web8 httpd_sys_content_t" \
        'semanage fcontext -l 2>/dev/null | grep "/web8" | grep -q httpd_sys_content_t'
    check "Q27: /web8 labeled httpd_sys_content_t" 'ls -Zd /web8 2>/dev/null | grep -q httpd_sys_content_t'
    check "Q27: boolean httpd_can_network_connect on" \
        'getsebool httpd_can_network_connect 2>/dev/null | grep -q "on$"'

    # Q28: umask molly
    check "Q28: molly umask 077" 'grep -Eq "umask[[:space:]]+077" /home/molly/.bashrc'

    man   "Q29: rsync mirror /etc -> /backup/etc8 (verify: test -d /backup/etc8)"

    # Q30: checkuser8.sh
    check "Q30: /usr/local/bin/checkuser8.sh executable" 'test -x /usr/local/bin/checkuser8.sh'
}
