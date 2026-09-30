# Practice Test Ten: RHCSA 10 EX200 Practice Exam

**Question 1**

**Task:** You have forgotten the root password for **Server10**. Securely reset the root password to `ten`.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process to gain access).

Answer:

Overall explanation

**Correct Answer:**

1. At GRUB, press **e**; append `rd.break`; **Ctrl+X**.
2. mount -o remount,rw /sysroot
3. chroot /sysroot
4. passwd root
5. touch /.autorelabel
6. exit; exit

**Explanation**

`/sysroot` must be writable before `passwd`; `/.autorelabel` fixes SELinux contexts on the next boot.

**Question 2**

**Task:** Configure a local DNF repository on **Server10** from `/RHEL-10.iso` mounted at `/mnt/repo10`, exposing **BaseOS** and **AppStream** with GPG checking **enabled** (import the key from the media).

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

Answer:

Overall explanation

**Correct Answer:**

1. echo "/RHEL-10.iso /mnt/repo10 iso9660 loop 0 0" >> /etc/fstab
2. mkdir -p /mnt/repo10 && mount -a
3. Create `/etc/yum.repos.d/repo10.repo` with BaseOS/AppStream `baseurl=file:///mnt/repo10/...`, `enabled=1`, `gpgcheck=1`, `gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`.
4. dnf clean all && dnf repolist

**Explanation**

`gpgcheck=1` with a valid `gpgkey` verifies package signatures — the secure, production-correct configuration.

**Question 3**

**Task:** Configure `enp1s0` on **Server10** with a persistent profile `net10`:

- **IPv4:** `192.168.10.10/24`, Gateway `192.168.10.1`, DNS `8.8.4.4`.
- **IPv6:** `fd0a::10/64`, Gateway `fd0a::1`, DNS `fd0a::53`.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

Answer:

Overall explanation

**Correct Answer:**

1. nmcli con add con-name net10 ifname enp1s0 type ethernet \
2. ipv4.method manual ipv4.addresses 192.168.10.10/24 ipv4.gateway 192.168.10.1 ipv4.dns 8.8.4.4 \
3. ipv6.method manual ipv6.addresses fd0a::10/64 ipv6.gateway fd0a::1 ipv6.dns fd0a::53
4. nmcli con up net10

**Explanation**

Both `manual` methods disable automatic addressing; the profile persists the static IPv4 and IPv6 configuration.

**Question 4**

**Task:** On **Server10**, set the timezone to **Australia/Sydney** and enable `chronyd`.

- **Aspects/Domains Covered:** Operate running systems (Time service clients).

Answer:

Overall explanation

**Correct Answer:**

1. timedatectl set-timezone Australia/Sydney
2. systemctl enable --now chronyd

**Explanation**

`timedatectl` persists the timezone; `chronyd` synchronizes and starts at boot.

**Question 5**

**Task:** On **Server10**, enable **IPv4 and IPv6 packet forwarding** and make both settings persistent.

- **Aspects/Domains Covered:** Operate running systems (Modify kernel runtime parameters).

Answer:

Overall explanation

**Correct Answer:**

1. Create `/etc/sysctl.d/99-forward.conf`:
   1. net.ipv4.ip_forward = 1
   2. net.ipv6.conf.all.forwarding = 1
2. sysctl -p /etc/sysctl.d/99-forward.conf

**Explanation**

Dropping the parameters into `/etc/sysctl.d/` makes them persist; `sysctl -p` applies them immediately.

**Question 6**

**Task:** On **Server10**, create volume group `vg10` with a **16 MiB** PE size, a logical volume `lv10` of **50 extents**, format XFS, and mount persistently at `/data10`.

- **Aspects/Domains Covered:** Manage storage (LVM with custom PE size and extents).

Answer:

Overall explanation

**Correct Answer:**

1. pvcreate /dev/vdb
2. vgcreate -s 16M vg10 /dev/vdb
3. lvcreate -l 50 -n lv10 vg10
4. mkfs.xfs /dev/vg10/lv10
5. mkdir /data10
6. echo "/dev/vg10/lv10 /data10 xfs defaults 0 0" >> /etc/fstab && mount -a

