# Checks for Practice Test Three (ServerB)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_three() {
    man   "Q1: root password reset to 'passmypass' (not verifiable)"

    # Q2: HTTP repositories on 192.168.1.12
    check "Q2: BaseOS repo via http://192.168.1.12" 'grep -rqs "http://192.168.1.12/rhel10/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo via http://192.168.1.12" 'grep -rqs "http://192.168.1.12/rhel10/AppStream" /etc/yum.repos.d/'

    # Q3: static networking
    check "Q3: IPv4 192.168.1.4/24" 'nm_field ipv4.addresses | grep -q "192.168.1.4/24"'
    check "Q3: secondary IPv4 10.0.0.4/24" 'nm_field ipv4.addresses | grep -q "10.0.0.4/24"'
    check "Q3: IPv4 DNS 8.8.8.8" 'nm_field ipv4.dns | grep -q "8.8.8.8"'
    check "Q3: IPv6 fd01::103/64" 'nm_field ipv6.addresses | grep -q "fd01::103/64"'
    check "Q3: IPv6 gateway fd01::100" 'nm_field ipv6.gateway | grep -q "fd01::100"'
    check "Q3: IPv6 DNS fd01::111" 'nm_field ipv6.dns | grep -q "fd01::111"'

    # Q4: packet forwarding
    check "Q4: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q4: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q4: forwarding persisted" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q5: systemd timer break-time (every 2h)
    check "Q5: break-time.sh executable" 'test -x /usr/local/bin/break-time.sh'
    check "Q5: break-time.service exists" 'test -f /etc/systemd/system/break-time.service'
    check "Q5: break-time.timer enabled" 'systemctl is-enabled break-time.timer'

    # Q6: standard partition mounted /mnt/data via UUID
    check "Q6: /mnt/data mounted" 'findmnt /mnt/data'
    check "Q6: /mnt/data via UUID in fstab" 'grep "/mnt/data" /etc/fstab | grep -q "UUID="'

    # Q7: users
    check "Q7: sam shell /bin/bash" 'getent passwd sam | grep -q ":/bin/bash$"'
    check "Q7: john UID 1250" '[ "$(id -u john 2>/dev/null)" = "1250" ]'
    check "Q7: john expires 2029-12-21" 'chage -l john 2>/dev/null | grep -i "Account expires" | grep -q "2029"'

    # Q8: ACLs on /var/nhosts
    check "Q8: /var/nhosts exists" 'test -f /var/nhosts'
    check "Q8: ACL sam rwx" 'getfacl -p /var/nhosts 2>/dev/null | grep -q "user:sam:rwx"'
    check "Q8: ACL john r--" 'getfacl -p /var/nhosts 2>/dev/null | grep -Eq "user:john:r--"'

    # Q9: flatpak Calculator
    check "Q9: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q9: org.gnome.Calculator installed" 'flatpak list | grep -qi org.gnome.Calculator'

    # Q10: LVM vgroup/lvol
    check "Q10: volume group vgroup exists" 'vgs vgroup'
    check "Q10: logical volume lvol exists" 'lvs vgroup/lvol'
    check "Q10: /lvol mounted" 'findmnt /lvol'

    # Q11: tuned combined
    check "Q11: tuned virtual-guest active" 'tuned-adm active | grep -q virtual-guest'
    check "Q11: tuned powersave active" 'tuned-adm active | grep -q powersave'

    # Q12: sum.sh (interactive)
    check "Q12: /usr/local/bin/sum.sh executable" 'test -x /usr/local/bin/sum.sh'

    # Q13: web server
    check "Q13: httpd installed" 'rpm -q httpd'
    check "Q13: index.html content" 'grep -qF "Welcome to the RHCSA Practice Exam!" /var/www/html/index.html'
    check "Q13: httpd enabled" 'systemctl is-enabled httpd'
    check "Q13: firewall http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'
    check "Q13: firewall https (permanent)" 'firewall-cmd --permanent --list-services | grep -qw https'

    # Q14: find 5m files
    check "Q14: /find/5mfiles exists" 'test -d /find/5mfiles'

    # Q15: policies
    check "Q15: /etc/skel/Welcome exists" 'test -f /etc/skel/Welcome'
    check "Q15: PASS_MAX_DAYS 60" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+60" /etc/login.defs'
    check "Q15: pwquality minlen 9" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*9" /etc/security/pwquality.conf'

    # Q16: collaboration accounting/finance
    check "Q16: group accounting exists" 'getent group accounting'
    check "Q16: group finance exists" 'getent group finance'
    check "Q16: /groups/accounting SGID" 'stat -c %A /groups/accounting | grep -q "s"'
    check "Q16: finance ACL on accounting" 'getfacl -p /groups/accounting 2>/dev/null | grep -q "group:finance:r-x"'
    check "Q16: finance default ACL on accounting" 'getfacl -p /groups/accounting 2>/dev/null | grep -q "default:group:finance:r-x"'

    # Q17: SSH permit root login
    check "Q17: PermitRootLogin yes" 'sshd -T 2>/dev/null | grep -qi "^permitrootlogin yes"'

    # Q18: SELinux enforcing
    check "Q18: SELinux running enforcing" '[ "$(getenforce)" = "Enforcing" ]'
    check "Q18: SELinux config enforcing" 'grep -Eq "^SELINUX=enforcing" /etc/selinux/config'

    man   "Q19: sed sam->Sam newletter (path relative to cwd - not verifiable)"
    man   "Q20: echo redirect sample.txt (relative path - not verifiable)"

    # Q21: cron job
    check "Q21: root cron deletes empty /tmp files" \
        'crontab -l -u root 2>/dev/null | grep -q "find /tmp"'

    # Q22: umask harry
    check "Q22: harry umask 027" 'grep -Eq "umask[[:space:]]+027" /home/harry/.bashrc'

    # Q23: sticky dir
    check "Q23: /data/shared perms 1777 (sticky)" '[ "$(stat -c %a /data/shared)" = "1777" ]'

    man   "Q24: exported shell variables (transient - not verifiable)"
    man   "Q25: nice/renice on sleep (transient - not verifiable)"

    # Q26: user-list.sh
    check "Q26: /usr/local/bin/user-list.sh executable" 'test -x /usr/local/bin/user-list.sh'

    # Q27: LVM thin provisioning
    check "Q27: thin volume thin_vol exists" 'lvs | grep -qw thin_vol'
    check "Q27: /mnt/thin mounted" 'findmnt /mnt/thin'

    # Q28: find_suid.sh
    check "Q28: /root/find_suid.sh executable" 'test -x /root/find_suid.sh'

    # Q29: GRUB timeout
    check "Q29: GRUB_TIMEOUT set to 10" 'grep -Eq "^GRUB_TIMEOUT=10" /etc/default/grub'

    # Q30: permission fix
    check "Q30: /home/secret_data perms 640" '[ "$(stat -c %a /home/secret_data)" = "640" ]'
    check "Q30: /home/secret_data group admins" '[ "$(stat -c %G /home/secret_data)" = "admins" ]'
}
