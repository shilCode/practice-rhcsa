# Practice Test Three - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `passmypass` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

**Question 2**

**Task:** Configure a software repository on **ServerB** using the provided HTTP server.

1. Configure a DNF repository to install packages from the URL http://192.168.1.12/rhel10/BaseOS.
    
2. Configure a second repository for the URL http://192.168.1.12/rhel10/AppStream.
    
3. Ensure GPG checking is disabled for both repositories.
    
4. Verify that the repositories are functional.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings:

- **IPv4:** 192.168.1.4/24, Gateway: 192.168.1.1, DNS: 8.8.8.8.
    
- **IPv6:** fd01::103/64, Gateway: fd01::100, DNS: fd01::111.
    
- **Secondary IPs:** Add the secondary IPv4 address 10.0.0.4/24 to the same interface.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

---

**Question 4**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters / Tune systems).

---

**Question 5 (New Topic: Systemd Timers)**

**Task:** On ServerB, create a scheduled task using Systemd Timer Units.

1. Create a script /usr/local/bin/break-time.sh that prints "Break Time!" to the current user's terminal (or logs it to a file /tmp/break.log for simpler verification). Make it executable.
    
2. Create a service unit break-time.service to execute this script.
    
3. Create a timer unit break-time.timer that runs this service every **2 hours**.
    
4. Ensure the timer is active and enabled.
    

**Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units)

---

**Question 6**

**Task:** Configure local storage on **ServerB** using the disk /dev/sdb (Standard Partitioning, not LVM).

1. Create a **512MiB** partition on /dev/sdb.
    
2. Format the partition with the **ext4** file system.
    
3. Ensure the partition is automatically mounted at boot under the directory /mnt/data.
    
4. Use the partition's **UUID** in the configuration file to ensure persistence.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Configure systems to mount file systems at boot).

---

**Question 7**

**Task:** Manage user accounts on **ServerB**.

1. **Modify User:** Change the user `sam`'s default login shell to `/bin/bash`.
    
2. **Create User:** Create a new user named `john`.
    
    - Assign the specific **UID** `1250`.
        
    - Set the account to **expire** on **December 21, 2029**.
        

- **Aspects/Domains Covered:** Manage users and groups (Create/modify local user accounts).

---

**Question 8**

**Task:** Configure granular file permissions (ACLs) on **ServerB**.

1. Copy the file `/etc/hosts` to `/var/nhosts`.
    
2. Configure Access Control Lists (ACLs) on `/var/nhosts` with the following requirements:
    
    - User `sam` must have **Read, Write, and Execute** permissions.
        
    - User `john` must have **Read-only** permission.
        
    - Ensure the file's standard owner and group permissions are not negatively affected.
        

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - utilizing ACLs).

---

**Question 9 (New Topic: Flatpak)**

**Task:** Manage applications on **ServerB** using **Flatpak**.

