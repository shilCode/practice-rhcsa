# Practice Test Four - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `countersign` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

**Question 2**

**Task:** Configure a software repository on **ServerB** using the locally mounted RHEL 10 DVD/ISO.

1. Create the directory /mnt/repo.
    
2. Mount the ISO/DVD device /dev/sr0 to /mnt/repo automatically at boot.
    
3. Configure a DNF repository to install packages from /mnt/repo (BaseOS and AppStream).
    
4. Enable GPG checking using the key located at /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Mount file systems at boot).

---

**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings:

- **IPv4:** `192.168.1.5/24`, Gateway: `192.168.1.1`, DNS: `8.8.8.8`.
    
- **IPv6:** `fd01::105/64`, Gateway: `fd01::1`.
    
- **Secondary IPv4:** `10.0.0.5/24`.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

---

**Question 4**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters).

---

**Question 5 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, replace a legacy Cron job with a **Systemd Timer**.

1. Create a script /usr/local/bin/notify.sh that prints "Time for Break!" to the system log (use logger). Make it executable.
    
2. Create a service unit notify.service.
    
3. Create a timer unit notify.timer that runs this service **daily at 7:00 AM**.
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).

---

**Question 6**

**Task:** Configure system time settings on **ServerB**.

1. Set the system timezone to **America/Cancun**.
    
2. Configure **NTP** using `chrony` to synchronize the system clock.
    
3. Ensure the `chronyd` service is enabled and running.
    
4. Verify that NTP synchronization is active.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).

---

**Question 7**

**Task:** Configure **ServerB** to boot into the **Graphical Target** by default.

1. Ensure that upon reboot, the system presents a graphical login screen (GUI).
    
2. Verify the default target setting.
    

- **Aspects/Domains Covered:** Operate running systems (Configure systems to boot into a specific target automatically).

---

**Question 8**

**Task:** Manage user accounts on **ServerB**.

1. Create a user named `john`.
    
2. Manually assign the **UID** `1250`.
    
3. Configure the account to **expire** on **December 21, 2029** (2029-12-21).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).

---

**Question 9**

**Task:** Configure permissions and Access Control Lists (ACLs) on **ServerB**.

1. Create a file `/var/test`.
    
2. Configure base ownership: Owner `oliver`, Group `admins`.
    
3. **Base Permissions:**
    
    - Owner (`oliver`): Read/Write.
        
    - Group (`admins`): Read Only.
        
    - Others: Read Only.
        
    - No one should have Execute permissions.
        
4. **ACL Configuration:**
    
    - User `jack` must have **Read and Write** access.
        
    - User `jacob` must have **No Access** (0).
        

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems).

---

**Question 10**

**Task:** Configure **LVM** storage on **ServerB**.

1. Using disk `/dev/sdb`, create a Volume Group named `vg1`. (Create a 2GiB partition first if necessary).
    
2. Create a Logical Volume named `lv1` with a size of **1GiB**.
    
3. Format `lv1` with **ext4** and mount it persistently at `/lv1`.
    
4. **Extend** the Logical Volume by **500MiB** and resize the filesystem.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

---

**Question 11**

**Task:** Configure deduplicated and compressed storage on ServerB using VDO.

- Using disk /dev/sdc (or an available partition), create a Volume Group named vdovg.
    
- Create a VDO Logical Volume named myvdo.
    
- Set the Physical size to **5GiB** (to accommodate VDO metadata).
    
- Set the Logical (Virtual) size to **50GiB**.
    
- Format the volume with xfs.
    
- Mount it persistently at /mydir.
    

**Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - VDO).

---

**Question 12**

**Task:** Optimize **ServerB** for a specific workload using **Tuned**.

1. Enable the `tuned` service.
    
2. Apply a combined profile configuration:
    
    - Base profile: `virtual-guest` (to optimize for running inside a VM).
        
    - Overlay profile: `accelerator-performance` (or `throughput-performance` if the accelerator profile is unavailable) to disable latency-inducing power saving states.
        
3. Verify the active profiles.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

**Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install `httpd`.
    
2. Configure the default page (`index.html`) to display: "Welcome to the RHCSA Exam".
    
3. Configure the **Firewall** to allow HTTP and HTTPS.
    
4. Ensure the service starts on boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Firewall).

---

**Question 14**

**Task:** Perform file archiving on **ServerB**.

1. Create a directory `/archive`.
    
2. Create a **gzip** compressed tar archive named `/archive/sysconfig.tar.gz`.
    
3. The archive must contain the `/etc` directory and the file `/root/anaconda-ks.cfg`.
    
4. **Restore** the archive into the directory `/restored/` (create if needed).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files).

---

  **Question 15**

**Task:** Perform system initialization and hardening on **ServerB**.

1. **Hostname:** Set the static hostname to test.server.com.
    
2. **SSH Security:** Configure the SSH daemon to **disable** password authentication (forcing key-based auth).
    
3. **Restart:** Ensure all changes are applied and persistent.
    

**Aspects/Domains Covered:** Manage Basic Networking (Hostname), Manage security (Configure SSH).

---

    **Question 16**

**Task:** Configure **ServerB** (or `test.server.com`) to run SELinux in **Permissive** mode.

