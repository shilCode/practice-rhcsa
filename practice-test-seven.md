# Practice Test Seven: RHCSA 10 EX200 Practice Exam

**Question 1**

**Task:** You have forgotten the root password for **Server7**. Securely reset the root password to `seven` to regain access to the system.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

Answer:

Overall explanation

**Correct Answer:**

1. Reboot; at the GRUB menu highlight the default entry and press **e**.
2. On the `linux` line, append `rd.break` (or `init=/bin/bash`), then press **Ctrl+X** to boot.
3. Remount sysroot writable and chroot:
    1. mount -o remount,rw /sysroot
    2. chroot /sysroot
4. Set the password and force SELinux relabel:
    1. passwd root
    2. touch /.autorelabel
5. Exit twice and let the system relabel and reboot.

**Explanation**

`rd.break` stops in the initramfs before the real root is mounted normally; `/sysroot` is the real root and must be remounted `rw` before `passwd` can update `/etc/shadow`. `/.autorelabel` fixes SELinux contexts so login works after the offline change.


**Question 2**

**Task:** Configure a local DNF repository on **Server7**. Mount the image `/RHEL-10.iso` at `/mnt/iso` and configure the **BaseOS** and **AppStream** repositories from it with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

Answer:

Overall explanation

**Correct Answer:**

1. Persistently mount the ISO:
    1. echo "/RHEL-10.iso /mnt/iso iso9660 loop 0 0" >> /etc/fstab
    2. mkdir -p /mnt/iso && mount -a
2. Create `/etc/yum.repos.d/local.repo`:
    1. [BaseOS]
    2. name=BaseOS
    3. baseurl=file:///mnt/iso/BaseOS
    4. enabled=1
    5. gpgcheck=0
    6. [AppStream]
    7. name=AppStream
    8. baseurl=file:///mnt/iso/AppStream
    9. enabled=1
    10. gpgcheck=0
3. Verify: `dnf clean all && dnf repolist`.

**Explanation**

`file://` URLs point DNF at a locally mounted tree; `gpgcheck=0` avoids key errors for an offline repo. Adding the mount to `/etc/fstab` makes the repo survive a reboot.


**Question 3**

**Task:** Configure the network interface `enp1s0` on **Server7** with a persistent profile named `net7`:

- **IPv4:** `192.168.7.10/24`, Gateway `192.168.7.1`, DNS `8.8.8.8`.
- **IPv6:** `fd07::10/64`, Gateway `fd07::1`.
- **Secondary IPv4:** `10.7.0.5/24`.
- Ensure it starts automatically at boot.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses, Persistence).

Answer:

Overall explanation

**Correct Answer:**

1. nmcli con add con-name net7 ifname enp1s0 type ethernet \
2. ipv4.method manual ipv4.addresses 192.168.7.10/24 ipv4.gateway 192.168.7.1 ipv4.dns 8.8.8.8 \
3. ipv6.method manual ipv6.addresses fd07::10/64 ipv6.gateway fd07::1
4. nmcli con mod net7 +ipv4.addresses 10.7.0.5/24
5. nmcli con mod net7 connection.autoconnect yes
6. nmcli con up net7

**Explanation**

`ipv4.method manual` / `ipv6.method manual` disable DHCP/SLAAC. The leading `+` on `+ipv4.addresses` **appends** the secondary address instead of overwriting the primary. The profile (not a runtime `ip addr add`) is what persists across reboots.


**Question 4**

**Task:** On **Server7**, set the timezone to **Asia/Tokyo** and configure `chrony` to keep time synchronized using `pool.ntp.org`.

- **Aspects/Domains Covered:** Operate running systems (Configure time service clients).

Answer:

Overall explanation

**Correct Answer:**

1. timedatectl set-timezone Asia/Tokyo
2. echo "pool pool.ntp.org iburst" >> /etc/chrony.conf
3. systemctl enable --now chronyd
4. chronyc sources

**Explanation**

`timedatectl` writes the timezone symlink; `chronyd` (enabled so it survives reboot) synchronizes the clock against the configured NTP pool.


**Question 5**

**Task:** On **Server7**, add the **Flathub** remote and install the **org.gnome.Calculator** Flatpak application system-wide.

- **Aspects/Domains Covered:** Manage software (Install and update software using Flatpak).

Answer:

Overall explanation

**Correct Answer:**

1. flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
2. flatpak install -y flathub org.gnome.Calculator

**Explanation**

`remote-add --if-not-exists` registers the Flathub repository; installing by application ID pulls the app and its runtime.


