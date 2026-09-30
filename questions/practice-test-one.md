# Practice Test One - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerA**. Securely reset the root password to `password` to regain access to the system.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

**Question 2**

**Task:** Configure a Local Yum/DNF Repository on **ServerA**.

- Mount the provided ISO image `RHEL-10.iso` to the `/mnt` directory.
    
- Configure the system to allow installing packages from the **BaseOS** and **AppStream** repositories located inside the ISO image.
    
- Ensure GPG signature checking is **disabled** for these repositories to avoid key errors.
    
- **Aspects/Domains Covered:** Manage Software (Configure access to RPM repositories).

---

**Question 3**

**Task:** On **ServerA**, configure a NetworkManager connection profile named `lab-link` for the network interface `enp0s3` (or your default interface). The connection must persist after reboot and meet the following specifications:

- **Primary IPv4 Address:** `192.168.1.10/24`
    
- **IPv4 Gateway:** `192.168.1.1`
    
- **IPv4 DNS:** `8.8.8.8`
    
- **Primary IPv6 Address:** `fd00::10/64`
    
- **IPv6 Gateway:** `fd00::1`
    
- **Secondary IPv4 Address:** `10.0.0.5/24` (Ensure this does not overwrite the primary IP).
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses, Persistence).

---

**Question 4**

**Task:** Configure time synchronization services on **ServerA** with the following requirements:

1. Set the system timezone to **America/New_York**.
    
2. Configure the **Chrony** service to synchronize time with the server `pool.ntp.org`.
    
3. Ensure the Chrony service is enabled and starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, Configure, and Maintain Systems (Configure time service clients).

---

**Question 5 (New Topic: Flatpak)**

**Task:** On **ServerA**, configure the **Flatpak** package management system to allow installing desktop applications.

1. Add a new remote repository named flathub using the official URL: `https://dl.flathub.org/repo/flathub.flatpakrepo`
    
2. Install the application org.gnome.TextEditor from this new remote.
    

- **Aspects/Domains Covered:** Manage Software (Configure access to Flatpak repositories, Install Flatpak software).

---

**Question 6**

**Task:** On **ServerA**, configure local storage using `/dev/sdb`. Perform the following actions:

1. Create a partition on `/dev/sdb` and configure it as a physical volume.
    
2. Create a volume group named `myvg`.
    
3. Create a logical volume named `mylv` with a size of **500MiB**.
    
4. Format `mylv` with the **ext4** filesystem.
    
5. Persistently mount it at `/mylv`.
    
6. Finally, **extend** the logical volume and its filesystem by an additional **500MiB** (Total size approx 1GiB).
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Configure systems to mount file systems, Extend existing logical volumes).

---

**Question 7 (New Topic: Systemd Timers)**

**Task:** On **ServerA**, configure a scheduled task using **Systemd Timer Units** (not Cron).

1. Create a script at /usr/local/bin/system-check.sh that appends the current date to /var/log/system-check.log. Ensure it is executable.
    
2. Create a systemd service unit named system-check.service that executes this script.
    
3. Create a systemd timer unit named system-check.timer that runs the service **every 1 minute**.
    
4. Enable and start the timer.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at, cron, and systemd timer units).

---

**Question 8**

**Task:** Set up a basic web server on **ServerA**:

1. Install the Apache HTTP server (`httpd`).
    
2. Configure the server to display the text "Welcome to RHEL 10" when the site is accessed.
    
3. Ensure the service starts automatically at boot.
    
4. Configure the firewall to allow traffic for HTTP services permanently.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewall-cmd), Deploy, configure, and maintain systems (Start and stop services).

---

**Question 9**

**Task:** Locate all files in the `/etc` directory that are larger than **3MiB**. Copy these files to the directory `/find/largefiles`.

- Ensure the destination directory is created if it does not exist.
    
- Do not overwrite files if they already exist in the destination.
    
- **Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use grep and regular expressions [conceptual overlap with find]).

---

**Question 10**

**Task:** Configure the bootloader on **ServerA** so that boot messages are visible during startup (disable the quiet graphical boot).

- Remove the rhgb and quiet parameters from the current kernel's boot options.
    
- Ensure this change persists for future kernel updates if possible, or at least applies to the current kernel permanently.
    
