# Checks for Practice Test Two (ServerB)
# Sourced by rhcsa-validator.sh -- uses: check, man, nm_field

check_test_two() {
    man   "Q1: root password reset to 'secret' (not verifiable)"

    # Q2: ISO /RHEL-10.iso mounted at /repo, local repo
    check "Q2: /repo mount configured in fstab" 'grep -q "/repo" /etc/fstab'
    check "Q2: BaseOS repo file:///repo/BaseOS" 'grep -rqs "file:///repo/BaseOS" /etc/yum.repos.d/'
    check "Q2: AppStream repo file:///repo/AppStream" 'grep -rqs "file:///repo/AppStream" /etc/yum.repos.d/'

    # Q3: static networking
    check "Q3: IPv4 192.168.1.3/24" 'nm_field ipv4.addresses | grep -q "192.168.1.3/24"'
    check "Q3: secondary IPv4 10.0.0.3/24" 'nm_field ipv4.addresses | grep -q "10.0.0.3/24"'
    check "Q3: IPv4 gateway 192.168.1.1" 'nm_field ipv4.gateway | grep -q "192.168.1.1"'
    check "Q3: IPv4 DNS 8.8.8.8" 'nm_field ipv4.dns | grep -q "8.8.8.8"'
    check "Q3: IPv6 fd01::103/64" 'nm_field ipv6.addresses | grep -q "fd01::103/64"'
    check "Q3: secondary IPv6 fd01::200/64" 'nm_field ipv6.addresses | grep -q "fd01::200/64"'
    check "Q3: IPv6 gateway fd01::1" 'nm_field ipv6.gateway | grep -q "fd01::1"'

    # Q4: time
    check "Q4: timezone Europe/London" '[ "$(timedatectl show -p Timezone --value)" = "Europe/London" ]'
    check "Q4: chronyd enabled" 'systemctl is-enabled chronyd'

    # Q5: packet forwarding
    check "Q5: IPv4 forwarding on" '[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]'
    check "Q5: IPv6 forwarding on" '[ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "1" ]'
    check "Q5: forwarding persisted in sysctl.d" 'grep -rqs "net.ipv4.ip_forward" /etc/sysctl.d/ /etc/sysctl.conf'

    # Q6: bootloader rhgb/quiet removed
    check "Q6: rhgb/quiet removed from default kernel" \
        '! grubby --info=DEFAULT 2>/dev/null | grep "^args=" | grep -Eq "rhgb|quiet"'

    # Q7: LVM vgmyvg/lvmylv
    check "Q7: volume group vgmyvg exists" 'vgs vgmyvg'
    check "Q7: logical volume lvmylv exists" 'lvs vgmyvg/lvmylv'
    check "Q7: /lvmylv mounted" 'findmnt /lvmylv'
    check "Q7: /lvmylv in fstab" 'grep -q "lvmylv" /etc/fstab'

    # Q8: web server
    check "Q8: httpd installed" 'rpm -q httpd'
    check "Q8: index.html Hello World!" 'grep -qF "Hello World!" /var/www/html/index.html'
    check "Q8: httpd enabled" 'systemctl is-enabled httpd'
    check "Q8: firewall http (permanent)" 'firewall-cmd --permanent --list-services | grep -qw http'
    check "Q8: firewall https (permanent)" 'firewall-cmd --permanent --list-services | grep -qw https'

    # Q9: yes-no.sh
    check "Q9: yes-no.sh executable" 'test -x /usr/local/bin/yes-no.sh'
    check "Q9: yes-no.sh handles yes" '[ "$(/usr/local/bin/yes-no.sh YES 2>/dev/null)" = "That is nice" ]'
    check "Q9: yes-no.sh handles no" '[ "$(/usr/local/bin/yes-no.sh No 2>/dev/null)" = "I am sorry" ]'

    man   "Q10: kernel update + default kernel (verify with: uname -r / grubby)"

    # Q11: hostname
    check "Q11: hostname rhel.server.com" '[ "$(hostnamectl --static)" = "rhel.server.com" ]'

    # Q12: find root files
    check "Q12: /find/rootfiles exists" 'test -d /find/rootfiles'

    # Q13: policies
    check "Q13: /etc/skel/Note exists" 'test -f /etc/skel/Note'
    check "Q13: PASS_MAX_DAYS 100" 'grep -Eq "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+100" /etc/login.defs'
    check "Q13: pwquality minlen 9" 'grep -Eq "^[[:space:]]*minlen[[:space:]]*=[[:space:]]*9" /etc/security/pwquality.conf'

    # Q14: user sam
    check "Q14: user sam UID 1500" '[ "$(id -u sam 2>/dev/null)" = "1500" ]'
    check "Q14: sam has nologin shell" 'getent passwd sam | grep -q "nologin"'

    # Q15: ACLs on /var/tmp/fstab
    check "Q15: /var/tmp/fstab exists" 'test -f /var/tmp/fstab'
    check "Q15: ACL stewart rw" 'getfacl -p /var/tmp/fstab 2>/dev/null | grep -q "user:stewart:rw"'
    check "Q15: ACL kevin no access" 'getfacl -p /var/tmp/fstab 2>/dev/null | grep -Eq "user:kevin:---"'

    # Q16: systemd timer clean-tmp
    check "Q16: clean-tmp.sh executable" 'test -x /usr/local/bin/clean-tmp.sh'
    check "Q16: clean-tmp.service exists" 'test -f /etc/systemd/system/clean-tmp.service'
    check "Q16: clean-tmp.timer enabled" 'systemctl is-enabled clean-tmp.timer'

    # Q17: archive
    check "Q17: /archive/myetc.tbz2 exists" 'test -f /archive/myetc.tbz2'
    check "Q17: archive is bzip2" 'file /archive/myetc.tbz2 | grep -qi bzip2'
    check "Q17: restored into /restored/myetc" 'test -d /restored/myetc'

    # Q18: tuned powersave
    check "Q18: tuned profile powersave" 'tuned-adm active | grep -q powersave'

    # Q19: SSH hardening + user alice
    check "Q19: user alice exists" 'id alice'
    check "Q19: PermitRootLogin no" 'sshd -T 2>/dev/null | grep -qi "^permitrootlogin no"'
    check "Q19: PasswordAuthentication no" 'sshd -T 2>/dev/null | grep -qi "^passwordauthentication no"'

    # Q20: swap
    check "Q20: swap active" 'swapon --show | grep -q .'
    check "Q20: swap in fstab" 'grep -qi swap /etc/fstab'

    # Q21: alias + redirection
    check "Q21: myfiles alias in root .bashrc" 'grep -Eq "alias[[:space:]]+myfiles=" /root/.bashrc'
    check "Q21: /root/http_services.txt exists" 'test -f /root/http_services.txt'

    # Q22: NFS fstab mount
    check "Q22: /nfs_share in fstab" 'grep -q "/nfs_share" /etc/fstab'
    check "Q22: _netdev option used" 'grep "/nfs_share" /etc/fstab | grep -q "_netdev"'

    # Q23: SELinux fcontext /web
    check "Q23: /web/content/html/index.html exists" 'test -f /web/content/html/index.html'
    check "Q23: fcontext rule for /web" 'semanage fcontext -l 2>/dev/null | grep -q "/web"'
    check "Q23: /web labeled httpd_sys_content_t" 'ls -Zd /web 2>/dev/null | grep -q httpd_sys_content_t'

    # Q24: links
    check "Q24: /home/root/data.txt exists" 'test -f /home/root/data.txt'
    check "Q24: hard link data-hard shares inode" \
        '[ "$(stat -c %i /home/root/data.txt 2>/dev/null)" = "$(stat -c %i /home/root/data-hard 2>/dev/null)" ]'
    check "Q24: soft link /var/tmp/data-soft exists" 'test -L /var/tmp/data-soft'

    # Q25: cron.allow
    check "Q25: cron.allow contains tom" 'grep -qx "tom" /etc/cron.allow'

    # Q26: SELinux enforcing
    check "Q26: SELinux running enforcing" '[ "$(getenforce)" = "Enforcing" ]'
    check "Q26: SELinux config enforcing" 'grep -Eq "^SELINUX=enforcing" /etc/selinux/config'

    # Q27: flatpak gimp
    check "Q27: flathub remote added" 'flatpak remotes | grep -qi flathub'
    check "Q27: GIMP installed" 'flatpak list | grep -qi org.gimp.GIMP'

    # Q28: collaboration dir
    check "Q28: group managers exists" 'getent group managers'
    check "Q28: /collaboration group managers" '[ "$(stat -c %G /collaboration)" = "managers" ]'
    check "Q28: /collaboration SGID set" 'stat -c %A /collaboration | grep -q "s"'

    # Q29: zsh installed
    check "Q29: zsh installed" 'rpm -q zsh'

    man   "Q30: transient process priority/kill - not verifiable"
}