**Question 6**

**Task:** On **Server7**, create a volume group `vg7`, a 500 MiB logical volume `lv7`, format it XFS, and mount it persistently at `/data7`.

- **Aspects/Domains Covered:** Manage storage (Create and configure LVM, mount persistently).

Answer:

Overall explanation

**Correct Answer:**

1. pvcreate /dev/vdb
2. vgcreate vg7 /dev/vdb
3. lvcreate -L 500M -n lv7 vg7
4. mkfs.xfs /dev/vg7/lv7
5. mkdir /data7
6. echo "/dev/vg7/lv7 /data7 xfs defaults 0 0" >> /etc/fstab
7. mount -a

**Explanation**

The PV→VG→LV chain provides flexible storage; the `/etc/fstab` entry makes the mount persistent. Always test with `mount -a` before rebooting.


**Question 7**

**Task:** On **Server7**, create a systemd **timer** named `backup7` that runs `/usr/local/bin/backup7.sh` daily. Enable the timer.

- **Aspects/Domains Covered:** Operate running systems (Schedule tasks using systemd timers).

Answer:

Overall explanation

**Correct Answer:**

1. Create `/usr/local/bin/backup7.sh` (executable).
2. `/etc/systemd/system/backup7.service`:
    1. [Service]
    2. ExecStart=/usr/local/bin/backup7.sh
3. `/etc/systemd/system/backup7.timer`:
    1. [Timer]
    2. OnCalendar=daily
    3. [Install]
    4. WantedBy=timers.target
4. systemctl daemon-reload && systemctl enable --now backup7.timer

**Explanation**

A `.timer` triggers its matching `.service`. `OnCalendar=daily` fires at midnight; enabling ties it to `timers.target` so it starts at boot.


**Question 8**

**Task:** On **Server7**, install and enable `httpd`. Create `/var/www/html/index.html` containing `Welcome to Server7` and open the `http` service in the firewall permanently.

- **Aspects/Domains Covered:** Deploy and manage web servers, Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y httpd
2. echo "Welcome to Server7" > /var/www/html/index.html
3. systemctl enable --now httpd
4. firewall-cmd --permanent --add-service=http && firewall-cmd --reload

**Explanation**

`--permanent` writes the rule to disk; `--reload` applies it. Enabling `httpd` ensures it starts at boot.


**Question 9**

**Task:** On **Server7**, find all files under `/usr` larger than **50 MiB** and copy them into `/root/large7/`.

- **Aspects/Domains Covered:** Understand and use essential tools (find/locate files).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /root/large7
2. find /usr -type f -size +50M -exec cp {} /root/large7/ \;

**Explanation**

`-size +50M` matches files strictly larger than 50 MiB; `-exec ... {} \;` runs the copy per match.


**Question 10**

**Task:** On **Server7**, remove the `rhgb` and `quiet` parameters from the default kernel command line so boot messages are visible.

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).

Answer:

Overall explanation

**Correct Answer:**

1. grubby --update-kernel=ALL --remove-args="rhgb quiet"
2. grubby --info=DEFAULT   # verify

**Explanation**

`grubby` edits the persisted kernel arguments directly. Removing `rhgb quiet` exposes verbose boot output.


**Question 11**

**Task:** On **Server7**, create an executable script `/usr/local/bin/greet7.sh` that prints `Hello, <name>` where `<name>` is its first argument.

- **Aspects/Domains Covered:** Create simple shell scripts.

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. echo "Hello, $1"

Then `chmod +x /usr/local/bin/greet7.sh`.

**Explanation**

`$1` is the first positional parameter. The script must be executable to run directly.


**Question 12**

**Task:** On **Server7**, configure user account policy: add `/etc/skel/README7.txt`, set `PASS_MAX_DAYS` to **45**, and set password `minlen` to **10**.

- **Aspects/Domains Covered:** Manage users and groups, Configure password policies.

Answer:

Overall explanation

**Correct Answer:**

1. echo "Welcome" > /etc/skel/README7.txt
2. sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 45/' /etc/login.defs
3. echo "minlen = 10" >> /etc/security/pwquality.conf

**Explanation**

`/etc/skel` seeds new home directories; `login.defs` sets aging defaults; `pwquality.conf` enforces password complexity.


**Question 13**

**Task:** On **Server7**, create a group `eng7` and a shared directory `/opt/eng7` owned by that group with the **SGID** bit set (mode `2770`).

