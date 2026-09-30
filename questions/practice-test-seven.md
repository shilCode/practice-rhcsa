# Practice Test Seven - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **Server7**. Securely reset the root password to `seven` to regain access to the system.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

**Question 2**

**Task:** Configure a local DNF repository on **Server7**. Mount the image `/RHEL-10.iso` at `/mnt/iso` and configure the **BaseOS** and **AppStream** repositories from it with GPG checking disabled.

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3**

**Task:** Configure the network interface `enp1s0` on **Server7** with a persistent profile named `net7`:

- **IPv4:** `192.168.7.10/24`, Gateway `192.168.7.1`, DNS `8.8.8.8`.
- **IPv6:** `fd07::10/64`, Gateway `fd07::1`.
- **Secondary IPv4:** `10.7.0.5/24`.
- Ensure it starts automatically at boot.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses, Persistence).

---

**Question 4**

**Task:** On **Server7**, set the timezone to **Asia/Tokyo** and configure `chrony` to keep time synchronized using `pool.ntp.org`.

- **Aspects/Domains Covered:** Operate running systems (Configure time service clients).

---

**Question 5**

**Task:** On **Server7**, add the **Flathub** remote and install the **org.gnome.Calculator** Flatpak application system-wide.

- **Aspects/Domains Covered:** Manage software (Install and update software using Flatpak).

---

**Question 6**

**Task:** On **Server7**, create a volume group `vg7`, a 500 MiB logical volume `lv7`, format it XFS, and mount it persistently at `/data7`.

- **Aspects/Domains Covered:** Manage storage (Create and configure LVM, mount persistently).

---

**Question 7**

**Task:** On **Server7**, create a systemd **timer** named `backup7` that runs `/usr/local/bin/backup7.sh` daily. Enable the timer.

- **Aspects/Domains Covered:** Operate running systems (Schedule tasks using systemd timers).

---

**Question 8**

**Task:** On **Server7**, install and enable `httpd`. Create `/var/www/html/index.html` containing `Welcome to Server7` and open the `http` service in the firewall permanently.

- **Aspects/Domains Covered:** Deploy and manage web servers, Manage firewalls.

---

**Question 9**

**Task:** On **Server7**, find all files under `/usr` larger than **50 MiB** and copy them into `/root/large7/`.

- **Aspects/Domains Covered:** Understand and use essential tools (find/locate files).

---

**Question 10**

**Task:** On **Server7**, remove the `rhgb` and `quiet` parameters from the default kernel command line so boot messages are visible.

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).

---

**Question 11**

**Task:** On **Server7**, create an executable script `/usr/local/bin/greet7.sh` that prints `Hello, <name>` where `<name>` is its first argument.

- **Aspects/Domains Covered:** Create simple shell scripts.

---

**Question 12**

**Task:** On **Server7**, configure user account policy: add `/etc/skel/README7.txt`, set `PASS_MAX_DAYS` to **45**, and set password `minlen` to **10**.

- **Aspects/Domains Covered:** Manage users and groups, Configure password policies.

---

**Question 13**

**Task:** On **Server7**, create a group `eng7` and a shared directory `/opt/eng7` owned by that group with the **SGID** bit set (mode `2770`).

- **Aspects/Domains Covered:** Manage group collaboration directories (special permissions).

---

**Question 14**

**Task:** On **Server7**, create a gzip-compressed tar archive `/root/ssh7.tar.gz` containing `/etc/ssh`.

- **Aspects/Domains Covered:** Archive, compress, unpack files (tar/gzip).

---

**Question 15**

**Task:** On **Server7**, add a **512 MiB** logical-volume swap named `swap7` in `vg7` and make it persistent.

- **Aspects/Domains Covered:** Manage storage (Configure swap).

---

**Question 16**

**Task:** On **Server7**, harden SSH by disabling **password authentication**.

- **Aspects/Domains Covered:** Configure SSH (Configure key-based authentication and security).

---

**Question 17**

**Task:** On **Server7**, install `tuned` and apply the **balanced** profile.

- **Aspects/Domains Covered:** Operate running systems (Adjust tuning profiles).

---

**Question 18**

**Task:** On **Server7**, install and enable **autofs**, and configure it to automount an NFS export at `/shares`.

- **Aspects/Domains Covered:** Manage network file systems (autofs).

---

**Question 19**

**Task:** On **Server7**, create user `devon` and grant a sudo rule allowing `devon` to run `dnf` with **NOPASSWD**.

- **Aspects/Domains Covered:** Manage users, Configure sudo.

---

**Question 20**

**Task:** On **Server7**, create an LVM **VDO** (deduplicated/compressed) volume `vdo7` and mount it at `/vdo7`.

- **Aspects/Domains Covered:** Manage storage (Configure and manage VDO / advanced LVM).

---

**Question 21**

**Task:** On **Server7**, make the systemd journal **persistent** across reboots.

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).

---

**Question 22**

**Task:** On **Server7**, start a background process `sleep 900`, then change its scheduling priority (nice value) to `10`.

- **Aspects/Domains Covered:** Operate running systems (Identify and manage processes).

---

**Question 23**

**Task:** On **Server7**, copy `/etc/fstab` to `/var/tmp/fstab7` and grant user `grace` **read/write** access via an ACL.

- **Aspects/Domains Covered:** Manage file security (Access Control Lists).

---

**Question 24**

**Task:** On **Server7**, create an executable script `/usr/local/bin/useraudit7.sh` that loops over all users in `/etc/passwd` and prints their username and UID.

- **Aspects/Domains Covered:** Create simple shell scripts (loops, processing input).

---

**Question 25**

**Task:** On **Server7**, extract every line containing the word `Server` from `/etc/ssh/sshd_config` into `/root/sshmatch7.txt`.

- **Aspects/Domains Covered:** Understand and use essential tools (grep / regular expressions).

---

**Question 26**

**Task:** On **Server7**, set the default systemd target to **multi-user** (text mode).

- **Aspects/Domains Covered:** Operate running systems (Boot systems into specific targets).

---

**Question 27**

**Task:** On **Server7**, configure `httpd` to listen on port **8707**. Update SELinux and the firewall to allow it.

- **Aspects/Domains Covered:** Manage SELinux (port labeling), Manage firewalls, Deploy web servers.

---

**Question 28**

**Task:** On **Server7**, ensure user `harper`'s default **umask** is `027`.

- **Aspects/Domains Covered:** Manage users (Configure default permissions).

---

**Question 29**

**Task:** On **Server7**, securely copy `/root/ssh7.tar.gz` to `/tmp` on the host `192.168.7.20` using `scp`.

- **Aspects/Domains Covered:** Access remote systems (Securely transfer files).

---

**Question 30**

**Task:** On **Server7**, create an executable script `/usr/local/bin/checkfile7.sh` that takes a filename argument and prints `exists` if it is a regular file, otherwise `missing`.

- **Aspects/Domains Covered:** Create simple shell scripts (conditionals, file tests).

---