1. Add the remote repository named `flathub` using the URL `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
2. Install the application `org.gnome.Calculator` from the `flathub` remote.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

---

**Question 10**

**Task:** Configure **LVM (Logical Volume Manager)** storage on **ServerB**.

1. Create a volume group named vgroup using the disk partition /dev/sdb2 (Create the partition first if needed, size 4GiB).
    
2. Create a logical volume named lvol with a size of **1GiB**.
    
3. Format lvol with **ext4** and mount it persistently at /lvol.
    
4. **Extend** the logical volume by **100MiB** and ensure the filesystem recognizes the new space.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

---

**Question 11**

**Task:** Optimize **ServerB** performance using **Tuned**.

1. Install and enable the `tuned` service.
    
2. Configure the system to use **two** profiles simultaneously: `virtual-guest` and `powersave`.
    
3. Ensure the settings persist.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

**Question 12**

**Task:** Create a shell script named /usr/local/bin/sum.sh on **ServerB**.

1. The script should interactively prompt the user to "Enter the first number".
    
2. Then prompt the user to "Enter the second number".
    
3. Calculate the sum of the two numbers.
    
4. Print the result in the format: "The result of addition=[sum]".
    
5. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Processing output, simple math).

---

**Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server (httpd).
    
2. Create a custom index file at /var/www/html/index.html containing the text: "Welcome to the RHCSA Practice Exam!".
    
3. Configure the **Firewall** to allow HTTP and HTTPS traffic permanently.
    
4. Ensure the service starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Configure firewall settings).

---

**Question 14**

**Task:** Perform a file search on **ServerB**.

1. Find all files in `/etc` (and its subdirectories) that are **larger than 5MiB**.
    
2. Copy these files to the directory `/find/5mfiles`.
    
3. Create the destination directory if it does not exist.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create directories, Copy files, Use find).

---

**Question 15**

**Task:** Configure user environment policies on **ServerB**.

1. **Skeleton:** Configure the system so that a file named `Welcome` is automatically created in the home directory of every **new** user.
    
2. **Password Aging:** Ensure that passwords for new users expire after **60 days**.
    
3. **Complexity:** Ensure that new passwords must be at least **9 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging/complexity).

---

**Question 16**

**Task:** Configure a collaborative directory structure on **ServerB**.

1. **Create Groups:** Create two groups named `accounting` and `finance`.
    
2. **Create Users:**
    
    - Create `alex` and `peter` with the secondary group `accounting`.
        
    - Create `carl` and `dan` with the secondary group `finance`.
        
3. **Create Directories:** Create `/groups/accounting` and `/groups/finance`.
    
4. **Configure Ownership & Standard Permissions:**
    
    - `/groups/accounting` should be owned by the group `accounting`.
        
    - `/groups/finance` should be owned by the group `finance`.
        
    - Both directories should have **Full Access** (RWX) for the owner and group, and **No Access** for others.
        
5. **Configure Inheritance (SGID):** Ensure that new files created in these directories automatically inherit the group ownership of the directory.
    
6. **Configure Cross-Group Access (ACL):** Allow the `finance` group to have **Read and Execute** (r-x) access to the `/groups/accounting` directory and any new files created within it.
    

- **Aspects/Domains Covered:** Manage users and groups (Modify group memberships), Create and configure file systems (Configure set-GID directories, Diagnose/correct permissions with ACLs).

---

**Question 17**

**Task:** Configure SSH security on ServerB.

1. **Root Login:** Edit the SSH configuration to permit root login explicitly.
    
2. **Key-Based Auth:** Configure passwordless SSH login for the root user from **ServerA**.
    
    - Generate a key pair on the source.
        
    - Copy the public key to ServerB's root account.
        
3. **Verify:** Ensure you can log in as root without a password.
    

**Aspects/Domains Covered:** Manage security (Configure key-based authentication for SSH).

---

**Question 18**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux status.
    
2. Configure the system to run in **Enforcing** mode.
    
3. Ensure this setting persists after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

---

**Question 19**

**Task:** Perform text processing on **ServerB**.

1. You have a file named `letter` (create it with dummy text containing the word "sam" multiple times).
    
2. Use the `sed` command to replace **every** occurrence of the string "sam" with "Sam".
    
3. Save the result to a new file named `newletter`.
    
4. Ensure the original file `letter` remains unchanged.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create and edit text files, Use grep/regex/sed).

---

**Question 20**

**Task:** Perform command output redirection on **ServerB**.

1. Execute the command `echo "Hello There!"`.
    
2. Overwrite the contents of the file `sample.txt` with this output.
    
3. Ensure that if `sample.txt` existed previously, its old content is completely replaced.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use input-output redirection).

---

**Question 21**

**Task:** Configure a periodic task using **Cron** on **ServerB**.

1. Configure a cron job specifically for the user `root`.
    
2. The job should run **daily at 12:45 AM**.
    
3. The command should find and delete all **empty files** in the `/tmp` directory.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at and cron).

---

**Question 22**

**Task:** Configure default file permissions (Umask) on **ServerB**.

1. Create a user named `harry`.
    
2. Modify `harry`'s user configuration so that **every time he logs in**, his umask is set to `027`.
    
    - This ensures new **files** created by harry have permissions `640` (`rw-r-----`).
        
    - This ensures new **directories** created by harry have permissions `750` (`rwxr-x---`).
        

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).

---

**Question 23**

**Task:** Configure a shared directory with special permissions on **ServerB**.

1. Create a directory `/data/shared`.
    
2. Set permissions so that **everyone** (User, Group, Others) has Read, Write, and Execute access (`777`).
    
3. Set the **Sticky Bit** on this directory to ensure that users can only delete files that _they_ own (preventing users from deleting each other's work).
    

- **Aspects/Domains Covered:** Create and configure file systems (Create and configure set-GID/Sticky directories).

---

**Question 24**

**Task:** Manage shell variables on **ServerB**.

1. Create a variable named EXAM_TYPE with the value RHCSA in your current shell.
    
2. Ensure this variable is **exported**, making it visible to any child processes or subshells started from your current session.
    
3. Store the output of the command date +%F into a variable named TODAY.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, environment variables).

---

**Question 25**

**Task:** Manage process priorities on **ServerB**.

1. Start the command `sleep 1000` in the background.
    
2. Assign it a specific **Nice** level of `15` _when you start it_.
    
3. Verify the nice level of the running process.
    
4. Change the nice level of this running process to `10` (Higher priority/Less nice).
    

- **Aspects/Domains Covered:** Operate running systems (Adjust process scheduling).

---

**Question 26**

**Task:** Create a shell script named /usr/local/bin/user-list.sh on **ServerB**.

1. The script must use a **loop** (for/while) to iterate through the following list of usernames: root, bin, and daemon.
    
2. For each user, the script should print: "Processing user: [username]".
    
3. Ensure the script is executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs).

---

**Question 27**

**Task:** Configure **LVM Thin Provisioning** on **ServerB**.

1. Create a new partition on /dev/sdb (e.g., /dev/sdb3) of size **1GiB** and create a Volume Group named thin_vg on it.
    
2. Create a **Thin Pool** named my_thin_pool with a size of **500MiB** inside thin_vg.
    
3. Create a **Thin Volume** named thin_vol inside this pool. Set its virtual size to **2GiB**.
    
4. Format thin_vol with **xfs** and mount it persistently at /mnt/thin.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - specifically Thin Provisioning).

---

**Question 28**

**Task:** Create a security audit script on **ServerB**.

1. Create a script named `/root/find_suid.sh`.
    
2. The script should search the `/usr/bin` directory.
    
3. It should locate all files owned by **root** that have the **SUID** (Set User ID) permission bit set.
    
4. The script should print the filenames found.
    

- **Aspects/Domains Covered:** Manage security (Manage default file permissions), Create simple shell scripts.

---

**Question 29**

**Task:** Modify the bootloader configuration on **ServerB**.

1. Change the GRUB boot menu timeout to **10 seconds** (the default is often 5).
    
2. Ensure this change applies to the current configuration immediately.
    

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).

---

**Question 30**

**Task:** Troubleshoot a permission issue on ServerB.

- Create a file `/home/secret_data` (owned by `root`).
    
- Set permissions to `000` (No access).
    
- **Scenario:** The user `sam` (who belongs to the group `admins`) needs to **read** this file, but receives "Permission Denied."
    
- **Fix:**
    
    - Change the group owner of the file to `admins`.
        
    - Configure permissions so that the **Group** has **Read-Only (r--)** access.
        
    - Ensure the **Owner (root)** has **Read and Write (rw-)** access.
        
    - Ensure **Others** have no access.
        

**Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission

---

