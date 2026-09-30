# Practice Test Nine: RHCSA 10 EX200 Practice Exam

**Question 1**

**Task:** You have forgotten the root password for **Server9**. Securely reset the root password to `nine`.

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

`/sysroot` is the real root in the initramfs shell and must be writable before `passwd`; `/.autorelabel` repairs SELinux contexts on the next boot.

**Question 2**

**Task:** Configure a local DNF repository on **Server9** from `/dev/sr0` mounted persistently at `/mnt/cdrom`, exposing **BaseOS** and **AppStream** with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /mnt/cdrom
2. echo "/dev/sr0 /mnt/cdrom iso9660 ro 0 0" >> /etc/fstab && mount -a
3. Create `/etc/yum.repos.d/cdrom.repo` with BaseOS/AppStream `baseurl=file:///mnt/cdrom/...`, `enabled=1`, `gpgcheck=0`.
4. dnf clean all && dnf repolist

**Explanation**

Mounting the optical device and pointing `file://` URLs at it provides an offline package source; `gpgcheck=0` avoids key errors.

**Question 3**

**Task:** Configure `enp1s0` on **Server9** with a persistent profile `net9`:

- **IPv4:** `192.168.9.10/24`, Gateway `192.168.9.1`, DNS `9.9.9.9`.
- **IPv6:** `fd09::10/64`, Gateway `fd09::1`.
- **Secondary IPv6:** `fd09::20/64`.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

Answer:

Overall explanation

**Correct Answer:**

1. nmcli con add con-name net9 ifname enp1s0 type ethernet \
2. ipv4.method manual ipv4.addresses 192.168.9.10/24 ipv4.gateway 192.168.9.1 ipv4.dns 9.9.9.9 \
3. ipv6.method manual ipv6.addresses fd09::10/64 ipv6.gateway fd09::1
4. nmcli con mod net9 +ipv6.addresses fd09::20/64
5. nmcli con up net9

**Explanation**

`+ipv6.addresses` appends the secondary IPv6 address; without the `+` the primary would be replaced.

**Question 4**

**Task:** On **Server9**, set the timezone to **America/Denver** and enable `chronyd`.

- **Aspects/Domains Covered:** Operate running systems (Time service clients).

Answer:

Overall explanation

**Correct Answer:**

1. timedatectl set-timezone America/Denver
2. systemctl enable --now chronyd

**Explanation**

Timezone is persisted by `timedatectl`; `chronyd` synchronizes and starts at boot.

**Question 5**

**Task:** On **Server9**, ensure a regular user `podadmin` exists with **linger** enabled so their user services run at boot.

- **Aspects/Domains Covered:** Manage containers (Prepare rootless user environment).

Answer:

Overall explanation

**Correct Answer:**

1. useradd podadmin
2. loginctl enable-linger podadmin
3. loginctl show-user podadmin | grep Linger # verify

**Explanation**

Linger lets a user's systemd instance start at boot without an interactive login — required for rootless containers to auto-start.

**Question 6**

**Task:** On **Server9**, create volume group `vg9`, logical volume `lv9` of **400 MiB**, format XFS, mount persistently at `/data9`.

- **Aspects/Domains Covered:** Manage storage (LVM, persistent mounts).

Answer:

Overall explanation

**Correct Answer:**

1. pvcreate /dev/vdb
2. vgcreate vg9 /dev/vdb
3. lvcreate -L 400M -n lv9 vg9
4. mkfs.xfs /dev/vg9/lv9
5. mkdir /data9
6. echo "/dev/vg9/lv9 /data9 xfs defaults 0 0" >> /etc/fstab && mount -a

**Explanation**

Standard LVM workflow; the fstab entry provides persistence.

**Question 7**

**Task:** As user `podadmin` on **Server9**, pull `registry.access.redhat.com/ubi9/ubi` and configure a rootless container named `web9` to start at boot via a Quadlet unit at `~/.config/containers/systemd/web9.container` (use `Exec=sleep infinity`).

- **Aspects/Domains Covered:** Manage containers (Run containers, Start containers via systemd).

Answer:

Overall explanation

**Correct Answer (as podadmin, via `su - podadmin`):**

1. podman pull registry.access.redhat.com/ubi9/ubi
2. mkdir -p ~/.config/containers/systemd
3. Create `~/.config/containers/systemd/web9.container`:
   1. [Container]
   2. ContainerName=web9
   3. Image=registry.access.redhat.com/ubi9/ubi
   4. Exec=sleep infinity
   5. [Install]
   6. WantedBy=default.target
4. systemctl --user daemon-reload
5. systemctl --user start web9

**Explanation**

A Quadlet `.container` file is auto-translated by systemd into a `web9.service`. Combined with linger (Q5), the container starts at boot as a rootless user service.

**Question 8**

**Task:** On **Server9**, install/enable `httpd`, put `Server9 Running` in `/var/www/html/index.html`, and permit `http` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y httpd
2. echo "Server9 Running" > /var/www/html/index.html
3. systemctl enable --now httpd
4. firewall-cmd --permanent --add-service=http && firewall-cmd --reload