**Explanation**

`-s 16M` sets the PE size; `-l 50` requests 50 extents (50 × 16 MiB = 800 MiB). The fstab entry persists the mount.

**Question 7**

**Task:** On **Server10**, create a systemd **timer** `cleanup10` that runs `/usr/local/bin/cleanup10.sh` at **16:15** daily.

- **Aspects/Domains Covered:** Operate running systems (systemd timers).

Answer:

Overall explanation

**Correct Answer:**

1. Create `/usr/local/bin/cleanup10.sh` (executable).
2. `/etc/systemd/system/cleanup10.service` → `ExecStart=/usr/local/bin/cleanup10.sh`.
3. `/etc/systemd/system/cleanup10.timer`:
   1. [Timer]
   2. OnCalendar=_-_-\* 16:15:00
   3. [Install]
   4. WantedBy=timers.target
4. systemctl daemon-reload && systemctl enable --now cleanup10.timer

**Explanation**

`OnCalendar=*-*-* 16:15:00` schedules a daily 16:15 run; enabling ties the timer to `timers.target`.

**Question 8**

**Task:** On **Server10**, install/enable `httpd`, put `Server10 OK` in `/var/www/html/index.html`, and allow `http` and `https` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y httpd
2. echo "Server10 OK" > /var/www/html/index.html
3. systemctl enable --now httpd
4. firewall-cmd --permanent --add-service={http,https} && firewall-cmd --reload

**Explanation**

Adding both services permanently and reloading opens ports 80 and 443 across reboots.

**Question 9**

**Task:** On **Server10**, find all files under `/etc` with permissions `777` and list them in `/root/world10.txt`.

- **Aspects/Domains Covered:** Essential tools (find by permission).

Answer:

Overall explanation

**Correct Answer:**

1. find /etc -type f -perm 0777 > /root/world10.txt

**Explanation**

`-perm 0777` matches files with exactly those permission bits; `>` records the list.

**Question 10**

**Task:** On **Server10**, set the GRUB **timeout** to **10** seconds and regenerate the config.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

Answer:

Overall explanation

**Correct Answer:**

1. sed -i 's/^GRUB_TIMEOUT=.\*/GRUB_TIMEOUT=10/' /etc/default/grub
2. grub2-mkconfig -o /boot/grub2/grub.cfg

**Explanation**

`GRUB_TIMEOUT=10` sets the menu delay; regeneration writes it into the active config.

**Question 11**

**Task:** On **Server10**, create an executable script `/usr/local/bin/upper10.sh` that prints its first argument in UPPERCASE.

- **Aspects/Domains Covered:** Create simple shell scripts (parameter expansion).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. echo "${1^^}"

Then `chmod +x`.

**Explanation**

`${1^^}` upper-cases every character of the first argument using bash parameter expansion.

**Question 12**

**Task:** On **Server10**, add `/etc/skel/START10.txt`, set `PASS_MAX_DAYS` to **90**, `PASS_MIN_DAYS` to **2**.

- **Aspects/Domains Covered:** Manage users, Password aging.

Answer:

Overall explanation

**Correct Answer:**

1. echo "start" > /etc/skel/START10.txt
2. sed -i 's/^PASS_MAX_DAYS.\*/PASS_MAX_DAYS 90/' /etc/login.defs
3. sed -i 's/^PASS_MIN_DAYS.\*/PASS_MIN_DAYS 2/' /etc/login.defs

**Explanation**

`login.defs` sets the default aging applied to newly created accounts.

**Question 13**

**Task:** On **Server10**, create groups `alpha10` and `beta10`, a shared SGID directory `/groups/alpha10` (mode `2770`) owned by `alpha10`, and grant `beta10` read/execute via a default ACL.

- **Aspects/Domains Covered:** Group collaboration, Default ACLs.

Answer:

Overall explanation

**Correct Answer:**

1. groupadd alpha10; groupadd beta10
2. mkdir -p /groups/alpha10
3. chgrp alpha10 /groups/alpha10 && chmod 2770 /groups/alpha10
4. setfacl -m g:beta10:rx /groups/alpha10
5. setfacl -d -m g:beta10:rx /groups/alpha10

