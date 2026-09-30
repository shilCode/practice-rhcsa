# Practice Test Eight: RHCSA 10 EX200 Practice Exam

**Question 1**

**Task:** You have forgotten the root password for **Server8**. Securely reset the root password to `eight` to regain access.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process to gain access).

Answer:

Overall explanation

**Correct Answer:**

1. At GRUB, press **e**; append `rd.break` to the `linux` line; **Ctrl+X**.
2. mount -o remount,rw /sysroot
3. chroot /sysroot
4. passwd root
5. touch /.autorelabel
6. exit; exit

**Explanation**

`/sysroot` must be writable before `passwd` can edit `/etc/shadow`; `/.autorelabel` restores SELinux contexts after the offline change.

**Question 2**

**Task:** Configure **Server8** to use HTTP repositories: **BaseOS** at `http://192.168.8.1/rhel10/BaseOS` and **AppStream** at `http://192.168.8.1/rhel10/AppStream`, with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

Answer:

Overall explanation

**Correct Answer:**

Create `/etc/yum.repos.d/http.repo`:

1. [BaseOS]
2. name=BaseOS
3. baseurl=http://192.168.8.1/rhel10/BaseOS
4. enabled=1
5. gpgcheck=0
6. [AppStream]
7. name=AppStream
8. baseurl=http://192.168.8.1/rhel10/AppStream
9. enabled=1
10. gpgcheck=0

Then `dnf clean all && dnf repolist`.

**Explanation**

HTTP `baseurl`s let DNF pull packages from a network server; `gpgcheck=0` avoids signature errors when no key is imported.

**Question 3**

**Task:** Configure `enp1s0` on **Server8** with a persistent profile `net8`:

- **IPv4:** `192.168.8.10/24`, Gateway `192.168.8.1`, DNS `1.1.1.1`.
- **IPv6:** `fd08::10/64`, Gateway `fd08::1`.
- **Secondary IPv4:** `10.8.0.5/24`. Autoconnect enabled.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

Answer:

Overall explanation

**Correct Answer:**

1. nmcli con add con-name net8 ifname enp1s0 type ethernet \
2. ipv4.method manual ipv4.addresses 192.168.8.10/24 ipv4.gateway 192.168.8.1 ipv4.dns 1.1.1.1 \
3. ipv6.method manual ipv6.addresses fd08::10/64 ipv6.gateway fd08::1
4. nmcli con mod net8 +ipv4.addresses 10.8.0.5/24
5. nmcli con mod net8 connection.autoconnect yes
6. nmcli con up net8

**Explanation**

The `+` prefix appends the secondary address; `manual` methods disable automatic addressing so the static values persist.

**Question 4**

**Task:** On **Server8**, set the timezone to **Europe/Paris** and enable `chronyd` for time sync.

- **Aspects/Domains Covered:** Operate running systems (Configure time service clients).

Answer:

Overall explanation

**Correct Answer:**

1. timedatectl set-timezone Europe/Paris
2. systemctl enable --now chronyd

**Explanation**

`timedatectl` persists the timezone; `chronyd` maintains synchronization and starts at boot when enabled.

**Question 5**

**Task:** On **Server8**, add the **Flathub** remote and install **org.gnome.TextEditor**.

- **Aspects/Domains Covered:** Manage software (Flatpak).

Answer:

Overall explanation

**Correct Answer:**

1. flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
2. flatpak install -y flathub org.gnome.TextEditor

**Explanation**

Flatpak apps are installed by reverse-DNS ID from a registered remote such as Flathub.

**Question 6**

**Task:** On **Server8**, create volume group `vg8`, logical volume `lv8` of **300 MiB**, format XFS, mount persistently at `/data8`.

- **Aspects/Domains Covered:** Manage storage (LVM, persistent mounts).

Answer:

Overall explanation

**Correct Answer:**