**Explanation**

Enabling httpd and adding a permanent firewall rule makes the site reachable after reboot.

**Question 9**

**Task:** On **Server9**, find all files under `/var` modified in the last **7 days** and list them in `/root/recent9.txt`.

- **Aspects/Domains Covered:** Essential tools (find).

Answer:

Overall explanation

**Correct Answer:**

1. find /var -type f -mtime -7 > /root/recent9.txt

**Explanation**

`-mtime -7` matches files modified within the last 7 days; `>` captures the list.

**Question 10**

**Task:** On **Server9**, remove `rhgb` and `quiet` from the default kernel arguments.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

Answer:

Overall explanation

**Correct Answer:**

1. grubby --update-kernel=ALL --remove-args="rhgb quiet"

**Explanation**

`grubby` persistently edits kernel arguments so verbose boot messages appear.

**Question 11**

**Task:** On **Server9**, create an executable script `/usr/local/bin/rev9.sh` that prints its two arguments in reverse order.

- **Aspects/Domains Covered:** Create simple shell scripts.

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. echo "$2 $1"

Then `chmod +x`.

**Explanation**

Positional parameters `$1` and `$2` are printed in swapped order.

**Question 12**

**Task:** On **Server9**, add `/etc/skel/HELLO9.txt`, set `PASS_MAX_DAYS` to **60**, and password `minlen` to **8**.

- **Aspects/Domains Covered:** Manage users, Password policy.

Answer:

Overall explanation

**Correct Answer:**

1. echo "hello" > /etc/skel/HELLO9.txt
2. sed -i 's/^PASS_MAX_DAYS.\*/PASS_MAX_DAYS 60/' /etc/login.defs
3. echo "minlen = 8" >> /etc/security/pwquality.conf

**Explanation**

`/etc/skel` seeds new homes; the other two files set aging and complexity.

**Question 13**

**Task:** On **Server9**, create group `dev9` and a shared SGID directory `/opt/dev9` (mode `2770`).

- **Aspects/Domains Covered:** Group collaboration (special permissions).

Answer:

Overall explanation

**Correct Answer:**

1. groupadd dev9
2. mkdir /opt/dev9
3. chgrp dev9 /opt/dev9
4. chmod 2770 /opt/dev9

**Explanation**

SGID inheritance keeps new files owned by `dev9` for shared collaboration.

**Question 14**

**Task:** On **Server9**, create a gzip tar archive `/root/log9.tar.gz` of `/var/log`.

- **Aspects/Domains Covered:** Archive and compress files.

Answer:

Overall explanation

**Correct Answer:**

1. tar czf /root/log9.tar.gz /var/log

**Explanation**

`czf` creates a gzip-compressed archive; verify with `tar tf`.

**Question 15**

**Task:** On **Server9**, add a **512 MiB** swap logical volume `swap9` in `vg9` and enable it persistently.

- **Aspects/Domains Covered:** Manage storage (swap).

Answer:

Overall explanation

**Correct Answer:**

1. lvcreate -L 512M -n swap9 vg9
2. mkswap /dev/vg9/swap9
3. echo "/dev/vg9/swap9 none swap defaults 0 0" >> /etc/fstab
4. swapon -a

**Explanation**

`mkswap` + fstab + `swapon -a` yields persistent additional swap.

**Question 16**

**Task:** On **Server9**, create user `sshuser9` and disable SSH **password authentication**.

- **Aspects/Domains Covered:** Manage users, Configure SSH.

Answer:

Overall explanation

**Correct Answer:**

1. useradd sshuser9
2. echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/99-nopw.conf
3. systemctl reload sshd

**Explanation**

Disabling password auth forces key-based logins; drop-ins override the main config.

**Question 17**

**Task:** On **Server9**, apply the `tuned` **throughput-performance** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl enable --now tuned
2. tuned-adm profile throughput-performance

**Explanation**

`tuned-adm profile` persistently selects the high-throughput profile.

**Question 18**

**Task:** On **Server9**, install/enable **autofs** and configure an on-demand mount of `/misc9`.

- **Aspects/Domains Covered:** Manage network file systems (autofs).

Answer:

Overall explanation

**Correct Answer:**

1. dnf install -y autofs
2. echo "/misc9 /etc/auto.misc9" >> /etc/auto.master.d/misc9.autofs
3. echo "data -rw server:/exports/misc9" > /etc/auto.misc9
4. systemctl enable --now autofs

**Explanation**

The master map delegates `/misc9` to a map file; autofs mounts on access and unmounts when idle.

**Question 19**

**Task:** On **Server9**, create user `ops9` and grant a sudo rule allowing `ops9` to run `systemctl` with **NOPASSWD**.

- **Aspects/Domains Covered:** Manage users, Configure sudo.

Answer:

Overall explanation

**Correct Answer:**

1. useradd ops9
2. echo "ops9 ALL=(ALL) NOPASSWD: /usr/bin/systemctl" > /etc/sudoers.d/ops9
3. visudo -cf /etc/sudoers.d/ops9

**Explanation**

The command-scoped `NOPASSWD` rule lets `ops9` manage services without a password, but nothing else.

