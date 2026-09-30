# Practice Test Ten - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **Server10**. Securely reset the root password to `ten`.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process to gain access).

---

**Question 2**

**Task:** Configure a local DNF repository on **Server10** from `/RHEL-10.iso` mounted at `/mnt/repo10`, exposing **BaseOS** and **AppStream** with GPG checking **enabled** (import the key from the media).

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3**

**Task:** Configure `enp1s0` on **Server10** with a persistent profile `net10`:

- **IPv4:** `192.168.10.10/24`, Gateway `192.168.10.1`, DNS `8.8.4.4`.
- **IPv6:** `fd0a::10/64`, Gateway `fd0a::1`, DNS `fd0a::53`.
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses).

---

**Question 4**

**Task:** On **Server10**, set the timezone to **Australia/Sydney** and enable `chronyd`.

- **Aspects/Domains Covered:** Operate running systems (Time service clients).

---

**Question 5**

**Task:** On **Server10**, enable **IPv4 and IPv6 packet forwarding** and make both settings persistent.

- **Aspects/Domains Covered:** Operate running systems (Modify kernel runtime parameters).

---

**Question 6**

**Task:** On **Server10**, create volume group `vg10` with a **16 MiB** PE size, a logical volume `lv10` of **50 extents**, format XFS, and mount persistently at `/data10`.

- **Aspects/Domains Covered:** Manage storage (LVM with custom PE size and extents).

---

**Question 7**

**Task:** On **Server10**, create a systemd **timer** `cleanup10` that runs `/usr/local/bin/cleanup10.sh` at **16:15** daily.

- **Aspects/Domains Covered:** Operate running systems (systemd timers).

---

**Question 8**

**Task:** On **Server10**, install/enable `httpd`, put `Server10 OK` in `/var/www/html/index.html`, and allow `http` and `https` in the firewall permanently.

- **Aspects/Domains Covered:** Deploy web servers, Manage firewalls.

---

**Question 9**

**Task:** On **Server10**, find all files under `/etc` with permissions `777` and list them in `/root/world10.txt`.

- **Aspects/Domains Covered:** Essential tools (find by permission).

---

**Question 10**

**Task:** On **Server10**, set the GRUB **timeout** to **10** seconds and regenerate the config.

- **Aspects/Domains Covered:** Operate running systems (Modify the bootloader).

---

**Question 11**

**Task:** On **Server10**, create an executable script `/usr/local/bin/upper10.sh` that prints its first argument in UPPERCASE.

- **Aspects/Domains Covered:** Create simple shell scripts (parameter expansion).

---

**Question 12**

**Task:** On **Server10**, add `/etc/skel/START10.txt`, set `PASS_MAX_DAYS` to **90**, `PASS_MIN_DAYS` to **2**.

- **Aspects/Domains Covered:** Manage users, Password aging.

---

**Question 13**

**Task:** On **Server10**, create groups `alpha10` and `beta10`, a shared SGID directory `/groups/alpha10` (mode `2770`) owned by `alpha10`, and grant `beta10` read/execute via a default ACL.

- **Aspects/Domains Covered:** Group collaboration, Default ACLs.

---

**Question 14**

**Task:** On **Server10**, create a bzip2 archive `/root/home10.tar.bz2` of `/home`, excluding any `*.tmp` files.

- **Aspects/Domains Covered:** Archive and compress (tar with exclude).

---

**Question 15**

**Task:** On **Server10**, add a **1 GiB** swap logical volume `swap10` in `vg10` referenced by **UUID** in `/etc/fstab`.

- **Aspects/Domains Covered:** Manage storage (swap by UUID).

---

**Question 16**

**Task:** On **Server10**, harden SSH: disable **password authentication** and **root login**.

- **Aspects/Domains Covered:** Configure SSH security.

---

**Question 17**

**Task:** On **Server10**, apply the `tuned` **virtual-guest** profile.

- **Aspects/Domains Covered:** Operate running systems (tuning profiles).

---

**Question 18**

**Task:** On **Server10**, mount an NFS export `nfs:/exports/shared10` persistently at `/mnt/shared10` with the `_netdev` option.

- **Aspects/Domains Covered:** Manage network file systems (NFS).

---

**Question 19**

**Task:** On **Server10**, create user `wheel10`, add them to the `wheel` group, and confirm `wheel` has sudo access.

- **Aspects/Domains Covered:** Manage users/groups, sudo.

---

**Question 20**

**Task:** On **Server10**, create a directory `/srv/secure10`, apply a persistent SELinux type `samba_share_t`, and relabel it.

- **Aspects/Domains Covered:** Manage SELinux (file contexts).

---

**Question 21**

**Task:** On **Server10**, make the journal persistent and set `SystemMaxUse` to **500M**.

- **Aspects/Domains Covered:** Operate running systems (Manage journals).

---

**Question 22**

**Task:** On **Server10**, set a cron job for user `carol` that appends the date to `/home/carol/log.txt` every **10 minutes**.

- **Aspects/Domains Covered:** Schedule tasks (user cron).

---

**Question 23**

**Task:** On **Server10**, copy `/etc/fstab` to `/var/tmp/fstab10` and grant user `dave` read/write plus group `alpha10` read via ACL.

- **Aspects/Domains Covered:** Manage file security (ACLs).

---

**Question 24**

**Task:** On **Server10**, create an executable script `/usr/local/bin/evenodd10.sh` that prints `even` or `odd` for its integer argument.

- **Aspects/Domains Covered:** Create simple shell scripts (arithmetic, conditionals).

---

**Question 25**

**Task:** On **Server10**, count how many lines in `/etc/passwd` use `/sbin/nologin` and write the number to `/root/nologin10.txt`.

- **Aspects/Domains Covered:** Essential tools (grep -c).

---

**Question 26**

**Task:** On **Server10**, set the default boot target to **multi-user** and set the hostname to `server10.example.com`.

- **Aspects/Domains Covered:** Operate running systems (Boot targets, hostname).

---

**Question 27**

**Task:** On **Server10**, add TCP port **9090** to the SELinux `http_port_t` type and open it in the firewall permanently.

- **Aspects/Domains Covered:** Manage SELinux (ports), Manage firewalls.

---

**Question 28**

**Task:** On **Server10**, set the system-wide default **umask** to `077` via a file in `/etc/profile.d/`.

- **Aspects/Domains Covered:** Manage users (system default permissions).

---

**Question 29**

**Task:** On **Server10**, create a **hard link** `/root/fstab10.hard` and a **soft link** `/root/fstab10.soft`, both pointing at `/etc/fstab`.

- **Aspects/Domains Covered:** Understand and use essential tools (links).

---

**Question 30**

**Task:** On **Server10**, create an executable script `/usr/local/bin/diskfree10.sh` that prints the used percentage of the root filesystem.

- **Aspects/Domains Covered:** Create simple shell scripts (command substitution).

---