- **Aspects/Domains Covered:** Manage group collaboration directories (special permissions).

Answer:

Overall explanation

**Correct Answer:**

1. groupadd eng7
2. mkdir /opt/eng7
3. chgrp eng7 /opt/eng7
4. chmod 2770 /opt/eng7

**Explanation**

The SGID bit (`2` in `2770`) makes new files inherit the directory's group, enabling group collaboration.


**Question 14**

**Task:** On **Server7**, create a gzip-compressed tar archive `/root/ssh7.tar.gz` containing `/etc/ssh`.

- **Aspects/Domains Covered:** Archive, compress, unpack files (tar/gzip).

Answer:

Overall explanation

**Correct Answer:**

1. tar czf /root/ssh7.tar.gz /etc/ssh

**Explanation**

`c` create, `z` gzip, `f` file. Verify with `tar tf /root/ssh7.tar.gz`.


**Question 15**

**Task:** On **Server7**, add a **512 MiB** logical-volume swap named `swap7` in `vg7` and make it persistent.

- **Aspects/Domains Covered:** Manage storage (Configure swap).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate -L 512M -n swap7 vg7
2. mkswap /dev/vg7/swap7
3. echo "/dev/vg7/swap7 none swap defaults 0 0" >> /etc/fstab
4. swapon -a

**Explanation**

`mkswap` formats the device as swap; the `fstab` entry with `swapon -a` activates it persistently.


**Question 16**

**Task:** On **Server7**, harden SSH by disabling **password authentication**.

- **Aspects/Domains Covered:** Configure SSH (Configure key-based authentication and security).

Answer:

Overall explanation

**Correct Answer:**

1. echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/99-hardening.conf
2. systemctl reload sshd
3. sshd -T | grep passwordauthentication   # verify

**Explanation**

Drop-in files in `sshd_config.d/` override the main config cleanly; `sshd -T` prints the effective runtime configuration.


**Question 17**

**Task:** On **Server7**, install `tuned` and apply the **balanced** profile.

- **Aspects/Domains Covered:** Operate running systems (Adjust tuning profiles).

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y tuned
2. systemctl enable --now tuned
3. tuned-adm profile balanced
4. tuned-adm active   # verify

**Explanation**

`tuned-adm profile` selects a persistent performance profile managed by the `tuned` daemon.


**Question 18**

**Task:** On **Server7**, install and enable **autofs**, and configure it to automount an NFS export at `/shares`.

- **Aspects/Domains Covered:** Manage network file systems (autofs).

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y autofs
2. echo "/shares /etc/auto.shares" >> /etc/auto.master.d/shares.autofs
3. echo "data -rw server:/exports/data" > /etc/auto.shares
4. systemctl enable --now autofs

**Explanation**

The master map ties `/shares` to a map file; autofs mounts subdirectories on demand and unmounts them when idle.


**Question 19**

**Task:** On **Server7**, create user `devon` and grant a sudo rule allowing `devon` to run `dnf` with **NOPASSWD**.

- **Aspects/Domains Covered:** Manage users, Configure sudo.

Answer:

Overall explanation

**Correct Answer:**

1. useradd devon
2. echo "devon ALL=(ALL) NOPASSWD: /usr/bin/dnf" > /etc/sudoers.d/devon
3. visudo -cf /etc/sudoers.d/devon   # validate syntax

**Explanation**

Drop-in files under `/etc/sudoers.d/` are included by the main sudoers; `NOPASSWD` skips the password prompt for the listed command only.


**Question 20**

**Task:** On **Server7**, create an LVM **VDO** (deduplicated/compressed) volume `vdo7` and mount it at `/vdo7`.

- **Aspects/Domains Covered:** Manage storage (Configure and manage VDO / advanced LVM).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate --type vdo -n vdo7 -L 5G -V 20G vgvdo /dev/vdc
2. mkfs.xfs /dev/vgvdo/vdo7
3. mkdir /vdo7
4. echo "/dev/vgvdo/vdo7 /vdo7 xfs defaults,x-systemd.requires=vdo.service 0 0" >> /etc/fstab
5. mount -a

**Explanation**

A VDO LV provides transparent deduplication and compression; `-V` sets the virtual (provisioned) size larger than the physical backing.


**Question 21**

**Task:** On **Server7**, make the systemd journal **persistent** across reboots.

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /var/log/journal
2. sed -i 's/^#\?Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
3. systemctl restart systemd-journald

**Explanation**

Creating `/var/log/journal` and setting `Storage=persistent` keeps logs across reboots instead of the default volatile `/run`.