1. pvcreate /dev/vdb
2. vgcreate vg8 /dev/vdb
3. lvcreate -L 300M -n lv8 vg8
4. mkfs.xfs /dev/vg8/lv8
5. mkdir /data8
6. echo "/dev/vg8/lv8 /data8 xfs defaults 0 0" >> /etc/fstab && mount -a

**Explanation**

The fstab entry makes the mount survive reboot; `mount -a` validates it immediately.

**Question 7**

**Task:** On **Server8**, create a **cron** job (in `/etc/cron.d/backup8`) that runs `/usr/local/bin/backup8.sh` every day at **02:30** as `root`.

- **Aspects/Domains Covered:** Operate running systems (Schedule tasks using cron).

Answer:

Overall explanation

**Correct Answer:**

1. Create `/usr/local/bin/backup8.sh` (executable).
2. echo "30 2 \* \* \* root /usr/local/bin/backup8.sh" > /etc/cron.d/backup8

**Explanation**

Files in `/etc/cron.d/` use **six** fields — the sixth (`root`) is the user the job runs as. `30 2 * * *` means 02:30 daily.

**Question 8**

**Task:** On **Server8**, install/enable `httpd`, create `/var/www/html/index.html` with `Server8 Web`, and allow `http` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y httpd
2. echo "Server8 Web" > /var/www/html/index.html
3. systemctl enable --now httpd
4. firewall-cmd --permanent --add-service=http && firewall-cmd --reload

**Explanation**

`--permanent` persists the firewall rule; enabling the unit starts httpd at boot.

**Question 9**

**Task:** On **Server8**, find all files under `/home` owned by user `bob` and copy them into `/root/bobfiles8/`.

- **Aspects/Domains Covered:** Understand and use essential tools (find).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /root/bobfiles8
2. find /home -type f -user bob -exec cp {} /root/bobfiles8/ \;

**Explanation**

`-user bob` matches files owned by that user; `-exec` copies each match.

**Question 10**

**Task:** On **Server8**, set the GRUB menu **timeout** to **5** seconds and regenerate the configuration.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

Answer:

Overall explanation

**Correct Answer:**

1. sed -i 's/^GRUB_TIMEOUT=.\*/GRUB_TIMEOUT=5/' /etc/default/grub
2. grub2-mkconfig -o /boot/grub2/grub.cfg

**Explanation**

`GRUB_TIMEOUT` in `/etc/default/grub` sets the menu delay; `grub2-mkconfig` writes the effective config.

**Question 11**

**Task:** On **Server8**, create an executable script `/usr/local/bin/sumargs8.sh` that prints the sum of its two integer arguments.

- **Aspects/Domains Covered:** Create simple shell scripts (arithmetic).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. echo $(( $1 + $2 ))

Then `chmod +x`.

**Explanation**

`$(( ))` performs integer arithmetic on the two positional parameters.

**Question 12**

**Task:** On **Server8**, add `/etc/skel/NOTES8.txt`, set `PASS_MAX_DAYS` to **30**, and password `minlen` to **12**.

- **Aspects/Domains Covered:** Manage users, Password policy.

Answer:

Overall explanation

**Correct Answer:**

1. echo "notes" > /etc/skel/NOTES8.txt
2. sed -i 's/^PASS_MAX_DAYS.\*/PASS_MAX_DAYS 30/' /etc/login.defs
3. echo "minlen = 12" >> /etc/security/pwquality.conf

**Explanation**

`/etc/skel` seeds new homes; `login.defs` and `pwquality.conf` enforce aging and complexity.

**Question 13**

**Task:** On **Server8**, create group `ops8` and a shared SGID directory `/srv/ops8` (mode `2770`) owned by that group.

- **Aspects/Domains Covered:** Group collaboration (special permissions).

Answer:

Overall explanation

**Correct Answer:**

1. groupadd ops8
2. mkdir -p /srv/ops8
3. chgrp ops8 /srv/ops8
4. chmod 2770 /srv/ops8

**Explanation**

SGID makes new files inherit the `ops8` group so team members can collaborate.