1. Check the current SELinux status.
    
2. Set the current runtime mode to Permissive.
    
3. Ensure the system stays in Permissive mode after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

---

  **Question 17 (New Topic: Flatpak)**

**Task:** Manage desktop applications on **ServerB** using Flatpak.

1. Add the **Flathub** remote repository: `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
2. Install the application `org.kde.kcalc` (KCalc) from this remote.
    
3. Ensure the installation is successful.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

---

  **Task:** Configure default file permissions on **ServerB**.

1. Create a user named `sarah`.
    
2. Configure `sarah`'s environment so that **every time she logs in**, her default **Umask** ensures:
    
    - New **files** have permissions `600` (`rw-------`).
        
    - New **directories** have permissions `700` (`rwx------`).
        

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).

---

  **Question 19**

**Task:** Perform advanced shell redirection on **ServerB**.

1. Execute the command ls /root /fake_directory. (This will generate both a file list output and an error message).
    
2. Redirect **both** the Standard Output (success) and Standard Error (failure) to the same file named /var/tmp/ls_output.txt.
    
3. Ensure the file is overwritten if it already exists.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use input-output redirection 2>&1, &>).

---

    **Question 20**

**Task:** Configure environment variables on **ServerB**.

1. Create a **global** environment variable named CLASS with the value RHCSA.
    
2. Ensure this variable is available to **all users** on the system automatically when they log in.
    
3. Verify by switching to a user (e.g., sarah) and echoing the variable.
    

**Aspects/Domains Covered:** Create simple shell scripts (Environment variables, startup scripts).

---

    **Question 21**

**Task:** Perform advanced text searches on **ServerB** using regular expressions.

1. Create a file named `/root/dates.txt` with the following content:
    
    1. 2000-05-01 Sam
    2. 2002-06-15 Sue
    3. 2004-12-29 Sarah
    4. 2005-05-10 Mike
    
2. Use `grep` to find all lines where the month is **May (05)** or **June (06)**.
    
3. Redirect the output to `/root/summer_birthdays.txt`.
    
4. Ensure the regex strictly matches the date format (e.g., `-05-` or `-06-`).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use grep and regular expressions to analyze text).

---

    **Question 22**

**Task:** Create a shell script named `/usr/local/bin/process_lines.sh`.

1. The script should read the file `/root/dates.txt` (created in the previous step) line by line.
    
2. For each line, it should print: "Name: [Name] was born on [Date]".
    
3. Use a `while` loop to process the file.
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs, Process file input).

---

    **Question 23**

**Task:** Manage process signals on **ServerB**.

1. Start the process `sleep 10000` in the background.
    
2. Find the PID of this process.
    
3. Send the **SIGINT** (Interrupt) signal to this process (simulating a Ctrl+C).
    
4. Verify the process has terminated.
    

- **Aspects/Domains Covered:** Operate running systems (Kill processes).

---

  **Question 24**

**Task:** Configure **ServerB** to boot into **Rescue Mode** by default.

1. Set the default systemd target to `rescue.target`.
    
2. This ensures that upon the next reboot, the system drops into a single-user maintenance shell requiring the root password.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually).

---

  **Question 25**

**Task:** Configure system logging on **ServerB** to be persistent.

1. Configure `systemd-journald` so that logs are stored on disk (`/var/log/journal`) instead of only in memory.
    
2. Restart the journal service.
    
3. Verify that the directory `/var/log/journal` has been created and populated.
    

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).

---

    **Question 26**

**Task:** Configure **ServerB** to allow the Apache web server process (`httpd_t`) to run in **Permissive** mode, while keeping the rest of the system in **Enforcing** mode.

1. Use the `semanage` command to set the permissive mode for the `httpd_t` domain.
    
2. Verify that the domain is in the permissive list.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux - specifically domains).

---

    **Question 27**

**Task:** Create a shell script named `/usr/local/bin/audit_suid.sh` on **ServerB**.

1. The script should find all files in the `/usr` directory that have the **SUID** (Set User ID) bit set.
    
2. It should only list files smaller than **10MiB**.
    
3. The script should copy these files to the directory `/root/audit_results/` (creating it if it doesn't exist).
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts, Understand and use essential tools (Find files).

---

    **Question 28**

**Task:** Perform a file management operation on ServerB.

- Create a directory `/find/sam_files`.
    
- Find all files and directories in `/home` that are owned by the user **sam**.
    
- Copy them to `/find/sam_files`, ensuring that **permissions and ownership are preserved**.
    

**Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use find).

---

  **Question 29**

**Task:** Schedule a one-time task on **ServerB**.

1. Use the `at` command to schedule a job to run at **23:30** (11:30 PM) today.
    
2. The job should create an empty file named `/var/tmp/late_night_check.txt`.
    
3. Verify the job is in the queue.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at).

---

  **Question 30**

**Task:** Perform a recursive text search on **ServerB**.

1. Search the entire `/var/log` directory structure.
    
2. Find all files containing the string **"error"** (case-insensitive).
    
3. Save the list of matching lines to `/root/error_report.txt`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use grep and regular expressions to analyze text).

---

