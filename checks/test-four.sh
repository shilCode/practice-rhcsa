# Checks for Practice Test Four (ServerB)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_four() {
    man   "Q1: root password reset to 'countersign' (not verifiable)"

    # Q2: DVD /dev/sr0 mounted /mnt/repo, repo with gpgcheck
    check "Q2: /mnt/repo mount in fstab" 'grep -q "/mnt/repo" /etc/fstab'
    check "Q2: BaseOS repo file:///mnt/repo/BaseOS" 'grep -rqs "file:///mnt/repo/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///mnt/repo/AppStream" 'grep -rqs "file:///mnt/repo/AppStream" /etc/yum.repos.d/'
    check "Q2: gpgcheck enabled in repo" 'grep -rqs "gpgcheck=1" /etc/yum.repos.d/'

    # Q3: static networking
    check "Q3: IPv4 192.168.1.5/24" 'nm_field ipv4.addresses | grep -q "192.168.1.5/24"'
    check "Q3: secondary IPv4 10.0.0.5/24" 'nm_field ipv4.addresses | grep -q "10.0.0.5/24"'
    check "Q3: IPv4 DNS 8.8.8.8" 'nm_field ipv4.dns | grep -q "8.8.8.8"'
    check "Q3: IPv6 fd01::105/64" 'nm_field ipv6.addresses | grep -q "fd01::105/64"'
    check "Q3: IPv6 gateway fd01::1" 'nm_field ipv6.gateway | grep -q "fd01::1"'

    # Q4: packet forwarding
    check "Q4: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q4: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q4: forwarding persisted" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q5: systemd timer notify daily 7AM
    check "Q5: notify.sh executable" 'test -x /usr/local/bin/notify.sh'
    check "Q5: notify.service exists" 'test -f /etc/systemd/system/notify.service'
    check "Q5: notify.timer enabled" 'systemctl is-enabled notify.timer'
    check "Q5: notify.timer at 07:00" 'grep -q "07:00" /etc/systemd/system/notify.timer'

    # Q6: time
    check "Q6: timezone America/Cancun" '[ "$(timedatectl show -p Timezone --value)" = "America/Cancun" ]'
    check "Q6: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q7: default target graphical
    check "Q7: default target graphical" '[ "$(systemctl get-default)" = "graphical.target" ]'

    # Q8: user john
    check "Q8: john UID 1250" '[ "$(id -u john 2>/dev/null)" = "1250" ]'
    check "Q8: john expires 2029-12-21" 'chage -l john 2>/dev/null | grep -i "Account expires" | grep -q "2029"'

    # Q9: permissions + ACLs on /var/test
    check "Q9: /var/test owner oliver" '[ "$(stat -c %U /var/test)" = "oliver" ]'
    check "Q9: /var/test group admins" '[ "$(stat -c %G /var/test)" = "admins" ]'
    check "Q9: ACL jack rw" 'getfacl -p /var/test 2>/dev/null | grep -q "user:jack:rw"'
    check "Q9: ACL jacob no access" 'getfacl -p /var/test 2>/dev/null | grep -Eq "user:jacob:---"'

    # Q10: LVM vg1/lv1
    check "Q10: volume group vg1 exists" 'vgs vg1'
    check "Q10: logical volume lv1 exists" 'lvs vg1/lv1'
    check "Q10: /lv1 mounted" 'findmnt /lv1'

    # Q11: VDO
    check "Q11: VDO volume myvdo in vdovg" 'lvs vdovg 2>/dev/null | grep -qw myvdo'
    check "Q11: /mydir mounted" 'findmnt /mydir'

    # Q12: tuned
    check "Q12: tuned virtual-guest active" 'tuned-adm active | grep -q virtual-guest'

    # Q13: web server
    check "Q13: httpd installed" 'rpm -q httpd'
    check "Q13: index.html content" 'grep -qF "Welcome to the RHCSA Exam" /var/www/html/index.html'
    check "Q13: httpd enabled" 'systemctl is-enabled httpd'
    check "Q13: firewall http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q14: archive
    check "Q14: /archive/sysconfig.tar.gz exists" 'test -f /archive/sysconfig.tar.gz'
    check "Q14: archive contains anaconda-ks.cfg" 'tar tf /archive/sysconfig.tar.gz | grep -q "anaconda-ks.cfg"'
    check "Q14: restored to /restored" 'test -d /restored/etc'

    # Q15: hostname + SSH
    check "Q15: hostname test.server.com" '[ "$(hostnamectl --static)" = "test.server.com" ]'
    check "Q15: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q16: SELinux permissive
    check "Q16: SELinux running permissive" '[ "$(getenforce)" = "Permissive" ]'
    check "Q16: SELinux config permissive" 'grep -Eq "^SELINUX=permissive" /etc/selinux/config'

    # Q17: flatpak kcalc
    check "Q17: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q17: org.kde.kcalc installed" 'flatpak list | grep -qi org.kde.kcalc'

    # Q18: umask sarah
    check "Q18: user sarah exists" 'id sarah'
    check "Q18: sarah umask 077" 'grep -Eq "umask[[:space:]]+077" /home/sarah/.bashrc'

    # Q19: redirect both streams
    check "Q19: /var/tmp/ls_output.txt exists" 'test -f /var/tmp/ls_output.txt'

    # Q20: global variable CLASS
    check "Q20: CLASS=RHCSA in /etc/profile.d" 'grep -rqs "CLASS=.*RHCSA" /etc/profile.d/'

    # Q21: regex birthdays
    check "Q21: /root/summer_birthdays.txt exists" 'test -f /root/summer_birthdays.txt'

    # Q22: process_lines.sh
    check "Q22: /usr/local/bin/process_lines.sh executable" 'test -x /usr/local/bin/process_lines.sh'

    man   "Q23: process signal SIGINT (transient - not verifiable)"

    # Q24: default target rescue (note: conflicts with Q7 graphical on same host)
    check "Q24: default target rescue" '[ "$(systemctl get-default)" = "rescue.target" ]'

    # Q25: journald persistence
    check "Q25: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q25: /var/log/journal exists" 'test -d /var/log/journal'

    # Q26: permissive domain httpd_t
    check "Q26: httpd_t is a permissive domain" 'semanage permissive -l 2>/dev/null | grep -qw httpd_t'
    check "Q26: system still enforcing" '[ "$(getenforce)" = "Enforcing" ]'

    # Q27: audit_suid.sh
    check "Q27: /usr/local/bin/audit_suid.sh executable" 'test -x /usr/local/bin/audit_suid.sh'
    check "Q27: /root/audit_results directory exists" 'test -d /root/audit_results'

    # Q28: find sam files
    check "Q28: /find/sam_files exists" 'test -d /find/sam_files'

    # Q29: at job
    check "Q29: an at job is queued" 'atq 2>/dev/null | grep -q .'

    # Q30: recursive grep report
    check "Q30: /root/error_report.txt exists" 'test -f /root/error_report.txt'
}