**Question 20**

**Task:** On **Server9**, extend the existing logical volume `lv9` by **200 MiB** and grow its XFS filesystem online.

- **Aspects/Domains Covered:** Manage storage (Extend logical volumes).

Answer:

Overall explanation

**Correct Answer:**

1. lvextend -L +200M /dev/vg9/lv9
2. xfs_growfs /data9

Or in one step: `lvextend -r -L +200M /dev/vg9/lv9`.

**Explanation**

`lvextend +200M` grows the LV; `xfs_growfs` enlarges the mounted XFS online. XFS can never be shrunk.

**Question 21**

**Task:** On **Server9**, make the journal persistent.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

Answer:

Overall explanation

**Correct Answer:**

1. mkdir -p /var/log/journal
2. sed -i 's/^#\?Storage=.\*/Storage=persistent/' /etc/systemd/journald.conf
3. systemctl restart systemd-journald

**Explanation**

`Storage=persistent` plus the journal directory keeps logs across reboots.

**Question 22**

**Task:** On **Server9**, start `sleep 1200` in the background and send it a `SIGSTOP` signal.

- **Aspects/Domains Covered:** Operate running systems (Manage processes / signals).

Answer:

Overall explanation

**Correct Answer:**

1. sleep 1200 &
2. kill -SIGSTOP $!

**Explanation**

`$!` holds the background PID; `SIGSTOP` suspends it. (Transient — not verified after reboot.)

**Question 23**

**Task:** On **Server9**, copy `/etc/hostname` to `/var/tmp/hostname9` and grant user `nora` **read** access via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

Answer:

Overall explanation

**Correct Answer:**

1. cp /etc/hostname /var/tmp/hostname9
2. setfacl -m u:nora:r /var/tmp/hostname9

**Explanation**

`setfacl -m u:nora:r` grants a per-user read ACL entry.

**Question 24**

**Task:** On **Server9**, create an executable script `/usr/local/bin/listgroups9.sh` that prints every group name from `/etc/group`.

- **Aspects/Domains Covered:** Create simple shell scripts (loops).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. while IFS=: read -r grp \_; do echo "$grp"; done < /etc/group

Then `chmod +x`.

**Explanation**

Reading `/etc/group` with `IFS=:` extracts the first field (group name) from each line.

**Question 25**

**Task:** On **Server9**, extract all lines starting with `#` from `/etc/chrony.conf` into `/root/comments9.txt`.

- **Aspects/Domains Covered:** Essential tools (grep / regex).

Answer:

Overall explanation

**Correct Answer:**

1. grep "^#" /etc/chrony.conf > /root/comments9.txt

**Explanation**

The anchor `^#` matches lines beginning with a hash; `>` writes them to the file.

**Question 26**

**Task:** On **Server9**, set the default boot target to **multi-user**.

- **Aspects/Domains Covered:** Operate running systems (Boot targets).

Answer:

Overall explanation

**Correct Answer:**

1. systemctl set-default multi-user.target

**Explanation**

`set-default` re-points `default.target` to text mode.

**Question 27**

**Task:** On **Server9**, configure `httpd` to listen on port **8909**; update SELinux and the firewall accordingly.

- **Aspects/Domains Covered:** Manage SELinux (ports), Manage firewalls.

Answer:

Overall explanation

**Correct Answer:**

1. sed -i 's/^Listen 80/Listen 8909/' /etc/httpd/conf/httpd.conf
2. semanage port -a -t http_port_t -p tcp 8909
3. firewall-cmd --permanent --add-port=8909/tcp && firewall-cmd --reload
4. systemctl restart httpd

**Explanation**

The SELinux port label authorizes the non-standard port for the httpd domain; the firewall must also open it.

**Question 28**

**Task:** On **Server9**, ensure user `leo`'s default **umask** is `022`.

- **Aspects/Domains Covered:** Manage users (default permissions).

Answer:

Overall explanation

**Correct Answer:**

1. echo "umask 022" >> /home/leo/.bashrc

**Explanation**

A `022` umask yields world-readable but owner-only-writable files.

**Question 29**

**Task:** On **Server9**, verify the running container image list as `podadmin` and confirm `web9` is running.

- **Aspects/Domains Covered:** Manage containers (Inspect running containers).

Answer:

Overall explanation

**Correct Answer:**

1. su - podadmin -c "podman ps"
2. su - podadmin -c "podman images"

**Explanation**

`podman ps` lists running containers for the current (rootless) user; the `web9` container from Q7 should show `Up`. (Runtime state — verify live.)

**Question 30**

**Task:** On **Server9**, create an executable script `/usr/local/bin/pinghost9.sh` that pings the host given as its first argument once and reports `up` or `down`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals, exit codes).

Answer:

Overall explanation

**Correct Answer:**

1. #!/bin/bash
2. if ping -c1 -W1 "$1" &>/dev/null; then
3. echo "up"
4. else
5. echo "down"
6. fi

Then `chmod +x`.

**Explanation**

`ping -c1 -W1` sends a single probe; its exit status drives the `up`/`down` decision.