**Question 14**

**Task:** On **Server8**, create a **bzip2** archive `/root/repos8.tar.bz2` of `/etc/yum.repos.d`.

- **Aspects/Domains Covered:** Archive and compress files (tar/bzip2).

Answer:

Overall explanation

**Correct Answer:**

1. tar cjf /root/repos8.tar.bz2 /etc/yum.repos.d

**Explanation**

`j` selects bzip2 compression. Verify with `file /root/repos8.tar.bz2`.

**Question 15**

**Task:** On **Server8**, create a **256 MiB** swap logical volume `swap8` in `vg8` and enable it persistently.

- **Aspects/Domains Covered:** Manage storage (swap).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate -L 256M -n swap8 vg8
2. mkswap /dev/vg8/swap8
3. echo "/dev/vg8/swap8 none swap defaults 0 0" >> /etc/fstab
4. swapon -a

**Explanation**

`mkswap` + fstab + `swapon -a` provides persistent additional swap.

**Question 16**

**Task:** On **Server8**, configure SSH to **deny root login**.

- **Aspects/Domains Covered:** Configure SSH security.

Answer:

Overall explanation

**Correct Answer:**

1. echo "PermitRootLogin no" > /etc/ssh/sshd_config.d/99-noroot.conf
2. systemctl reload sshd

**Explanation**

A drop-in with `PermitRootLogin no` blocks direct root SSH access; `sshd -T` confirms the effective value.

**Question 17**

**Task:** On **Server8**, apply the `tuned` **powersave** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl enable --now tuned
2. tuned-adm profile powersave

**Explanation**

`tuned-adm profile powersave` persistently selects the low-power profile.

**Question 18**

**Task:** On **Server8**, mount the NFS export `server:/exports/data8` persistently at `/mnt/nfs8` using the `_netdev` option.

- **Aspects/Domains Covered:** Manage network file systems (NFS).

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y nfs-utils
2. mkdir -p /mnt/nfs8
3. echo "server:/exports/data8 /mnt/nfs8 nfs \_netdev 0 0" >> /etc/fstab
4. mount -a

**Explanation**

`_netdev` delays the mount until networking is up, preventing boot hangs on network filesystems.

**Question 19**

**Task:** On **Server8**, create group `admin8`, add user `pat` to it, and grant the `admin8` group full sudo access via `/etc/sudoers.d/admin8`.

- **Aspects/Domains Covered:** Manage users/groups, Configure sudo.

Answer:

Overall explanation

**Correct Answer:**

1. groupadd admin8
2. useradd -G admin8 pat
3. echo "%admin8 ALL=(ALL) ALL" > /etc/sudoers.d/admin8
4. visudo -cf /etc/sudoers.d/admin8

**Explanation**

The `%` prefix denotes a group rule; members of `admin8` gain full sudo privileges.

**Question 20**

**Task:** On **Server8**, create an LVM **thin pool** `thinpool8` and a thin volume `thinvol8`, format XFS, and mount at `/thin8`.

- **Aspects/Domains Covered:** Manage storage (LVM thin provisioning).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate --type thin-pool -L 1G -n thinpool8 vg8
2. lvcreate --thin -V 2G -n thinvol8 vg8/thinpool8
3. mkfs.xfs /dev/vg8/thinvol8
4. mkdir /thin8
5. echo "/dev/vg8/thinvol8 /thin8 xfs defaults 0 0" >> /etc/fstab && mount -a

**Explanation**

Thin volumes provision space on demand; the virtual size (`-V 2G`) can exceed the pool's physical size.

**Question 21**

**Task:** On **Server8**, make the journal persistent and cap its size at **200M**.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /var/log/journal
2. sed -i 's/^#\?Storage=.\*/Storage=persistent/' /etc/systemd/journald.conf
3. sed -i 's/^#\?SystemMaxUse=.\*/SystemMaxUse=200M/' /etc/systemd/journald.conf
4. systemctl restart systemd-journald

