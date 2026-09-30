# Practice Test Six - Questions Only

> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.

**Question 1**

**Task:** You have forgotten the root password for **ServerC**.

1. Reset the root password to `watchword` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

---

    **Question 2**

**Task:** Configure **ServerC** to use the YUM repositories hosted on **ServerB** via HTTP.

1. Configure a repository for **BaseOS** at `http://ServerB/dvd/BaseOS`.
    
2. Configure a repository for **AppStream** at `http://ServerB/dvd/AppStream`.
    
3. Disable all other existing repositories to ensure packages are pulled only from ServerB.
    
4. Disable GPG checking for these repositories.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

---

**Question 3 (Merged Scenario)**

**Task:** Perform system initialization on **ServerC**.

1. **Hostname:** Set the static hostname to `ServerB` (yes, renaming C to B as per the prompt).
    
2. **Boot Target:** Configure the system to boot into the **Multi-User Target** (CLI) by default.
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Hostname), Operate running systems (Boot targets).

---

**Question 4**

**Task:** On **ServerB** (formerly ServerC), configure the network interface `enp0s3` with the following static settings:

- **Profile Name:** `myprofile6`.
    
- **IPv4:** `192.168.1.7/24`, Gateway: `192.168.1.1`, DNS: `8.8.8.8`.
    
- **IPv6:** `fd01::107/64`, Gateway: `fd01::100`, DNS: `fd01::111`.
    
- **Secondary IPs:** `10.0.0.7/24` (IPv4).
    
- Ensure the connection starts automatically at boot.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

---

**Question 5**

**Task:** Configure kernel networking parameters on **ServerB**.

1. Enable **IPv4** packet forwarding.
    
2. Enable **IPv6** packet forwarding.
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters).

---

  **Question 6**

**Task:** Configure system time settings on **ServerB**.

1. Set the system timezone to **America/Chicago**.
    
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
    
2. Manually assign the **UID** `1234`.
    
3. Configure the account to **expire** on **June 21, 2030** (2030-06-21).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).

---

  **Question 9**

**Task:** Configure permissions and Access Control Lists (ACLs) on ServerB.

- Create a file `/tmp/tmpfile`.
    
- Configure base ownership: Owner **leo**, Group **science**.
    
- **Base Permissions:**
    
    - All users (Owner, Group, Others) should have **Execute** permission.
        
    - No user should have **Write** permission via standard bits (Remove write).
        
- **ACL Configuration:**
    
    - User **james** must have **Read, Write, and Execute** access.
        

**Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems).

---

  **Question 10**

**Task:** Configure **LVM** storage on **ServerB**.

1. Using disk `/dev/sdb`, create a Volume Group named `vg6`. (Create a 4GB partition first if necessary).
    
2. Create a Logical Volume named `lv6` with a size of **2GiB**.
    
3. Format `lv6` with **ext4** and mount it persistently at `/lv6`.
    
4. **Extend** the Logical Volume by **500MiB** and resize the filesystem.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

---

**Question 11**

**Task:** Configure **LVM Thin Provisioning** on **ServerB** using disk `/dev/sdb` (create a partition if needed).

1. Create a Volume Group named `vg1`.
    
2. Create a **Thin Pool** named `thinpool1` with a size of **2GiB**.
    
3. Create a **Thin Volume** named `thinvol1` inside this pool with a **virtual size** of **1TiB**.
    
4. **Manage the Resources:**
    
    - Extend the _Thin Pool_ by **500MiB**.
        
    - Rename the _Thin Pool_ to `thinpool2`.
        
    - Rename the _Thin Volume_ to `thinvol2`.
        
5. Format `thinvol2` with **xfs** and mount it persistently at `/thinvol2`.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - Thin Provisioning).

---

**Question 12**

**Task:** Optimize **ServerB** for a virtualized environment.

1. Install and enable `tuned`.
    
2. Apply a profile configuration that optimizes for **Virtual Guests** while also prioritizing **low power consumption**. (Combine `virtual-guest` and `powersave`).
    
3. Verify that both profiles are active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

---

  **Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server.
    
2. Create an `index.html` file in the default document root containing the text: "Hello World!".
    
3. Configure the firewall to allow **HTTP** and **HTTPS**.
    
4. Ensure the service starts on boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Start services), Manage security (Firewall).

---

  **Question 14**

**Task:** Perform a file search and backup operation on **ServerB**.

1. Create a directory `/find/rootfiles`.
    
2. Find all **regular files** in the `/usr` directory that are owned by the user **root**.
    
3. Copy these files to `/find/rootfiles`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create/copy files, Use find).

---

  **Question 15 (New Topic: Flatpak)**

**Task:** Manage desktop applications on ServerB using Flatpak.