**Explanation**

`setfacl -d` sets a **default** ACL so files created later inherit `beta10:rx` access.

**Question 14**

**Task:** On **Server10**, create a bzip2 archive `/root/home10.tar.bz2` of `/home`, excluding any `*.tmp` files.

- **Aspects/Domains Covered:** Archive and compress (tar with exclude).

Answer:

Overall explanation

**Correct Answer:**

1. tar cjf /root/home10.tar.bz2 --exclude='\*.tmp' /home

**Explanation**

`--exclude='*.tmp'` skips matching files; `j` selects bzip2 compression.

**Question 15**

**Task:** On **Server10**, add a **1 GiB** swap logical volume `swap10` in `vg10` referenced by **UUID** in `/etc/fstab`.

- **Aspects/Domains Covered:** Manage storage (swap by UUID).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate -L 1G -n swap10 vg10
2. mkswap /dev/vg10/swap10
3. blkid /dev/vg10/swap10 # note the UUID
4. echo "UUID=<uuid> none swap defaults 0 0" >> /etc/fstab
5. swapon -a

**Explanation**

Referencing swap by UUID is robust against device-name changes; `swapon -a` activates all fstab swap.

**Question 16**

**Task:** On **Server10**, harden SSH: disable **password authentication** and **root login**.

- **Aspects/Domains Covered:** Configure SSH security.

Answer:

Overall explanation

**Correct Answer:**

1. printf "PasswordAuthentication no\nPermitRootLogin no\n" > /etc/ssh/sshd_config.d/99-harden.conf
2. systemctl reload sshd
3. sshd -T | grep -E "passwordauthentication|permitrootlogin"

**Explanation**

Both directives in a drop-in file enforce key-based, non-root SSH access.

**Question 17**

**Task:** On **Server10**, apply the `tuned` **virtual-guest** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl enable --now tuned
2. tuned-adm profile virtual-guest

**Explanation**

`virtual-guest` optimizes a VM guest; `tuned-adm profile` persists the selection.

**Question 18**

**Task:** On **Server10**, mount an NFS export `nfs:/exports/shared10` persistently at `/mnt/shared10` with the `_netdev` option.

- **Aspects/Domains Covered:** Manage network file systems (NFS).

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y nfs-utils
2. mkdir -p /mnt/shared10
3. echo "nfs:/exports/shared10 /mnt/shared10 nfs \_netdev 0 0" >> /etc/fstab
4. mount -a

**Explanation**

`_netdev` ensures the mount waits for the network, avoiding boot delays/hangs.

**Question 19**

**Task:** On **Server10**, create user `wheel10`, add them to the `wheel` group, and confirm `wheel` has sudo access.

- **Aspects/Domains Covered:** Manage users/groups, sudo.

Answer:

Overall explanation

**Correct Answer:**

1. useradd -G wheel wheel10
2. id wheel10 # verify group membership

**Explanation**

The `wheel` group already has a sudo rule in `/etc/sudoers` on RHEL; adding the user grants them full sudo.

**Question 20**

**Task:** On **Server10**, create a directory `/srv/secure10`, apply a persistent SELinux type `samba_share_t`, and relabel it.

- **Aspects/Domains Covered:** Manage SELinux (file contexts).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /srv/secure10
2. semanage fcontext -a -t samba_share_t "/srv/secure10(/.\*)?"
3. restorecon -Rv /srv/secure10

**Explanation**

`semanage fcontext -a` records the labeling rule persistently; `restorecon` applies it. Unlike `chcon`, it survives a full relabel.

**Question 21**

**Task:** On **Server10**, make the journal persistent and set `SystemMaxUse` to **500M**.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /var/log/journal
2. sed -i 's/^#\?Storage=.\*/Storage=persistent/' /etc/systemd/journald.conf
3. sed -i 's/^#\?SystemMaxUse=.\*/SystemMaxUse=500M/' /etc/systemd/journald.conf
4. systemctl restart systemd-journald

**Explanation**

`Storage=persistent` keeps logs; `SystemMaxUse=500M` caps their disk usage.

**Question 22**

