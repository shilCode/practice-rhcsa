# Checks for Practice Test Seven (Server7)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_seven() {
    man   "Q1: root password reset to 'seven' (not verifiable)"

    # Q2: local DNF repo from ISO at /mnt/iso
    check "Q2: BaseOS repo file:///mnt/iso/BaseOS" 'grep -rqs "file:///mnt/iso/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///mnt/iso/AppStream" 'grep -rqs "file:///mnt/iso/AppStream" /etc/yum.repos.d/'
    check "Q2: /mnt/iso mount in fstab" 'grep -q "/mnt/iso" /etc/fstab'

    # Q3: NetworkManager profile net7
    check "Q3: connection net7 exists" 'nmcli -t con show net7'
    check "Q3: IPv4 192.168.7.10/24" 'nm_field ipv4.addresses | grep -q "192.168.7.10/24"'
    check "Q3: secondary IPv4 10.7.0.5/24" 'nm_field ipv4.addresses | grep -q "10.7.0.5/24"'
    check "Q3: IPv4 gateway 192.168.7.1" 'nm_field ipv4.gateway | grep -q "192.168.7.1"'
    check "Q3: IPv6 fd07::10/64" 'nm_field ipv6.addresses | grep -q "fd07::10/64"'
    check "Q3: IPv6 gateway fd07::1" 'nm_field ipv6.gateway | grep -q "fd07::1"'

    # Q4: time
    check "Q4: timezone Asia/Tokyo" '[ "$(timedatectl show -p Timezone --value)" = "Asia/Tokyo" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'
    check "Q4: pool.ntp.org configured" 'grep -Eqrs "pool.ntp.org" /etc/chrony.conf /etc/chrony.d/ 2>/dev/null'

    # Q5: flatpak
    check "Q5: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q5: org.gnome.Calculator installed" 'flatpak list | grep -qi org.gnome.Calculator'

    # Q6: LVM vg7/lv7 on /data7
    check "Q6: volume group vg7 exists" 'vgs vg7'
    check "Q6: logical volume lv7 exists" 'lvs vg7/lv7'
    check "Q6: /data7 mounted" 'findmnt /data7'
    check "Q6: /data7 persistent in fstab" 'grep -q "/data7" /etc/fstab'

    # Q7: systemd timer backup7
    check "Q7: /usr/local/bin/backup7.sh executable" 'test -x /usr/local/bin/backup7.sh'
    check "Q7: backup7.service exists" 'test -f /etc/systemd/system/backup7.service'
    check "Q7: backup7.timer enabled" 'systemctl is-enabled backup7.timer'

    # Q8: web server
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html content" 'grep -q "Welcome to Server7" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall allows http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'

    # Q9: find large files
    check "Q9: /root/large7 directory exists" 'test -d /root/large7'

    # Q10: bootloader rhgb/quiet removed
    check "Q10: rhgb/quiet removed from default kernel" \
        '! grubby --info=DEFAULT 2>/dev/null | grep "^args=" | grep -Eq "rhgb|quiet"'

    # Q11: greet7.sh
    check "Q11: greet7.sh greets by first arg" \
        '[ "$(/usr/local/bin/greet7.sh Ada 2>/dev/null)" = "Hello, Ada" ]'

    # Q12: user policy
    check "Q12: /etc/skel/README7.txt exists" 'test -f /etc/skel/README7.txt'
    check "Q12: PASS_MAX_DAYS 45" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+45" /etc/login.defs'
    check "Q12: pwquality minlen 10" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*10" /etc/security/pwquality.conf'

    # Q13: collaboration dir
    check "Q13: group eng7 exists" 'getent group eng7'
    check "Q13: /opt/eng7 group owner eng7" '[ "$(stat -c %G /opt/eng7)" = "eng7" ]'
    check "Q13: /opt/eng7 perms 2770 (SGID)" '[ "$(stat -c %a /opt/eng7)" = "2770" ]'

    # Q14: ssh archive
    check "Q14: /root/ssh7.tar.gz exists" 'test -f /root/ssh7.tar.gz'
    check "Q14: archive contains etc/ssh" 'tar tf /root/ssh7.tar.gz | grep -q "etc/ssh"'

    # Q15: swap
    check "Q15: swap space active" 'swapon --show | grep -q .'
    check "Q15: swap entry in fstab" 'grep -qi swap /etc/fstab'

    # Q16: SSH hardening
    check "Q16: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q17: tuned
    check "Q17: tuned profile balanced" 'tuned-adm active | grep -q balanced'

    # Q18: autofs
    check "Q18: autofs installed" 'rpm -q autofs'
    check "Q18: /shares configured in auto.master" 'grep -rqs "/shares" /etc/auto.master /etc/auto.master.d/ 2>/dev/null'
    check "Q18: autofs enabled" 'systemctl is-enabled autofs'

    # Q19: sudo for devon
    check "Q19: user devon exists" 'id devon'
    check "Q19: devon NOPASSWD dnf sudo rule" 'grep -rqs "NOPASSWD:.*dnf" /etc/sudoers /etc/sudoers.d/'

    # Q20: VDO
    check "Q20: VDO logical volume vdo7 exists" 'lvs | grep -qw vdo7'
    check "Q20: /vdo7 mounted" 'findmnt /vdo7'

    # Q21: journald persistence
    check "Q21: journald Storage=persistent" 'grep -Eq "^[[:space:]]*Storage=persistent" /etc/systemd/journald.conf'
    check "Q21: /var/log/journal exists" 'test -d /var/log/journal'

    man   "Q22: transient process renice - not verifiable"

    # Q23: ACL
    check "Q23: /var/tmp/fstab7 exists" 'test -f /var/tmp/fstab7'
    check "Q23: ACL grants grace rw" 'getfacl -p /var/tmp/fstab7 2>/dev/null | grep -q "user:grace:rw"'

    # Q24: audit loop script
    check "Q24: /usr/local/bin/useraudit7.sh executable" 'test -x /usr/local/bin/useraudit7.sh'

    # Q25: grep Server lines
    check "Q25: /root/sshmatch7.txt exists" 'test -f /root/sshmatch7.txt'

    # Q26: default target
    check "Q26: default target multi-user" '[ "$(systemctl get-default)" = "multi-user.target" ]'

    # Q27: httpd on port 8707
    check "Q27: httpd Listen 8707" 'grep -Eq "^[[:space:]]*Listen[[:space:]]+8707" /etc/httpd/conf/httpd.conf'
    check "Q27: SELinux http_port_t includes 8707" 'semanage port -l 2>/dev/null | grep http_port_t | grep -qw 8707'
    check "Q27: firewall allows 8707/tcp (permanent)" 'firewall-cmd --permanent --list-ports | grep -qw 8707/tcp'

    # Q28: umask for harper
    check "Q28: harper umask 027" 'grep -Eq "umask[[:space:]]+027" /home/harper/.bashrc'

    man   "Q29: scp transfer - transient, not verifiable"

    # Q30: checkfile7.sh
    check "Q30: /usr/local/bin/checkfile7.sh executable" 'test -x /usr/local/bin/checkfile7.sh'
}
