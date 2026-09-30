# Practice Test Five - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `mypass` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

    **Question 2**

**Task:** Configure a local DNF repository on **ServerB** using the provided ISO image `/RHEL10.iso`.

1. Create the directory `/mnt/disc`.
    
2. Mount the ISO to `/mnt/disc` persistently (automatically at boot).
    
3. Configure a repository file to install packages from **BaseOS** and **AppStream** within the ISO.
    
4. Enable GPG checking using the key at `/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Mount file systems at boot).

---

    **Question 3**

**Task:** On **ServerB**, configure the network interface `enp0s3` with the following static settings:

- **Profile Name:** `myprofile5`.
    
- **IPv4:** `192.168.1.6/24`, Gateway: `192.168.1.1`, DNS: `8.8.4.4`.
    
- **IPv6:** `fd01::105/64`, Gateway: `fd01::100`, DNS: `fd01::111`.
    
- **Secondary IPs:** Add `10.0.0.6/24` (IPv4) and `fd01::125/64` (IPv6).
    
- **Search Domain:** `google.com`.
    
- Ensure the connection starts automatically at boot.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

---

**Question 4**

**Task:** Configure kernel networking parameters on **ServerB**.

1. Enable **IPv4** packet forwarding.
    
2. Enable **IPv6** packet forwarding.
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters).

---

  **Question 5**

**Task:** Configure system time and synchronization on **ServerB**.

1. Set the timezone to **America/Los_Angeles**.
    
2. Configure NTP synchronization using `chrony`.
    
3. Ensure the service is enabled and time is synchronized.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).

---

  **Question 6**

**Task:** Update the kernel on **ServerB**.

1. Install the latest kernel version available from the configured repositories.
    
2. Ensure that the new kernel is set as the **default** boot option.
    
3. Ensure the **original** kernel remains installed and available as a fallback.
    
4. Reboot the system to verify the new kernel is active.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install/update software, Modify bootloader).

---

**Question 7**

**Task:** Configure **ServerB** to boot into the **Multi-User Target** by default.

1. Ensure the system boots into a non-graphical, command-line interface.
    
2. Verify the setting.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually).

---

  **Question 8**

**Task:** Create a restricted user on **ServerB**.

1. Create a user named `harry`.
    
2. Assign the specific **UID** `5000`.
    
3. Ensure `harry` **cannot** access an interactive shell (he should not be able to log in to a terminal).
    

- **Aspects/Domains Covered:** Manage users and groups (Create/modify local user accounts).

---

  **Question 9**

**Task:** Optimize **ServerB** for a virtualized environment.

1. Install and enable the `tuned` service.
    
2. Set the active tuning profile to `virtual-guest`.
    
3. Verify the profile is active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

  **Question 10 (New Topic: Flatpak)**

**Task:** Manage software using **Flatpak** on **ServerB**.

1. Configure the system to use the **Flathub** remote repository (`https://dl.flathub.org/repo/flathub.flatpakrepo`).
    
2. Install the **Firefox** web browser using Flatpak.
    
3. Verify the installation.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

---

**Question 11**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server (`httpd`).
    
2. Configure the default web page (`index.html`) to display the text: "Hello Guys!".
    
3. Configure the **Firewall** to allow HTTP and HTTPS traffic permanently.
    
4. Ensure the service starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Configure firewall settings).

---

  **Question 12**

**Task:** Perform an advanced file search and secure backup on **ServerB**.

1. Create a directory `/find/recent_configs`.
    
2. Find all **regular files** in the `/etc` directory that meet **all** the following criteria:
    
    - Larger than **5MiB**.
        
    - Modified within the last **30 days**.
        
    - Filename ends with `.conf`.
        
3. Copy these files to `/find/recent_configs`.
    
4. Ensure the copied files in the destination directory are readable and writable **only by the owner** (Permission `600`).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create/copy files, Use find with time/size/name filters).

---

  **Question 13**

**Task:** Create a shell script named `/sum.sh` (or `/usr/local/bin/sum.sh`) on **ServerB**.

1. The script should accept an unlimited number of integer arguments (e.g., `./sum.sh 10 20 -5 30`).
    
2. It should calculate the sum of all arguments that are **greater than 0**. (Ignore negative numbers or zero).
    
3. Print the result in the format: "The sum is [total]".
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, Loops, Conditional logic).

---

  **Question 14**

**Task:** Configure a collaborative environment on **ServerB**.

1. **Groups:** Create groups `Innovation` and `Solution`.
    
2. **Users:**
    
    - Add `James` and `Ethan` to `Innovation`.
        
    - Add `Lucas` and `Oliver` to `Solution`.
        
3. **Directories:** Create `/groups/Innovation` and `/groups/Solution`.
    
4. **Ownership:** Set group ownership of the directories to their respective groups.
    
5. **Permissions:**
    
    - Group members should have **Full Access** (RWX).
        
    - Others should have **No Access**.
        
    - Enable **SGID** so new files inherit the group owner.
        
6. **Cross-Access:** Configure an **ACL** so that members of the `Solution` group can **Read and Execute** files in the `/groups/Innovation` directory.
    

- **Aspects/Domains Covered:** Manage users and groups, Create and configure file systems (SGID, ACLs).

---

      **Question 15**

**Task:** Configure LVM with specific physical extents on **ServerB**.

1. Using disk `/dev/sdb` (create a partition if needed), create a Volume Group named `myvg`.
    
2. **Crucial:** Configure the Volume Group to use a **Physical Extent (PE) size of 16MiB**.
    
3. Create a Logical Volume named `mylv` inside this group.
    
4. The LV must contain exactly **50 Extents**.
    
