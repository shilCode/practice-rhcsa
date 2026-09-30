# Practice Test Eight - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **Server8**. Securely reset the root password to `eight` to regain access.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process to gain access).

---

**Question 2**

**Task:** Configure **Server8** to use HTTP repositories: **BaseOS** at `http://192.168.8.1/rhel10/BaseOS` and **AppStream** at `http://192.168.8.1/rhel10/AppStream`, with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3**

**Task:** Configure `enp1s0` on **Server8** with a persistent profile `net8`:

- **IPv4:** `192.168.8.10/24`, Gateway `192.168.8.1`, DNS `1.1.1.1`.
- **IPv6:** `fd08::10/64`, Gateway `fd08::1`.
- **Secondary IPv4:** `10.8.0.5/24`. Autoconnect enabled.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

---

**Question 4**

**Task:** On **Server8**, set the timezone to **Europe/Paris** and enable `chronyd` for time sync.

- **Aspects/Domains Covered:** Operate running systems (Configure time service clients).

---

**Question 5**

**Task:** On **Server8**, add the **Flathub** remote and install **org.gnome.TextEditor**.

- **Aspects/Domains Covered:** Manage software (Flatpak).

---

**Question 6**

**Task:** On **Server8**, create volume group `vg8`, logical volume `lv8` of **300 MiB**, format XFS, mount persistently at `/data8`.

- **Aspects/Domains Covered:** Manage storage (LVM, persistent mounts).

---

**Question 7**

**Task:** On **Server8**, create a **cron** job (in `/etc/cron.d/backup8`) that runs `/usr/local/bin/backup8.sh` every day at **02:30** as `root`.

- **Aspects/Domains Covered:** Operate running systems (Schedule tasks using cron).

---

**Question 8**

**Task:** On **Server8**, install/enable `httpd`, create `/var/www/html/index.html` with `Server8 Web`, and allow `http` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

---

**Question 9**

**Task:** On **Server8**, find all files under `/home` owned by user `bob` and copy them into `/root/bobfiles8/`.

- **Aspects/Domains Covered:** Understand and use essential tools (find).

---

**Question 10**

**Task:** On **Server8**, set the GRUB menu **timeout** to **5** seconds and regenerate the configuration.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

---

**Question 11**

**Task:** On **Server8**, create an executable script `/usr/local/bin/sumargs8.sh` that prints the sum of its two integer arguments.

- **Aspects/Domains Covered:** Create simple shell scripts (arithmetic).

---

**Question 12**

**Task:** On **Server8**, add `/etc/skel/NOTES8.txt`, set `PASS_MAX_DAYS` to **30**, and password `minlen` to **12**.

- **Aspects/Domains Covered:** Manage users, Password policy.

---

**Question 13**

**Task:** On **Server8**, create group `ops8` and a shared SGID directory `/srv/ops8` (mode `2770`) owned by that group.

- **Aspects/Domains Covered:** Group collaboration (special permissions).

---

**Question 14**

**Task:** On **Server8**, create a **bzip2** archive `/root/repos8.tar.bz2` of `/etc/yum.repos.d`.

- **Aspects/Domains Covered:** Archive and compress files (tar/bzip2).

---

**Question 15**

**Task:** On **Server8**, create a **256 MiB** swap logical volume `swap8` in `vg8` and enable it persistently.

- **Aspects/Domains Covered:** Manage storage (swap).

---

**Question 16**

**Task:** On **Server8**, configure SSH to **deny root login**.

- **Aspects/Domains Covered:** Configure SSH security.

---

**Question 17**

**Task:** On **Server8**, apply the `tuned` **powersave** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

---

**Question 18**

**Task:** On **Server8**, mount the NFS export `server:/exports/data8` persistently at `/mnt/nfs8` using the `_netdev` option.

- **Aspects/Domains Covered:** Manage network file systems (NFS).

---

**Question 19**

**Task:** On **Server8**, create group `admin8`, add user `pat` to it, and grant the `admin8` group full sudo access via `/etc/sudoers.d/admin8`.

- **Aspects/Domains Covered:** Manage users/groups, Configure sudo.

---

**Question 20**

**Task:** On **Server8**, create an LVM **thin pool** `thinpool8` and a thin volume `thinvol8`, format XFS, and mount at `/thin8`.

- **Aspects/Domains Covered:** Manage storage (LVM thin provisioning).

---

**Question 21**

**Task:** On **Server8**, make the journal persistent and cap its size at **200M**.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

---

**Question 22**

**Task:** On **Server8**, schedule a one-time `at` job that runs `/usr/bin/logger "at8 ran"` **5 minutes** from now.

- **Aspects/Domains Covered:** Schedule tasks (at).

---

**Question 23**

**Task:** On **Server8**, copy `/etc/hosts` to `/var/tmp/hosts8`, grant user `quinn` read/write and deny user `sam` all access via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

---

**Question 24**

**Task:** On **Server8**, create an executable script `/usr/local/bin/countargs8.sh` that prints the number of arguments it received.

- **Aspects/Domains Covered:** Create simple shell scripts.

---

**Question 25**

**Task:** On **Server8**, extract all lines containing `bash` from `/etc/passwd` into `/root/bashusers8.txt`.

- **Aspects/Domains Covered:** Essential tools (grep).

---

**Question 26**

**Task:** On **Server8**, set the default boot target to **graphical**.

- **Aspects/Domains Covered:** Operate running systems (Boot targets).

---

**Question 27**

**Task:** On **Server8**, create `/web8`, give it a persistent SELinux type of `httpd_sys_content_t`, and enable the SELinux boolean `httpd_can_network_connect`.

- **Aspects/Domains Covered:** Manage SELinux (file contexts, booleans).

---

**Question 28**

**Task:** On **Server8**, ensure user `molly`'s default **umask** is `077`.

- **Aspects/Domains Covered:** Manage users (default permissions).

---

**Question 29**

**Task:** On **Server8**, use `rsync` to mirror `/etc` to `/backup/etc8` locally.

- **Aspects/Domains Covered:** Understand and use essential tools (rsync).

---

**Question 30**

**Task:** On **Server8**, create an executable script `/usr/local/bin/checkuser8.sh` that prints `present` if the username argument exists in `/etc/passwd`, else `absent`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals).

---