- Configure the **Flathub** remote repository: `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
- Install the application **Calculator** (`org.gnome.Calculator`) from this remote.
    
- Verify the installation.
    

**Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

---

**Question 16**

**Task:** Create a shell script named `/sum.sh` in the root directory of ServerB.

- The script should accept an unspecified number of integer arguments (e.g., `./sum.sh 5 10 -3 20`).
    
- It should calculate the sum of all arguments that are **greater than 0**. (Ignore negative numbers or zero).
    
- Print the result in the format: "The sum is [total]".
    
- Make the script executable.
    

**Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, Loops, Conditional logic).

---

  **Question 17**

**Task:** Configure a collaborative directory environment on **ServerB**.

1. **Groups:** Create groups `Innovation` and `Solution`.
    
2. **Users:**
    
    - Create `James` and `Ethan` (add to `Innovation`).
        
    - Create `Lucas` and `Oliver` (add to `Solution`).
        
3. **Directories:** Create `/groups/Innovation` and `/groups/Solution`.
    
4. **Ownership:** Set group ownership of the directories to their respective groups.
    
5. **Permissions:**
    
    - Group members should have **Full Access** (RWX).
        
    - Others should have **No Access**.
        
    - Enable **SGID** so new files automatically inherit the group owner.
        
6. **Cross-Access:** Configure an **ACL** so that members of the `Solution` group can **Read and Execute** files in the `/groups/Innovation` directory.
    

- **Aspects/Domains Covered:** Manage users and groups, Create and configure file systems (SGID, ACLs).

---

  **Question 18**

**Task:** Configure LVM with a custom Physical Extent size on **ServerB**.

1. Using disk `/dev/sdb` (create a partition `sdb2` if needed), create a Volume Group named `myvg`.
    
2. Configure `myvg` to use a **Physical Extent (PE) size of 16MiB**.
    
3. Create a Logical Volume named `mylv` inside this group.
    
4. The LV must contain exactly **50 Extents**.
    
5. Format with **xfs** and mount persistently at `/mnt/mylv`.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Assign physical volumes to volume groups).

---

**Question 19 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, replace a legacy Cron job with a **Systemd Timer**.

1. Create a script `/usr/local/bin/cleanup.sh` that deletes all **empty files** (not directories) in `/tmp`. Make it executable.
    
2. Create a service unit named `cleanup.service`.
    
3. Create a timer unit named `cleanup.timer` that runs this service **daily at 16:15** (4:15 PM).
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).

---

**Question 20**

**Task:** Perform file archiving on **ServerB**.

1. Create a directory `/Backup`.
    
2. Create a **gzip** compressed tar archive named `/Backup/myhome.tgz`.
    
3. The archive should contain the contents of `/home`.
    
4. **Exclude** all files with the extension `.pdf` from the archive.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files).

---

  **Question 21**

**Task:** Configure local storage on **ServerB** using standard partitions (not LVM).

1. Create a **2GiB** partition on `/dev/sdb`.
    
2. Format the partition with the **ext4** file system.
    
3. Configure the system to mount this partition automatically at boot under `/mnt/drive`.
    
4. Use the **UUID** to ensure the mount configuration is persistent.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Configure systems to mount file systems).

---

**Question 22**

**Task:** Add swap space to ServerB.

- Create a new partition of **1GiB** on `/dev/sdb`.
    
- Format the partition as swap.
    
- Activate the swap space immediately.
    
- Ensure it persists across reboots using the **UUID**.
    

**Aspects/Domains Covered:** Configure local storage (Add swap to a system non-destructively).

---

**Question 23**

**Task:** Configure Secure SSH Access on **ServerB**.

1. **User:** Create a user named `john`.
    
2. **Key Setup:** Configure passwordless SSH login for `john` from **ServerA** (or localhost). Generate the key pair and copy it appropriately.
    
3. **Hardening:** Configure the SSH daemon to **disable** `PasswordAuthentication`. (Ensure you have key access first so you don't lock yourself out!).
    
4. **Restart:** Apply the configuration.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure SSH).

---

**Question 24**

**Task:** Configure system identity and name resolution on **ServerB**.

1. Set the hostname to `rhel.server.com` persistently.
    
2. Update `/etc/hosts` to ensure that `rhel.server.com` resolves to:
    
    - The loopback address `127.0.0.1`.
        
    - The network address `192.168.1.6`.
        

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).

---

  **Question 25**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux mode.
    
2. Set the system to **Enforcing** mode.
    
3. Ensure the system remains in Enforcing mode after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

---

**Question 26**

**Task:** Configure **VDO** (Virtual Data Optimizer) for efficient storage on ServerB.

- Using disk `/dev/sde` (create a partition if needed), create a Volume Group named `vdovg`.
    
- Create a **VDO Logical Volume** named `myvdo` inside this group.
    
- Set the **Physical Size** (space taken on disk) to **5GiB**.
    
- Set the **Logical/Virtual Size** (space presented to user) to **50GiB**.
    
- Format with **xfs** and mount persistently at `/vdo`.
    
- Ensure the mount configuration is correct and efficient.
    

**Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - VDO/Thin Provisioning).

---

**Question 27**

**Task:** Configure Firewall Rich Rules on **ServerB**.

1. Allow **SSH** traffic from the trusted network `192.168.1.0/24`.
    
2. **Reject** SSH traffic from all other sources.
    
3. Ensure the configuration is permanent.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewalld).

---

  **Question 28**

**Task:** Configure global user environment settings on **ServerB**.

1. **Variable:** Create a system-wide environment variable named `VAR` with the value `RHCSA`. Ensure it is accessible to all users.
    
2. **History:** Configure the system so that the Bash history file size (`HISTFILESIZE`) is set to **2000** lines for all users.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Environment variables), Operate running systems.

---

  **Question 29**

**Task:** Configure an FTP server with SELinux integration on ServerB.

- Install and start the **vsftpd** service.
    
- Configure the firewall to allow **FTP** traffic.
    
- **SELinux:** Configure the boolean `ftpd_full_access` to allow the FTP daemon to read/write files.
    
- Ensure the boolean setting persists across reboots.
    

**Aspects/Domains Covered:** Manage security (Use boolean settings to modify system SELinux settings, Configure firewall settings), Deploy, configure, and maintain systems (Start services).

---

  **Question 30**

**Task:** Manage the Kernel and Bootloader on **ServerB**.

1. **List:** Identify the index numbers of all installed kernels.
    
2. **Set Default:** Set the default boot kernel to the entry at **Index 1** (the previous kernel).
    
3. **Modify Args:** Remove the `quiet` argument from the kernel boot parameters for **all** installed kernels.
    

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).

---