5. Format with **xfs** and mount persistently at `/mnt/mylv`.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Assign physical volumes to volume groups).

---

**Question 16 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, schedule a recurring maintenance task using **Systemd Timer Units** (not Cron).

1. Create a script `/usr/local/bin/clean_tmp.sh` that deletes all **empty files** (not directories) inside `/tmp`. Make it executable.
    
2. Create a service unit named `clean-tmp.service` to run this script.
    
3. Create a timer unit named `clean-tmp.timer` that runs this service **daily at 16:15** (4:15 PM).
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).

---

**Question 17**

**Task:** Perform file archiving with exclusions on **ServerB**.

1. Create a directory `/Backup`.
    
2. Create a **gzip** compressed tar archive named `/Backup/myhome.tgz`.
    
3. The archive should contain the contents of `/home`.
    
4. **Exclude** all files with the extension `.pdf` from the archive.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive files using tar, gzip).

---

  **Question 18**

**Task:** Add swap space to **ServerB**.

1. Create a new partition of **1GiB** on `/dev/sdb`.
    
2. Format the partition as swap space.
    
3. Activate the swap space immediately.
    
4. Ensure the swap space persists after a reboot by using its **UUID**.
    

- **Aspects/Domains Covered:** Configure local storage (Add swap to a system non-destructively).

---

  **Question 19**

**Task:** Secure SSH access on **ServerB**.

1. **User Setup:** Create a user `john`.
    
2. **Key-Based Auth:** Configure passwordless SSH login for `john` from **ServerA** (or localhost). Generate keys and copy them correctly.
    
3. **Harden SSH:** Configure the SSH daemon to **disable** password authentication globally.
    
4. **Restart:** Apply the changes.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure SSH).

---

**Question 20**

**Task:** Configure network identity and local resolution on **ServerB**.

1. Set the hostname to `rhel.server.com` persistently.
    
2. Configure the `/etc/hosts` file to resolve the name `rhel.server.com` to:
    
    - The loopback address `127.0.0.1`.
        
    - The network address `192.168.1.6`.
        

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).

---

  **Question 21**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux mode.
    
2. Set the system to run in **Enforcing** mode.
    
3. Ensure this setting is persistent across reboots.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

---

**Question 22**

**Task:** Manage software packages on ServerB.

- Search for the package group named **"Development Tools"**.
    
- Display detailed information about this group to see which packages it includes.
    
- **Install** the "Development Tools" group.
    
- Verify the installation.
    

**Aspects/Domains Covered:** Manage software (Install and update software packages, Use package groups).

---

  **Question 23**

**Task:** Perform file compression on **ServerB**.

1. Create a **bzip2** compressed tar archive named `/home/bin.tar.bz2`.
    
2. The archive should contain the contents of the `/usr/bin` directory.
    
3. Ensure the tool used is `tar`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files using tar, bzip2).

---

  **Question 24**

**Task:** Configure a global environment variable on **ServerB**.

1. Create a variable named `VAR` with the value `RHCSA Prac Five`.
    
2. Ensure this variable is available to **all users**, on both local logins and remote SSH sessions.
    
3. Verify the variable is set.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Environment variables).

---

  **Question 25**

**Task:** Configure system log persistence on **ServerB**.

1. Configure `systemd-journald` to store logs persistently on disk.
    
2. Configure a size limit: The journal logs should not exceed **100MiB** of disk space.
    
3. Restart the service to apply changes.
    

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).

---

**Question 26**

**Task:** Configure **ServerB** to serve web content stored on an NFS share.

1. Install the Apache Web Server (`httpd`).
    
2. Configure **SELinux Booleans** to allow the Apache process to read files located on NFS file systems (`httpd_use_nfs`).
    
3. Ensure this boolean setting persists across reboots.
    
4. (Optional/Implied) Ensure the firewall allows web traffic.
    

- **Aspects/Domains Covered:** Manage security (Use boolean settings to modify system SELinux settings).

---

**Question 27**

**Task:** Manage SELinux File Contexts on **ServerB**.

1. Create a directory `/backup`.
    
2. Configure SELinux so that `/backup` (and all its contents) uses the same security context as the `/home` directory (`home_root_t`).
    
3. Ensure this rule is stored in the policy database so it survives a filesystem relabel.
    
4. Apply the context to the directory immediately.
    

- **Aspects/Domains Covered:** Manage security (Manage SELinux file context).

---

**Question 28**

**Task:** Configure complex firewall rules on **ServerB**.

1. Allow **HTTP** traffic (Port 80) **only** from the source network `192.168.1.0/24`.
    
2. **Reject** HTTP traffic from all other sources.
    
3. Use **Firewall Rich Rules** to accomplish this.
    
4. Ensure the configuration is permanent.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewalld).

---

  **Question 29**

**Task:** Create a system audit script on ServerB.

- Create a script `/usr/local/bin/audit_suid.sh`.
    
- The script should find all files in `/usr` that have the **SUID** (Set User ID) bit set.
    
- It should only list files smaller than **5MiB**.
    
- Save the list of found files to `/root/suid_files.txt`.
    
- Make the script executable.
    

**Aspects/Domains Covered:** Create simple shell scripts, Understand and use essential tools (Use find), Manage security (Manage default file permissions).

---

  **Question 30**

**Task:** Configure system logging on **ServerB**.

1. Configure **Rsyslog** to send all messages with the priority **debug** (from any facility) to a specific file: `/var/log/debug_messages.log`.
    
2. Restart the `rsyslog` service to apply the change.
    
3. Generate a test debug message using the `logger` command to verify.
    

- **Aspects/Domains Covered:** Operate running systems (Locate and interpret system log files).

---