**Task:** On **Server10**, set a cron job for user `carol` that appends the date to `/home/carol/log.txt` every **10 minutes**.

- **Aspects/Domains Covered:** Schedule tasks (user cron).

Answer:

Overall explanation

**Correct Answer:**

1. useradd carol
2. crontab -u carol -e
   1. _/10 _ \* \* \* date >> /home/carol/log.txt

**Explanation**

`*/10` in the minute field runs the job every 10 minutes as user `carol`.

**Question 23**

**Task:** On **Server10**, copy `/etc/fstab` to `/var/tmp/fstab10` and grant user `dave` read/write plus group `alpha10` read via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

Answer:

Overall explanation

**Correct Answer:**

1. cp /etc/fstab /var/tmp/fstab10
2. setfacl -m u:dave:rw /var/tmp/fstab10
3. setfacl -m g:alpha10:r /var/tmp/fstab10

**Explanation**

User and group ACL entries provide fine-grained access beyond the standard permission bits.

**Question 24**

**Task:** On **Server10**, create an executable script `/usr/local/bin/evenodd10.sh` that prints `even` or `odd` for its integer argument.

- **Aspects/Domains Covered:** Create simple shell scripts (arithmetic, conditionals).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. if (( $1 % 2 == 0 )); then echo "even"; else echo "odd"; fi

Then `chmod +x`.

**Explanation**

`(( $1 % 2 == 0 ))` evaluates the remainder; an even number yields zero.

**Question 25**

**Task:** On **Server10**, count how many lines in `/etc/passwd` use `/sbin/nologin` and write the number to `/root/nologin10.txt`.

- **Aspects/Domains Covered:** Essential tools (grep -c).

Answer:

Overall explanation

**Correct Answer:**

1. grep -c "/sbin/nologin" /etc/passwd > /root/nologin10.txt

**Explanation**

`grep -c` prints the count of matching lines instead of the lines themselves.

**Question 26**

**Task:** On **Server10**, set the default boot target to **multi-user** and set the hostname to `server10.example.com`.

- **Aspects/Domains Covered:** Operate running systems (Boot targets, hostname).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl set-default multi-user.target
2. hostnamectl set-hostname server10.example.com

**Explanation**

`set-default` chooses text mode; `hostnamectl set-hostname` persists the static hostname in `/etc/hostname`.

**Question 27**

**Task:** On **Server10**, add TCP port **9090** to the SELinux `http_port_t` type and open it in the firewall permanently.

- **Aspects/Domains Covered:** Manage SELinux (ports), Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. semanage port -a -t http_port_t -p tcp 9090
2. firewall-cmd --permanent --add-port=9090/tcp && firewall-cmd --reload

**Explanation**

The SELinux port label authorizes the httpd domain to bind 9090; the firewall must also allow the port.

**Question 28**

**Task:** On **Server10**, set the system-wide default **umask** to `077` via a file in `/etc/profile.d/`.

- **Aspects/Domains Covered:** Manage users (system default permissions).

Answer:

Overall explanation

**Correct Answer:**

1. echo "umask 077" > /etc/profile.d/umask10.sh

**Explanation**

Scripts in `/etc/profile.d/` are sourced at login, applying the umask for all interactive users.

**Question 29**

**Task:** On **Server10**, create a **hard link** `/root/fstab10.hard` and a **soft link** `/root/fstab10.soft`, both pointing at `/etc/fstab`.

- **Aspects/Domains Covered:** Understand and use essential tools (links).

Answer:

Overall explanation

**Correct Answer:**

1. ln /etc/fstab /root/fstab10.hard
2. ln -s /etc/fstab /root/fstab10.soft

**Explanation**

A hard link shares the target's inode; a symbolic link (`-s`) is a separate file pointing at the path.

**Question 30**

**Task:** On **Server10**, create an executable script `/usr/local/bin/diskfree10.sh` that prints the used percentage of the root filesystem.

- **Aspects/Domains Covered:** Create simple shell scripts (command substitution).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. df --output=pcent / | tail -1 | tr -d ' %'

Then `chmod +x`.

**Explanation**

`df --output=pcent /` prints the root filesystem usage percentage; `tail`/`tr` strip the header and formatting.