- **Aspects/Domains Covered:** Operate running systems (Boot, reboot, and shut down a system normally - specifically modifying boot parameters).

---

**Question 11**

**Task:** Create a shell script named `/usr/local/bin/flipargs.sh` on **ServerA**.

- The script must accept exactly **two** arguments.
    
- When executed, it should output the second argument first, followed by a space, and then the first argument.
    
- Example: `./flipargs.sh red blue` should output `blue red`.
    
- Ensure the script is executable by all users.
    
- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs `$1`, `$2`).

---

**Question 12**

**Task:** Configure user environment and security policies on **ServerA**:

1. **Skeleton Directory:** Ensure that a file named `Welcome.txt` is automatically created in the home directory of every **newly created** user.
    
2. **Password Aging:** Configure the system so that password aging controls require users to change their password every **90 days**.
    
3. **Password Length:** Ensure that all new passwords must be at least **8 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging, Configure password quality).

---

**Question 13**

**Task:** On **ServerA**, configure a collaboration directory for the `developers` group.

1. Create a group named `developers`.
    
2. Create a directory `/opt/dev-data`.
    
3. Set the ownership so that the group `developers` owns the directory.
    
4. Configure permissions so that:
    
    - The owner and group have **Read, Write, and Execute** access.
        
    - Other users have **No** access.
        
    - **Crucial:** Files created inside this directory automatically inherit the group ownership `developers` (use the Set-GID bit).
        

- **Aspects/Domains Covered:** Create, configure, and maintain systems (Create and configure file systems), Manage users and groups (Modify group memberships, Configure file permissions).

---

**Question 14**

**Task:** Create a compressed archive on **ServerA**.

1. Create a **gzip** compressed tar archive named `/root/config_backup.tar.gz`.
    
2. The archive should contain the contents of the `/etc/ssh` directory.
    
3. Verify the contents of the archive after creation without extracting it.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack, and uncompress files using tar, gzip).

---

**Question 15**

**Task:** Add swap space to **ServerA** non-destructively.

1. Create a new partition of **512MiB** on disk `/dev/sdb`.
    
2. Format and configure this partition as **swap** space.
    
3. Ensure the swap space is activated automatically at system boot.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Add swap to a system non-destructively).

---

**Question 16**

**Task:** Configure SSH access and security on **ServerA**:

1. Generate an SSH key pair for the user root.
    
2. Copy the public key to **localhost** (simulating a remote server) so that root can log in to itself without a password.
    
3. Modify the SSH configuration (/etc/ssh/sshd_config) to **disable password authentication** entirely (forcing key-based auth only).
    
4. Restart the SSH service to apply changes.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication for SSH), Essential Tools (Access remote systems using SSH).

---

**Question 17**

**Task:** Optimize **ServerA** performance using the **Tuned** service.

1. Install and enable the tuned service if it is not already running.
    
2. Identify the currently active tuning profile.
    
3. Switch the active profile to **throughput-performance**.
    
4. Verify that the new profile is active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

**Question 18**

**Task:** Configure **ServerA** to mount a remote directory using **Autofs**.

1. Install the necessary NFS and Autofs packages.
    