**Question 22**

**Task:** On **Server7**, start a background process `sleep 900`, then change its scheduling priority (nice value) to `10`.

- **Aspects/Domains Covered:** Operate running systems (Identify and manage processes).

Answer:

Overall explanation

**Correct Answer:**

1. sleep 900 &
2. renice 10 -p $!

**Explanation**

`$!` is the PID of the last background job; `renice` adjusts its priority. (Transient — verified live, not after reboot.)


**Question 23**

**Task:** On **Server7**, copy `/etc/fstab` to `/var/tmp/fstab7` and grant user `grace` **read/write** access via an ACL.

- **Aspects/Domains Covered:** Manage file security (Access Control Lists).

Answer:

Overall explanation

**Correct Answer:**

1. cp /etc/fstab /var/tmp/fstab7
2. setfacl -m u:grace:rw /var/tmp/fstab7
3. getfacl /var/tmp/fstab7   # verify

**Explanation**

`setfacl -m u:grace:rw` adds a per-user ACL entry beyond the standard owner/group/other permissions.


**Question 24**

**Task:** On **Server7**, create an executable script `/usr/local/bin/useraudit7.sh` that loops over all users in `/etc/passwd` and prints their username and UID.

- **Aspects/Domains Covered:** Create simple shell scripts (loops, processing input).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. while IFS=: read -r user _ uid _; do
3.   echo "$user $uid"
4. done < /etc/passwd

Then `chmod +x`.

**Explanation**

`IFS=:` splits each line on colons; the loop reads the username and UID fields directly from `/etc/passwd`.


**Question 25**

**Task:** On **Server7**, extract every line containing the word `Server` from `/etc/ssh/sshd_config` into `/root/sshmatch7.txt`.

- **Aspects/Domains Covered:** Understand and use essential tools (grep / regular expressions).

Answer:

Overall explanation

**Correct Answer:**

1. grep "Server" /etc/ssh/sshd_config > /root/sshmatch7.txt

**Explanation**

`grep` filters matching lines; `>` redirects them into the target file.


**Question 26**

**Task:** On **Server7**, set the default systemd target to **multi-user** (text mode).

- **Aspects/Domains Covered:** Operate running systems (Boot systems into specific targets).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl set-default multi-user.target

**Explanation**

`set-default` re-points the `default.target` symlink so the system boots to the chosen target.


**Question 27**

**Task:** On **Server7**, configure `httpd` to listen on port **8707**. Update SELinux and the firewall to allow it.

- **Aspects/Domains Covered:** Manage SELinux (port labeling), Manage firewalls, Deploy web servers.

Answer:

Overall explanation

**Correct Answer:**

1. sed -i 's/^Listen 80/Listen 8707/' /etc/httpd/conf/httpd.conf
2. semanage port -a -t http_port_t -p tcp 8707
3. firewall-cmd --permanent --add-port=8707/tcp && firewall-cmd --reload
4. systemctl restart httpd

**Explanation**

A confined service can only bind ports carrying the right SELinux type; `semanage port -a` authorizes `8707` for `http_port_t`, and the firewall must also allow it.


**Question 28**

**Task:** On **Server7**, ensure user `harper`'s default **umask** is `027`.

- **Aspects/Domains Covered:** Manage users (Configure default permissions).

Answer:

Overall explanation

**Correct Answer:**

1. echo "umask 027" >> /home/harper/.bashrc

**Explanation**

A `027` umask yields `750` directories / `640` files, restricting group-write and all "other" access for that user.


**Question 29**

**Task:** On **Server7**, securely copy `/root/ssh7.tar.gz` to `/tmp` on the host `192.168.7.20` using `scp`.

- **Aspects/Domains Covered:** Access remote systems (Securely transfer files).

Answer:

Overall explanation

**Correct Answer:**

1. scp /root/ssh7.tar.gz root@192.168.7.20:/tmp/

**Explanation**

`scp` transfers files over SSH. (Transient — depends on the remote host being reachable; not verified after reboot.)


**Question 30**

**Task:** On **Server7**, create an executable script `/usr/local/bin/checkfile7.sh` that takes a filename argument and prints `exists` if it is a regular file, otherwise `missing`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals, file tests).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. if [ -f "$1" ]; then
3.   echo "exists"
4. else
5.   echo "missing"
6. fi

Then `chmod +x`.

**Explanation**

`[ -f "$1" ]` tests whether the argument is an existing regular file; the `if/else` prints the appropriate message.
