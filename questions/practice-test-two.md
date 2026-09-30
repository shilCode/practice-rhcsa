# Practice Test Two - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `secret` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

**Question 2**

**Task:** Configure a software repository on **ServerB**.

1. Mount the provided ISO image `/RHEL-10.iso` to the directory `/repo`.
    
2. Configure a DNF repository to install packages from the **BaseOS** and **AppStream** directories within that mount point.
    
3. Ensure the configuration persists after a reboot (i.e., the ISO is mounted automatically).
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Configure systems to mount file systems at boot).

---

**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings.

- **IPv4:** 192.168.1.3/24, Gateway: 192.168.1.1, DNS: 8.8.8.8.
    
- **Secondary IPv4:** 10.0.0.3/24.
    
- **IPv6:** fd01::103/64, Gateway: fd01::1.
    
- **Secondary IPv6:** fd01::200/64.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

---

**Question 4**

**Task:** Configure system time and synchronization on **ServerB**.

1. Set the system timezone to **Europe/London**.
    
2. Install and enable **Chrony** (NTP) to synchronize time.
    
3. Verify that the system is synchronized ("NTP synchronized: yes").
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).

---

**Question 5**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters / Tune systems).

---

**Question 6**

**Task:** Configure **ServerB** so that boot messages are visible during startup (disable the quiet, graphical boot).

1. Remove the `rhgb` and `quiet` parameters from the current kernel's boot options.
    
2. Ensure this change is persistent and applies to the default kernel.
    

- **Aspects/Domains Covered:** Operate running systems (Boot, reboot, and shut down a system normally).

---

**Question 7**

**Task:** Configure local storage on **ServerB** using the disk /dev/sdb.

1. Create a **4GiB** partition on /dev/sdb and initialize it as a physical volume.
    
2. Create a volume group named vgmyvg.
    
3. Create a logical volume named lvmylv with a size of **1GiB**.
    
4. Format the logical volume with **ext4** and mount it persistently at /lvmylv.
    
5. **Extend** the logical volume by **500MiB** and resize the filesystem to match.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

---

**Question 8**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP server (httpd).
    
2. Create a file at /var/www/html/index.html containing the text "Hello World!".
    
3. Ensure the web server starts automatically at boot.
    
4. Configure the Firewall to allow traffic on both **HTTP** and **HTTPS**.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install and update software packages), Manage security (Configure firewall settings).

---

**Question 9**

**Task:** Create a shell script named `/usr/local/bin/yes-no.sh` on **ServerB**.

1. The script should accept one argument.
    
2. If the argument is **yes** (case-insensitive), output "That is nice".
    
3. If the argument is **no** (case-insensitive), output "I am sorry".
    
4. If the argument is anything else, output "Unknown argument".
    
5. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Conditionally execute code).

---

**Question 10**

**Task:** Update the kernel on **ServerB**.

1. Install the latest kernel update available in the repositories.
    
2. Ensure this new kernel is set as the **default** boot option.
    
3. Reboot the system to verify the new kernel is loaded.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install and update software packages, Modify the system bootloader).

---

**Question 11**

**Task:** Configure the hostname of **ServerB**.

1. Set the static hostname to `rhel.server.com`.
    
2. Ensure this change is persistent across reboots.
    
3. Verify the change.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).

---

**Question 12**

**Task:** Perform a file search and backup on **ServerB**.

1. Create a directory named `/find/rootfiles`.
    
2. Locate all **regular files** in `/usr/bin` that are owned by the user `root`.
    
3. Copy these files into `/find/rootfiles`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use grep/find).

---

**Question 13**

**Task:** Configure global user policies on **ServerB**.

1. **Skeleton:** Ensure that a file named `Note` is automatically created in the home directory of any **new** user created on the system.
    
2. **Expiration:** Configure the system so that user passwords expire every **100 days**.
    
3. **Complexity:** Enforce a policy that passwords must be at least **9 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging).

---

**Question 14**

**Task:** Create a restricted user on **ServerB**.

1. Create a user named `sam`.
    
2. Manually assign the **UID** `1500`.
    
3. Configure the account so `sam` **cannot** access an interactive shell (prevent login).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).

---

**Question 15**

**Task:** Configure **Access Control Lists (ACLs)** on **ServerB**.

1. Copy the file `/etc/fstab` to `/var/tmp/fstab`.
    
2. Modify the file's ownership: User `root`, Group `root`.
    
3. Remove all execute permissions from the file.
    
4. Configure **ACLs** so that:
    
    - User `stewart` has **Read/Write** access.
        
    - User `kevin` has **No** access (neither read, write, nor execute).
        

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - utilizing ACLs).

---

**Question 16 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, configure a scheduled task using **Systemd Timer Units** (do not use Cron).

1. Create a script /usr/local/bin/clean-tmp.sh that deletes all **empty files** in the /tmp directory. Make it executable.
    
2. Create a Service Unit (clean-tmp.service) to execute this script.
    
3. Create a Timer Unit (clean-tmp.timer) that runs the service **once every day** (e.g., at midnight).
    
4. Enable and start the timer.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).

---

**Question 17**

**Task:** Perform archival and restoration on **ServerB**.

1. Create a **bzip2** compressed archive of the `/etc` directory.
    
2. Save the archive as `/archive/myetc.tbz2`. (Create the directory if needed).
    
