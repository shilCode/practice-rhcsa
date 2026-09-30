# Checks for Practice Test Five (ServerB)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_five() {
    man   "Q1: root password reset to 'mypass' (not verifiable)"

    # Q2: local repo from /RHEL10.iso at /mnt/disc
    check "Q2: /mnt/disc mount in fstab" 'grep -q "/mnt/disc" /etc/fstab'
    check "Q2: BaseOS repo file:///mnt/disc/BaseOS" 'grep -rqs "file:///mnt/disc/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///mnt/disc/AppStream" 'grep -rqs "file:///mnt/disc/AppStream" /etc/yum.repos.d/'
    check "Q2: gpgcheck enabled" 'grep -rqs "gpgcheck=1" /etc/yum.repos.d/'

    # Q3: NetworkManager profile myprofile5
    check "Q3: connection myprofile5 exists" 'nmcli -t con show myprofile5'
    check "Q3: IPv4 192.168.1.6/24" 'nm_field ipv4.addresses | grep -q "192.168.1.6/24"'
    check "Q3: secondary IPv4 10.0.0.6/24" 'nm_field ipv4.addresses | grep -q "10.0.0.6/24"'
    check "Q3: IPv4 DNS 8.8.4.4" 'nm_field ipv4.dns | grep -q "8.8.4.4"'
    check "Q3: IPv6 fd01::105/64" 'nm_field ipv6.addresses | grep -q "fd01::105/64"'
    check "Q3: secondary IPv6 fd01::125/64" 'nm_field ipv6.addresses | grep -q "fd01::125/64"'
    check "Q3: DNS search google.com" 'nm_field ipv4.dns-search | grep -q "google.com"'
    check "Q3: autoconnect enabled" 'nmcli -g connection.autoconnect connection show myprofile5 2>/dev/null | grep -qi yes'

    # Q4: packet forwarding
    check "Q4: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q4: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q4: forwarding persisted" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q5: time
    check "Q5: timezone America/Los_Angeles" '[ "$(timedatectl show -p Timezone --value)" = "America/Los_Angeles" ]'
    check "Q5: chronyd enabled" 'systemctl is-enabled chronyd'

    man   "Q6: kernel update + default kernel (verify with uname -r / grubby)"

    # Q7: default target multi-user
    check "Q7: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'

    # Q8: user harry
    check "Q8: harry UID 5000" '[ "$(id -u harry 2>/dev/null)" = "5000" ]'
    check "Q8: harry has nologin shell" 'getent passwd harry | grep -q "nologin"'

    # Q9: tuned virtual-guest
    check "Q9: tuned virtual-guest active" 'tuned-adm active | grep -q virtual-guest'

    # Q10: flatpak firefox
    check "Q10: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q10: org.mozilla.firefox installed" 'flatpak list | grep -qi org.mozilla.firefox'

    # Q11: web server
    check "Q11: httpd installed" 'rpm -q httpd'
    check "Q11: index.html Hello Guys!" 'grep -qF "Hello Guys!" /var/www/html/index.html'
    check "Q11: httpd enabled" 'systemctl is-enabled httpd'
    check "Q11: firewall http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'
    check "Q11: firewall https (permanent)" 'firewall-cmd --permanent --list-services | grep -qw https'

    # Q12: find recent .conf files
    check "Q12: /find/recent_configs exists" 'test -d /find/recent_configs'

    # Q13: sum.sh positive args
    check "Q13: /sum.sh sums positive args (10 20 -5 = 30)" \
        '[ "$(/sum.sh 10 20 -5 2>/dev/null)" = "The sum is 30" ]'

    # Q14: collaboration Innovation/Solution
    check "Q14: group Innovation exists" 'getent group Innovation'
    check "Q14: group Solution exists" 'getent group Solution'
    check "Q14: /groups/Innovation SGID" 'stat -c %A /groups/Innovation | grep -q "s"'
    check "Q14: Solution ACL on Innovation" 'getfacl -p /groups/Innovation 2>/dev/null | grep -q "group:Solution:r-x"'

    # Q15: LVM custom PE size
    check "Q15: volume group myvg exists" 'vgs myvg'
    check "Q15: myvg PE size 16 MiB" 'vgdisplay myvg 2>/dev/null | grep "PE Size" | grep -q "16.00"'
    check "Q15: mylv has 50 extents" 'lvdisplay /dev/myvg/mylv 2>/dev/null | grep "Current LE" | grep -qw 50'
    check "Q15: /mnt/mylv mounted" 'findmnt /mnt/mylv'

    # Q16: systemd timer clean-tmp 16:15
    check "Q16: clean_tmp.sh executable" 'test -x /usr/local/bin/clean_tmp.sh'
    check "Q16: clean-tmp.service exists" 'test -f /etc/systemd/system/clean-tmp.service'
    check "Q16: clean-tmp.timer enabled" 'systemctl is-enabled clean-tmp.timer'
    check "Q16: timer scheduled 16:15" 'grep -q "16:15" /etc/systemd/system/clean-tmp.timer'

    # Q17: tar exclude pdf
    check "Q17: /Backup/myhome.tgz exists" 'test -f /Backup/myhome.tgz'
    check "Q17: archive excludes .pdf files" '! tar tf /Backup/myhome.tgz 2>/dev/null | grep -q "\.pdf$"'

    # Q18: swap
    check "Q18: swap active" 'swapon --show | grep -q .'
    check "Q18: swap via UUID in fstab" 'grep -i swap /etc/fstab | grep -q "UUID="'

    # Q19: user john + SSH
    check "Q19: user john exists" 'id john'
    check "Q19: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q20: hostname + hosts
    check "Q20: hostname rhel.server.com" '[ "$(hostnamectl --static)" = "rhel.server.com" ]'
    check "Q20: /etc/hosts maps 192.168.1.6" 'grep -E "192\.168\.1\.6" /etc/hosts | grep -q "rhel.server.com"'
    check "Q20: /etc/hosts maps loopback" 'grep -E "127\.0\.0\.1" /etc/hosts | grep -q "rhel.server.com"'

    # Q21: SELinux enforcing
    check "Q21: SELinux running enforcing" '[ "$(getenforce)" = "Enforcing" ]'
    check "Q21: SELinux config enforcing" 'grep -Eq "^SELINUX=enforcing" /etc/selinux/config'

    # Q22: Development Tools group installed
    check "Q22: Development Tools installed (gcc present)" 'command -v gcc'
    check "Q22: make present" 'command -v make'

    # Q23: bzip2 archive of /usr/bin
    check "Q23: /home/bin.tar.bz2 exists" 'test -f /home/bin.tar.bz2'
    check "Q23: archive is bzip2" 'file /home/bin.tar.bz2 | grep -qi bzip2'

    # Q24: global env variable
    check "Q24: VAR in /etc/environment" 'grep -Eq "^VAR=\"?RHCSA Prac Five\"?" /etc/environment'

    # Q25: journald persistence + size limit
    check "Q25: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q25: journald SystemMaxUse=100M" 'grep -Eq "^[[:space:]]*SystemMaxUse=100M" /etc/systemd/journald.conf'

    # Q26: SELinux boolean httpd_use_nfs
    check "Q26: httpd installed" 'rpm -q httpd'
    check "Q26: httpd_use_nfs boolean on" 'getsebool httpd_use_nfs 2>/dev/null | grep -q "on$"'

    # Q27: SELinux fcontext /backup
    check "Q27: /backup directory exists" 'test -d /backup'
    check "Q27: fcontext rule for /backup" 'semanage fcontext -l 2>/dev/null | grep -q "/backup"'
    check "Q27: /backup labeled home_root_t" 'ls -Zd /backup 2>/dev/null | grep -q home_root_t'

    # Q28: firewall rich rule http from subnet
    check "Q28: rich rule allows http from 192.168.1.0/24 (permanent)" \
        'firewall-cmd --permanent --list-rich-rules 2>/dev/null | grep "192.168.1.0/24" | grep -q http'

    # Q29: audit_suid.sh
    check "Q29: /usr/local/bin/audit_suid.sh executable" 'test -x /usr/local/bin/audit_suid.sh'

    # Q30: rsyslog debug
    check "Q30: rsyslog *.debug rule to file" 'grep -rqs "debug_messages.log" /etc/rsyslog.d/ /etc/rsyslog.conf'
}