**Explanation**

`Storage=persistent` keeps logs across reboots; `SystemMaxUse=200M` limits their disk usage.

**Question 22**

**Task:** On **Server8**, schedule a one-time `at` job that runs `/usr/bin/logger "at8 ran"` **5 minutes** from now.

- **Aspects/Domains Covered:** Schedule tasks (at).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl enable --now atd
2. echo '/usr/bin/logger "at8 ran"' | at now + 5 minutes
3. atq # verify

**Explanation**

`at` reads the command from stdin and queues a single execution; `atq` lists pending jobs.

**Question 23**

**Task:** On **Server8**, copy `/etc/hosts` to `/var/tmp/hosts8`, grant user `quinn` read/write and deny user `sam` all access via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

Answer:

Overall explanation

**Correct Answer:**

1. cp /etc/hosts /var/tmp/hosts8
2. setfacl -m u:quinn:rw /var/tmp/hosts8
3. setfacl -m u:sam:--- /var/tmp/hosts8

**Explanation**

Per-user ACL entries override the group/other bits: `quinn` gets rw, `sam` is explicitly denied.

**Question 24**

**Task:** On **Server8**, create an executable script `/usr/local/bin/countargs8.sh` that prints the number of arguments it received.

- **Aspects/Domains Covered:** Create simple shell scripts.

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. echo "$#"

Then `chmod +x`.

**Explanation**

`$#` expands to the count of positional parameters passed to the script.

**Question 25**

**Task:** On **Server8**, extract all lines containing `bash` from `/etc/passwd` into `/root/bashusers8.txt`.

- **Aspects/Domains Covered:** Essential tools (grep).

Answer:

Overall explanation

**Correct Answer:**

1. grep "bash" /etc/passwd > /root/bashusers8.txt

**Explanation**

`grep` filters lines containing `bash` (users with a bash login shell); `>` writes them to the file.

**Question 26**

**Task:** On **Server8**, set the default boot target to **graphical**.

- **Aspects/Domains Covered:** Operate running systems (Boot targets).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl set-default graphical.target

**Explanation**

`set-default` re-points `default.target`; the graphical target pulls in multi-user plus the display manager.

**Question 27**

**Task:** On **Server8**, create `/web8`, give it a persistent SELinux type of `httpd_sys_content_t`, and enable the SELinux boolean `httpd_can_network_connect`.

- **Aspects/Domains Covered:** Manage SELinux (file contexts, booleans).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir /web8
2. semanage fcontext -a -t httpd_sys_content_t "/web8(/.\*)?"
3. restorecon -Rv /web8
4. setsebool -P httpd_can_network_connect on

**Explanation**

`semanage fcontext` + `restorecon` persistently labels the directory; `setsebool -P` persistently toggles the boolean.

**Question 28**

**Task:** On **Server8**, ensure user `molly`'s default **umask** is `077`.

- **Aspects/Domains Covered:** Manage users (default permissions).

Answer:

Overall explanation

**Correct Answer:**

1. echo "umask 077" >> /home/molly/.bashrc

**Explanation**

A `077` umask makes new files/dirs accessible only to the owner.

**Question 29**

**Task:** On **Server8**, use `rsync` to mirror `/etc` to `/backup/etc8` locally.

- **Aspects/Domains Covered:** Understand and use essential tools (rsync).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /backup
2. rsync -a /etc/ /backup/etc8/

**Explanation**

`-a` (archive) preserves permissions, ownership, and timestamps while recursively copying. (Content check is transient.)

**Question 30**

**Task:** On **Server8**, create an executable script `/usr/local/bin/checkuser8.sh` that prints `present` if the username argument exists in `/etc/passwd`, else `absent`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. if id "$1" &>/dev/null; then
3. echo "present"
4. else
5. echo "absent"
6. fi

Then `chmod +x`.

**Explanation**

`id "$1"` succeeds only if the user exists; its exit status drives the `if`.