3. **Restore** the contents of this archive into the directory `/restored/myetc/`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack, and uncompress files using tar, bzip2).

---

**Question 18**

**Task:** Optimize **ServerB** for a specific workload.

1. Install and start the `tuned` service.
    
2. Set the active profile to **powersave** (prioritizing low power consumption over performance).
    
3. Verify the active profile.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

**Question 19**

**Task:** Secure SSH access on ServerB.

1. Create a user alice on **ServerB**.
    
2. Generate SSH keys on **ServerA** (Client) and copy them to alice on **ServerB**.
    
3. Configure **ServerB** to allow alice to log in via SSH using keys without a password.
    
4. Edit the SSH configuration on **ServerB** to disable root login via SSH completely.
    
5. Edit the SSH configuration on **ServerB** to disable password authentication for all users.
    

**Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure firewall/SSH settings).

---

**Question 20**

**Task:** Add swap space to **ServerB**.

1. Create a partition of **500MiB** on /dev/sdb.
    
2. Format it as swap and activate it.
    
3. Ensure it persists after reboot using the **UUID**.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Add swap non-destructively).

---

**Question 21**

**Task:** Customize the user environment and perform input/output operations on **ServerB**.

1. Configure a persistent **alias** for the user `root`. The command `myfiles` should execute `ls -l /tmp`. Ensure this works every time root logs in.
    
2. Search the file `/etc/services` for lines containing the string **http**. Redirect these lines to a new file `/root/http_services.txt`, overwriting it if it exists.
    
3. Append the text "Search Complete" to `/root/http_services.txt` without deleting the existing content.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create and edit text files, Use input-output redirection, Shell environment customization).

---

**Question 22**

**Task:** Configure a persistent NFS mount on **ServerB** using /etc/fstab (Do not use Autofs).

1. Create the directory /nfs_share on ServerB.
    
2. Configure the system to mount the remote export servera:/share (or your lab IP) to /nfs_share automatically at boot.
    
3. Ensure the system uses the _netdev option to prevent boot hanging if the network is down.
    

**Aspects/Domains Covered:** Create and configure file systems (Mount network file systems using NFS, Configure systems to mount file systems at boot).

---

**Question 23**

**Task:** Manage SELinux File Contexts on **ServerB**.

1. Create a custom web directory structure: /web/content/html.
    
2. Create a file /web/content/html/index.html.
    
3. Configure **SELinux** so that the Apache web server (httpd) can serve content from this directory.
    
    - Set the context httpd_sys_content_t on /web and all subdirectories recursively.
        
    - Ensure this context rule persists even if the filesystem is relabeled later.
        
    - Apply the context immediately.
        

- **Aspects/Domains Covered:** Manage security (List and identify SELinux file context, Restore default file contexts).

---

**Question 24**

**Task:** Manage file links on **ServerB**.

1. Create a file `/home/root/data.txt`.
    
2. Create a **Hard Link** to this file named `/home/root/data-hard`.
    
3. Create a **Soft (Symbolic) Link** to this file named `/var/tmp/data-soft`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create hard and soft links).

---

**Question 25**

**Task:** Configure Access Control for the Cron scheduler on **ServerB**.

1. Configure the system so that only the user `tom` is allowed to create cron jobs.
    
2. All other users (except root) should be denied.
    
3. Verify by attempting to list cron jobs as a different user (e.g., `sam`).
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at and cron).

---

**Question 26**

**Task:** Configure **ServerB**'s SELinux mode.

1. Check the current SELinux mode.
    
2. Set the system to run in **Enforcing** mode.
    
3. Ensure this setting is persistent across reboots.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

---

**Question 27 (New Topic: Flatpak)**

**Task:** Manage applications on **ServerB** using **Flatpak**.

1. Add the **Flathub** remote repository (URL: https://dl.flathub.org/repo/flathub.flatpakrepo) if it does not exist.
    
2. Search for the application GIMP (GNU Image Manipulation Program).
    
3. Install the GIMP application from Flathub.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

---

**Question 28**

**Task:** Configure a shared group directory on **ServerB**.

1. Create a directory `/collaboration`.
    
2. Create a group named `managers`.
    
3. Set ownership so that `/collaboration` is owned by the group `managers`.
    
4. Configure permissions so that new files created inside `/collaboration` **automatically inherit** the group `managers`.
    

- **Aspects/Domains Covered:** Manage users and groups (Modify local groups), Create and configure file systems (Configure permission problems/SGID).

---

**Question 29**

**Task:** Install a software package from a remote URL on **ServerB**.

1. Install the `zsh` package.
    
2. Do not use the standard repository. Instead, install it directly from this URL: `http://example.com/pub/zsh.rpm` (Note: In the real exam, this will be a valid internal link).
    
3. Ensure dependencies are resolved automatically.
    

- **Aspects/Domains Covered:** Manage software (Install software packages from a remote repository or file system).

---

**Question 30**

**Task:** Manage process priorities and signals on **ServerB**.

1. Start a background process: `sleep 5000 &`.
    
2. Locate the **PID** of this process.
    
3. Change the priority (niceness) of this running process to **15** (Lower priority).
    
4. Terminate the process gracefully using the **SIGTERM** signal.
    

- **Aspects/Domains Covered:** Operate running systems (Identify CPU intensive processes, Adjust process scheduling, Kill processes).

---