2. Configure Autofs to mount the remote directory 192.168.1.100:/shares/public (replace IP with your lab's NFS server IP) to the local directory /data/public.
    
3. The mount should only happen **on-demand** (when the directory is accessed).
    
4. Ensure Autofs starts automatically at boot.
    

- **Aspects/Domains Covered:** Create and configure file systems (Configure autofs, Mount network file systems using NFS).

---

**Question 19**

**Task:** Configure privileged access on **ServerA**.

1. Create a user named `alex`.
    
2. Configure **sudo** access for `alex` so that they can run the `dnf` command **without entering a password**.
    
3. Ensure `alex` cannot run any other commands with sudo.
    

- **Aspects/Domains Covered:** Manage users and groups (Configure privileged access).

---

**Question 20 (Advanced LVM - VDO)**

**Task:** On ServerA, create a VDO (Virtual Data Optimizer) logical volume for efficient storage.

- Using the existing volume group myvg, create a VDO Logical Volume named vdo_lv.
    
- Set the physical size to **5GiB** (to accommodate VDO metadata), and the logical (virtual) size to **20GiB**.
    
- Format the volume with xfs and mount it persistently at /vdo_data.
    

**Aspects/Domains Covered:** Configure local storage (Create and delete logical volumes - specifically VDO/Thin Provisioning types).

---

**Question 21**

**Task:** Configure **ServerA** to preserve system journals across reboots.

1. Configure `systemd-journald` so that logs are written to persistent storage (disk) rather than just memory.
    
2. Restart the logging service to apply the change.
    
3. Locate all journal entries related to the `sshd` service that have occurred **since the last boot** and save them to `/var/log/ssh_boot.log`.
    

- **Aspects/Domains Covered:** Operate running systems (Locate and interpret system log files and journals, Preserve system journals).

---

**Question 22**

**Task:** Manage processes on **ServerA**.

1. Start a background process using the command `sleep 1000`.
    
2. Identify the **PID** (Process ID) of this process.
    
3. Adjust the priority (niceness) of this running process to **+5**.
    
4. Finally, kill the process using its PID.
    

- **Aspects/Domains Covered:** Operate running systems (Identify CPU/memory intensive processes and kill processes, Adjust process scheduling).

---

**Question 23**

**Task:** Configure Access Control Lists (ACLs) on **ServerA**.

1. Copy the file `/etc/fstab` to `/var/tmp/fstab_copy`.
    
2. Configure permissions on `/var/tmp/fstab_copy` so that the user `alex` has **Read and Write** access.
    
3. Ensure that the group owner and other users retain their existing permissions.
    
4. Do **not** change the file's owner or group owner.
    

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - implicitly ACLs).

---

**Question 24**

**Task:** Create a shell script named `/usr/local/bin/user_audit.sh`.

1. The script should use a **loop** to iterate through the usernames: `root`, `adm`, and `ftp`.
    
2. For each user, it should print the line: "User [username] has ID [uid]".
    
3. You must obtain the UID programmatically (e.g., using the `id` command) inside the loop.
    
4. Ensure the script is executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs, Process output of shell commands within a script).

---

**Question 25**

**Task:** On **ServerA**, perform a text search and extraction.

1. Search the file `/etc/ssh/sshd_config`.
    
2. Find all lines that **start with** the keyword `Host` (case-insensitive).
    
3. Save these lines to the file `/root/ssh_hosts.txt`.
    
4. Ensure the output file does not contain any commented-out lines (lines starting with `#`).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use grep and regular expressions to analyze text, Use input-output redirection).

---

**Question 26**

**Task:** Configure **ServerA** to boot into the **Multi-User Target** by default.

1. Ensure that when the system reboots, it starts in a non-graphical command-line environment.
    
2. Verify the default target has been set correctly.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually, Configure systems to boot into a specific target automatically).

---

**Question 27**

**Task:** Configure **ServerA** to allow the web server to run on a non-standard port.

1. Configure the Apache (httpd) server to listen on port **82** (Edit /etc/httpd/conf/httpd.conf).
    
2. Restart the httpd service. It will likely fail.
    
3. Configure **SELinux** to allow the httpd process to bind to TCP port **82**.
    
4. Configure the **Firewall** to allow traffic on TCP port **82**.
    
5. Restart the service successfully.
    

- **Aspects/Domains Covered:** Manage security (Manage SELinux port labels, Configure firewall settings).

---

**Task:** Configure default file permissions for the user `harry` on **ServerA**.

1. Modify `harry`'s environment so that any **new file** he creates has the permission `rw-r-----` (640).
    
2. Ensure this setting is persistent (applies every time he logs in).
    

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).

---

**Question 29**

**Task:** Securely transfer a file from **ServerA** to **ServerB** (or localhost if ServerB is unavailable).

1. You have a file named `/root/anaconda-ks.cfg` on ServerA.
    
2. Copy this file to the `/tmp` directory on the remote system **ServerB** (or `localhost`).
    
3. Ensure the file attributes (timestamps/permissions) are preserved during the transfer.
    

- **Aspects/Domains Covered:** Operate running systems (Securely transfer files between systems).

---

**Question 30**

**Task:** Create a shell script on **ServerA** named `/usr/local/bin/checkfile.sh`.

1. The script should accept **one argument** (a filename).
    
2. **Condition:**
    
    - If the file exists, print "File exists."
        
    - If the file does _not_ exist, print "File missing."
        
3. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Conditionally execute code using `if`, `test`, `[]`).

---

