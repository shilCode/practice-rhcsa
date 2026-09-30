# Checks for Practice Test Six (ServerC, renamed to ServerB)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_six() {
    man   "Q1: root password reset to 'watchword' (not verifiable)"

    # Q2: HTTP repos from ServerB /dvd
    check "Q2: BaseOS repo via http://ServerB/dvd/BaseOS" 'grep -rqs "ServerB/dvd/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo via http://ServerB/dvd/AppStream" 'grep -rqs "ServerB/dvd/AppStream" /etc/yum.repos.d/'

    # Q3: hostname + boot target
    check "Q3: hostname ServerB" '[ "$(hostnamectl --static)" = "ServerB" ]'
    check "Q3: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'

    # Q4: NetworkManager profile myprofile6
    check "Q4: connection myprofile6 exists" 'nmcli -t con show myprofile6'
    check "Q4: IPv4 192.168.1.7/24" 'nm_field ipv4.addresses | grep -q "192.168.1.7/24"'
    check "Q4: secondary IPv4 10.0.0.7/24" 'nm_field ipv4.addresses | grep -q "10.0.0.7/24"'
    check "Q4: IPv4 DNS 8.8.8.8" 'nm_field ipv4.dns | grep -q "8.8.8.8"'
    check "Q4: IPv6 fd01::107/64" 'nm_field ipv6.addresses | grep -q "fd01::107/64"'
    check "Q4: IPv6 gateway fd01::100" 'nm_field ipv6.gateway | grep -q "fd01::100"'
    check "Q4: autoconnect enabled" 'nmcli -g connection.autoconnect connection show myprofile6 2>/dev/null | grep -qi yes'

    # Q5: packet forwarding
    check "Q5: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q5: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q5: forwarding persisted" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q6: time
    check "Q6: timezone America/Chicago" '[ "$(timedatectl show -p Timezone --value)" = "America/Chicago" ]'
    check "Q6: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q7: default target graphical (note: conflicts with Q3 multi-user)
    check "Q7: default target graphical" '[ "$(systemctl get-default)" = "graphical.target" ]'

    # Q8: user john
    check "Q8: john UID 1234" '[ "$(id -u john 2>/dev/null)" = "1234" ]'
    check "Q8: john expires 2030-06-21" 'chage -l john 2>/dev/null | grep -i "Account expires" | grep -q "2030"'

    # Q9: permissions + ACL on /tmp/tmpfile
    check "Q9: /tmp/tmpfile owner leo" '[ "$(stat -c %U /tmp/tmpfile)" = "leo" ]'
    check "Q9: /tmp/tmpfile group science" '[ "$(stat -c %G /tmp/tmpfile)" = "science" ]'
    check "Q9: ACL james rwx" 'getfacl -p /tmp/tmpfile 2>/dev/null | grep -q "user:james:rwx"'

    # Q10: LVM vg6/lv6
    check "Q10: volume group vg6 exists" 'vgs vg6'
    check "Q10: logical volume lv6 exists" 'lvs vg6/lv6'
    check "Q10: /lv6 mounted" 'findmnt /lv6'

    # Q11: LVM thin (renamed thinpool2/thinvol2)
    check "Q11: thin pool thinpool2 exists" 'lvs | grep -qw thinpool2'
    check "Q11: thin volume thinvol2 exists" 'lvs | grep -qw thinvol2'
    check "Q11: /thinvol2 mounted" 'findmnt /thinvol2'

    # Q12: tuned combined
    check "Q12: tuned virtual-guest active" 'tuned-adm active | grep -q virtual-guest'
    check "Q12: tuned powersave active" 'tuned-adm active | grep -q powersave'

    # Q13: web server
    check "Q13: httpd installed" 'rpm -q httpd'
    check "Q13: index.html Hello World!" 'grep -qF "Hello World!" /var/www/html/index.html'
    check "Q13: httpd enabled" 'systemctl is-enabled httpd'
    check "Q13: firewall http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q14: find root files
    check "Q14: /find/rootfiles exists" 'test -d /find/rootfiles'

    # Q15: flatpak Calculator
    check "Q15: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q15: org.gnome.Calculator installed" 'flatpak list | grep -qi org.gnome.Calculator'

    # Q16: sum.sh positive args
    check "Q16: /sum.sh sums positive args (5 10 -3 20 = 35)" \
        '[ "$(/sum.sh 5 10 -3 20 2>/dev/null)" = "The sum is 35" ]'

    # Q17: collaboration Innovation/Solution
    check "Q17: group Innovation exists" 'getent group Innovation'
    check "Q17: group Solution exists" 'getent group Solution'
    check "Q17: /groups/Innovation SGID" 'stat -c %A /groups/Innovation | grep -q "s"'
    check "Q17: Solution ACL on Innovation" 'getfacl -p /groups/Innovation 2>/dev/null | grep -q "group:Solution:r-x"'

    # Q18: LVM custom PE size
    check "Q18: volume group myvg exists" 'vgs myvg'
    check "Q18: myvg PE size 16 MiB" 'vgdisplay myvg 2>/dev/null | grep "PE Size" | grep -q "16.00"'
    check "Q18: mylv has 50 extents" 'lvdisplay /dev/myvg/mylv 2>/dev/null | grep "Current LE" | grep -qw 50'
    check "Q18: /mnt/mylv mounted" 'findmnt /mnt/mylv'

    # Q19: systemd timer cleanup 16:15
    check "Q19: cleanup.sh executable" 'test -x /usr/local/bin/cleanup.sh'
    check "Q19: cleanup.service exists" 'test -f /etc/systemd/system/cleanup.service'
    check "Q19: cleanup.timer enabled" 'systemctl is-enabled cleanup.timer'
    check "Q19: timer scheduled 16:15" 'grep -q "16:15" /etc/systemd/system/cleanup.timer'

    # Q20: tar exclude pdf
    check "Q20: /Backup/myhome.tgz exists" 'test -f /Backup/myhome.tgz'
    check "Q20: archive excludes .pdf" '! tar tf /Backup/myhome.tgz 2>/dev/null | grep -q "\.pdf$"'

    # Q21: standard partition /mnt/drive via UUID
    check "Q21: /mnt/drive mounted" 'findmnt /mnt/drive'
    check "Q21: /mnt/drive via UUID in fstab" 'grep "/mnt/drive" /etc/fstab | grep -q "UUID="'

    # Q22: swap 1G via UUID
    check "Q22: swap active" 'swapon --show | grep -q .'
    check "Q22: swap via UUID in fstab" 'grep -i swap /etc/fstab | grep -q "UUID="'

    # Q23: SSH key auth for john
    check "Q23: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q24: hostname rhel.server.com (note: conflicts with Q3 ServerB)
    check "Q24: hostname rhel.server.com" '[ "$(hostnamectl --static)" = "rhel.server.com" ]'

    # Q25: SELinux enforcing
    check "Q25: SELinux running enforcing" '[ "$(getenforce)" = "Enforcing" ]'
    check "Q25: SELinux config enforcing" 'grep -Eq "^SELINUX=enforcing" /etc/selinux/config'

    # Q26: VDO
    check "Q26: VDO volume myvdo in vdovg" 'lvs vdovg 2>/dev/null | grep -qw myvdo'
    check "Q26: /vdo mounted" 'findmnt /vdo'

    # Q27: firewall rich rule ssh from subnet
    check "Q27: rich rule allows ssh from 192.168.1.0/24 (permanent)" \
        'firewall-cmd --permanent --list-rich-rules 2>/dev/null | grep "192.168.1.0/24" | grep -q ssh'

    # Q28: global var + HISTFILESIZE
    check "Q28: VAR=RHCSA in /etc/profile.d" 'grep -rqs "VAR=.*RHCSA" /etc/profile.d/'
    check "Q28: HISTFILESIZE 2000 configured" 'grep -rqs "HISTFILESIZE=2000" /etc/profile.d/ /etc/profile /etc/bashrc'

    # Q29: vsftpd + SELinux boolean
    check "Q29: vsftpd installed" 'rpm -q vsftpd'
    check "Q29: vsftpd enabled" 'systemctl is-enabled vsftpd'
    check "Q29: firewall allows ftp (permanent)" 'firewall-cmd --permanent --list-services | grep -qw ftp'
    check "Q29: ftpd_full_access boolean on" 'getsebool ftpd_full_access 2>/dev/null | grep -q "on$"'

    man   "Q30: kernel default index / remove 'quiet' (verify with grubby --info=DEFAULT)"
}
