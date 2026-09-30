# Practice Test Nine - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **Server9**. Securely reset the root password to `nine`.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process to gain access).

---

**Question 2**

**Task:** Configure a local DNF repository on **Server9** from `/dev/sr0` mounted persistently at `/mnt/cdrom`, exposing **BaseOS** and **AppStream** with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3**

**Task:** Configure `enp1s0` on **Server9** with a persistent profile `net9`:

- **IPv4:** `192.168.9.10/24`, Gateway `192.168.9.1`, DNS `9.9.9.9`.
- **IPv6:** `fd09::10/64`, Gateway `fd09::1`.
- **Secondary IPv6:** `fd09::20/64`.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

---

**Question 4**

**Task:** On **Server9**, set the timezone to **America/Denver** and enable `chronyd`.

- **Aspects/Domains Covered:** Operate running systems (Time service clients).

---

**Question 5**

**Task:** On **Server9**, ensure a regular user `podadmin` exists with **linger** enabled so their user services run at boot.

- **Aspects/Domains Covered:** Manage containers (Prepare rootless user environment).

---

**Question 6**

**Task:** On **Server9**, create volume group `vg9`, logical volume `lv9` of **400 MiB**, format XFS, mount persistently at `/data9`.

- **Aspects/Domains Covered:** Manage storage (LVM, persistent mounts).

---

**Question 7**

**Task:** As user `podadmin` on **Server9**, pull `registry.access.redhat.com/ubi9/ubi` and configure a rootless container named `web9` to start at boot via a Quadlet unit at `~/.config/containers/systemd/web9.container` (use `Exec=sleep infinity`).

- **Aspects/Domains Covered:** Manage containers (Run containers, Start containers via systemd).

---

**Question 8**

**Task:** On **Server9**, install/enable `httpd`, put `Server9 Running` in `/var/www/html/index.html`, and permit `http` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

---

**Question 9**

**Task:** On **Server9**, find all files under `/var` modified in the last **7 days** and list them in `/root/recent9.txt`.

- **Aspects/Domains Covered:** Essential tools (find).

---

**Question 10**

**Task:** On **Server9**, remove `rhgb` and `quiet` from the default kernel arguments.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

---

**Question 11**

**Task:** On **Server9**, create an executable script `/usr/local/bin/rev9.sh` that prints its two arguments in reverse order.

- **Aspects/Domains Covered:** Create simple shell scripts.

---

**Question 12**

**Task:** On **Server9**, add `/etc/skel/HELLO9.txt`, set `PASS_MAX_DAYS` to **60**, and password `minlen` to **8**.

- **Aspects/Domains Covered:** Manage users, Password policy.

---

**Question 13**

**Task:** On **Server9**, create group `dev9` and a shared SGID directory `/opt/dev9` (mode `2770`).

- **Aspects/Domains Covered:** Group collaboration (special permissions).

---

**Question 14**

**Task:** On **Server9**, create a gzip tar archive `/root/log9.tar.gz` of `/var/log`.

- **Aspects/Domains Covered:** Archive and compress files.

---

**Question 15**

**Task:** On **Server9**, add a **512 MiB** swap logical volume `swap9` in `vg9` and enable it persistently.

- **Aspects/Domains Covered:** Manage storage (swap).

---

**Question 16**

**Task:** On **Server9**, create user `sshuser9` and disable SSH **password authentication**.

- **Aspects/Domains Covered:** Manage users, Configure SSH.

---

**Question 17**

**Task:** On **Server9**, apply the `tuned` **throughput-performance** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

---

**Question 18**

**Task:** On **Server9**, install/enable **autofs** and configure an on-demand mount of `/misc9`.

- **Aspects/Domains Covered:** Manage network file systems (autofs).

---

**Question 19**

**Task:** On **Server9**, create user `ops9` and grant a sudo rule allowing `ops9` to run `systemctl` with **NOPASSWD**.

- **Aspects/Domains Covered:** Manage users, Configure sudo.

---

**Question 20**

**Task:** On **Server9**, extend the existing logical volume `lv9` by **200 MiB** and grow its XFS filesystem online.

- **Aspects/Domains Covered:** Manage storage (Extend logical volumes).

---

**Question 21**

**Task:** On **Server9**, make the journal persistent.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

---

**Question 22**

**Task:** On **Server9**, start `sleep 1200` in the background and send it a `SIGSTOP` signal.

- **Aspects/Domains Covered:** Operate running systems (Manage processes / signals).

---

**Question 23**

**Task:** On **Server9**, copy `/etc/hostname` to `/var/tmp/hostname9` and grant user `nora` **read** access via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

---

**Question 24**

**Task:** On **Server9**, create an executable script `/usr/local/bin/listgroups9.sh` that prints every group name from `/etc/group`.

- **Aspects/Domains Covered:** Create simple shell scripts (loops).

---

**Question 25**

**Task:** On **Server9**, extract all lines starting with `#` from `/etc/chrony.conf` into `/root/comments9.txt`.

- **Aspects/Domains Covered:** Essential tools (grep / regex).

---

**Question 26**

**Task:** On **Server9**, set the default boot target to **multi-user**.

- **Aspects/Domains Covered:** Operate running systems (Boot targets).

---

**Question 27**

**Task:** On **Server9**, configure `httpd` to listen on port **8909**; update SELinux and the firewall accordingly.

- **Aspects/Domains Covered:** Manage SELinux (ports), Manage firewalls.

---

**Question 28**

**Task:** On **Server9**, ensure user `leo`'s default **umask** is `022`.

- **Aspects/Domains Covered:** Manage users (default permissions).

---

**Question 29**

**Task:** On **Server9**, verify the running container image list as `podadmin` and confirm `web9` is running.

- **Aspects/Domains Covered:** Manage containers (Inspect running containers).

---

**Question 30**

**Task:** On **Server9**, create an executable script `/usr/local/bin/pinghost9.sh` that pings the host given as its first argument once and reports `up` or `down`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals, exit codes).

---

