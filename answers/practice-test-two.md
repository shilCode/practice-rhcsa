**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `secret` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).


```
Overall explanation

**Correct Answer**

**1. Boot into Single-User Mode**

**Reboot and Access GRUB:**

- Reboot the system.
    
- If the GRUB menu does not appear automatically, press **Esc** to display it.
    
- Highlight the default kernel and press **e** to edit the boot entry.
    

**Navigate to the Kernel Line:**

- Locate the line beginning with **linux**.
    
- Press **Ctrl + E** to jump to the end of that line.
    

**Modify Boot Parameters:**

- Append:
    
    1. init=/bin/bash
    
- Replace **ro** with **rw** to allow write access.
    
- (Optional) Remove parameters such as `console=` or `vconsole.keymap=` if they interfere with output.
    

**2. Boot into the Emergency Shell**

- Press **Ctrl + X** to boot using the modified parameters.  
    You will be dropped directly into a root shell.
    

**3. Reset the Root Password**

- Run:
    
    1. passwd root
    
    Set a secure password when prompted.
    

**4. Trigger SELinux Relabeling**

- 1. touch /.autorelabel
    

**5. Reboot the System**

- 1. exec /sbin/init
    
    Allow several minutes for SELinux to complete relabeling.
    

**Explanation**

**Key Technical Points**

- **Writable Root Filesystem:**  
    Replacing **ro** with **rw** ensures `/etc/shadow` can be updated.
    

- **Using** `**passwd**` **in Single-User Mode:**  
    Modifies the root password directly in the system’s real password database.
    

- **SELinux Relabeling:**  
    Ensures correct security contexts and prevents login failures after offline password changes.
    

**Best Practices**

- Always use a strong root password.
    
- Restrict GRUB access in production environments.
    
- Perform emergency password resets only when necessary.
    

**Additional Notes for Learners**

- **Why** `**init=/bin/bash**`**?**  
    Bypasses the normal boot sequence and opens a minimal root shell before authentication and services start.
    

- **Why** `**mount -o remount,rw**`**?**  
    The disk defaults to read-only in emergency conditions; write access is required to update system files.
    

- **Why** `**chroot /sysroot**` **in alternative methods?**  
    Ensures commands apply to the installed system rather than the temporary rescue environment.
    

- **Why** `**/.autorelabel**`**?**  
    Ensures the system boot remains consistent with SELinux policies after offline modifications.
```



**Question 2**

**Task:** Configure a software repository on **ServerB**.

1. Mount the provided ISO image `/RHEL-10.iso` to the directory `/repo`.
    
2. Configure a DNF repository to install packages from the **BaseOS** and **AppStream** directories within that mount point.
    
3. Ensure the configuration persists after a reboot (i.e., the ISO is mounted automatically).
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Configure systems to mount file systems at boot).
    

  

**Instructor Note: Setting Up /RHEL10.iso**

- In this home lab environment, the `/RHEL10.iso` file is not provided automatically. Before completing this task, download the RHEL 10 ISO from the Red Hat Developer Portal and place it in the root directory (`/`) as `/RHEL10.iso`.
    
- In the actual RHCSA exam, any required files or repositories will be provided by Red Hat.

```
Overall explanation

**Correct Answer:**

1. **Create Mount Point:**
    
    1. mkdir -p /repo
    
2. **Configure Persistence (**`**/etc/fstab**`**):**
    
    - Add the following line to `/etc/fstab`:
        
        1. /RHEL-10.iso  /repo  iso9660  loop,defaults  0 0
        
    - Mount it immediately:
        
        1. mount -a
        
3. **Configure Repo File:**
    
    - Create `/etc/yum.repos.d/local.repo`:
        
        1. [BaseOS]
        2. name=BaseOS
        3. baseurl=file:///repo/BaseOS
        4. enabled=1
        5. gpgcheck=0
        
        6. [AppStream]
        7. name=AppStream
        8. baseurl=file:///repo/AppStream
        9. enabled=1
        10. gpgcheck=0
        

**Detailed Explanation:**

- **Fstab for ISOs:** To make an ISO mount persistent, you use the `iso9660` filesystem type and the `loop` option. This tells the kernel to treat the file as a block device.
    
- **Check:** Run `dnf repolist` to verify RHEL sees the packages.
```


**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings.

- **IPv4:** 192.168.1.3/24, Gateway: 192.168.1.1, DNS: 8.8.8.8.
    
- **Secondary IPv4:** 10.0.0.3/24.
    
- **IPv6:** fd01::103/64, Gateway: fd01::1.
    
- **Secondary IPv6:** fd01::200/64.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

```
Overall explanation

**Correct Answer**

1. Identify the Connection Name

2. nmcli con show

Assume the connection is named `**enp0s3**` or `**Wired connection 1**`.

2. Apply Primary Settings

3. nmcli con mod "enp0s3" \
4. ipv4.method manual ipv4.addresses 192.168.1.3/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 \
5. ipv6.method manual ipv6.addresses fd01::103/64 ipv6.gateway fd01::1

6. Add Secondary IP Addresses

7. nmcli con mod "enp0s3" +ipv4.addresses 10.0.0.3/24

8. nmcli con mod "enp0s3" +ipv6.addresses fd01::200/64

9. Activate the Connection

10. nmcli con up "enp0s3"

**Detailed Explanation**

- **Merging Tasks**  
    This covers the requirements of old **Q3**, **Q4**, and **Q5**.
    
- **Syntax**  
    `ipv4.method manual` turns off DHCP.
    
- **The** `**+**` **Sign**  
    Using `+ipv4.addresses` appends the IP. If you omit the `+`, it overwrites the IP you set in step 2.
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. For networking, that means:
    
    1. nmcli con show --active
    
    2. ip addr show
    
    plus:
    
    3. nmcli con show "enp0s3" | grep autoconnect
    
    returning:
    
    4. yes
    
    — a profile that does not autoconnect is gone after the reboot.
```

**Question 4**

**Task:** Configure system time and synchronization on **ServerB**.

1. Set the system timezone to **Europe/London**.
    
2. Install and enable **Chrony** (NTP) to synchronize time.
    
3. Verify that the system is synchronized ("NTP synchronized: yes").
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).

```
Overall explanation

**Correct Answer:**

1. **Set Timezone:**
    
    1. timedatectl set-timezone Europe/London
    
2. **Install/Enable Chrony:**
    
    1. dnf install chrony -y
    2. systemctl enable --now chronyd
    
3. **Enable NTP Sync (if needed):**
    
    1. timedatectl set-ntp true
    
4. **Verify:**
    
    1. timedatectl
    

**Detailed Explanation:**

- `**timedatectl**`**:** The primary tool for time management. Changing the timezone creates a symlink from `/etc/localtime` to the correct file in `/usr/share/zoneinfo/`.
    
- `**chronyd**`**:** The background service that actually talks to internet time servers.
```



**Question 5**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters / Tune systems).


```
Overall explanation

**Correct Answer:**

1. **Create/Edit Config File:**
    
    - Create a file in `/etc/sysctl.d/` (Best Practice):
        
        1. vim /etc/sysctl.d/99-forwarding.conf
        
2. **Add Parameters:**
    
    1. net.ipv4.ip_forward = 1
    2. net.ipv6.conf.all.forwarding = 1
    
3. **Apply Immediately:**
    
    1. sysctl -p /etc/sysctl.d/99-forwarding.conf
    2. # OR simply: sysctl --system
    

**Detailed Explanation:**

- **Sysctl:** This tool modifies the kernel parameters stored in RAM (at `/proc/sys/`).
    
- **Persistence:** Editing `/proc/sys` directly is temporary. You must write to `/etc/sysctl.d/` (or `/etc/sysctl.conf`) for changes to survive a reboot.
    
- **Use Case:** Packet forwarding is required if you want your RHEL server to act as a router or a gateway for other computers or containers.
```


**Question 6**

**Task:** Configure **ServerB** so that boot messages are visible during startup (disable the quiet, graphical boot).

1. Remove the `rhgb` and `quiet` parameters from the current kernel's boot options.
    
2. Ensure this change is persistent and applies to the default kernel.
    

- **Aspects/Domains Covered:** Operate running systems (Boot, reboot, and shut down a system normally).

```
Overall explanation

**Correct Answer:**

1. **Update Kernel Arguments:**
    
    1. grubby --update-kernel=ALL --remove-args="rhgb quiet"
    
2. **Verify:**
    
    1. grubby --info=DEFAULT
    2. # Look for the 'args=' line to ensure 'rhgb' and 'quiet' are gone.
    

**Detailed Explanation:**

- `**grubby**`**:** This is the preferred tool in RHEL 9 and 10 for managing the bootloader. It is safer than editing text files because it handles the complex syntax of GRUB automatically.
    
- `**--update-kernel=ALL**`**:** Applies the change to all installed kernels, ensuring that even if you boot into an older kernel for troubleshooting, you still see the logs.
    
- **Why do this?** Hiding boot messages (the "quiet" flag) looks nice, but if a service fails to start, a SysAdmin needs to see the text output on the screen to diagnose the freeze.
    

**Note on Command Scope:** The question asks to apply changes to the _default_ kernel. While `grubby --update-kernel=DEFAULT` is the precise answer to that specific requirement, we recommend using `--update-kernel=ALL`. This is a safer strategy for the exam because it ensures your configuration persists even if the system boots into a fallback kernel during grading. Both commands are valid.
```

**Question 7**

**Task:** Configure local storage on **ServerB** using the disk /dev/sdb.

1. Create a **4GiB** partition on /dev/sdb and initialize it as a physical volume.
    
2. Create a volume group named vgmyvg.
    
3. Create a logical volume named lvmylv with a size of **1GiB**.
    
4. Format the logical volume with **ext4** and mount it persistently at /lvmylv.
    
5. **Extend** the logical volume by **500MiB** and resize the filesystem to match.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

```
Overall explanation

**Correct Answer**

1. Create the Partition

2. fdisk /dev/sdb

`n` (new), default, default, `+4G`, `w`.

1. pvcreate /dev/sdb1

2. Create the Volume Group

3. vgcreate vgmyvg /dev/sdb1

4. Create the Logical Volume

5. lvcreate -n lvmylv -L 1G vgmyvg

6. Format and Mount

7. mkfs.ext4 /dev/vgmyvg/lvmylv
8. mkdir /lvmylv
9. echo "/dev/vgmyvg/lvmylv /lvmylv ext4 defaults 0 0" >> /etc/fstab
10. mount -a

11. Extend the Logical Volume

12. lvextend -r -L +500M /dev/vgmyvg/lvmylv

**Detailed Explanation**

- `**fdisk**` **vs** `**pvcreate**`  
    First you slice the physical disk (Partition). Then you mark that slice as **LVM ready** (Physical Volume).
    
- **The Stack**  
    PVs go into a VG (Pool). LVs are carved out of that Pool.
    
- `**lvextend -r**`  
    The `-r` flag is critical for efficiency. It runs `resize2fs` (for ext4) or `xfs_growfs` (for XFS) automatically after extending the volume, ensuring the file system actually uses the new space.
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. For storage, run:
    
    1. mount -a
    
    before you reboot — a bad `/etc/fstab` entry drops the system into emergency mode. Then confirm with:
    
    2. lsblk
    
    3. df -h /lvmylv
    
    4. lvs
```

**Question 8**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP server (httpd).
    
2. Create a file at /var/www/html/index.html containing the text "Hello World!".
    
3. Ensure the web server starts automatically at boot.
    
4. Configure the Firewall to allow traffic on both **HTTP** and **HTTPS**.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install and update software packages), Manage security (Configure firewall settings).
```Overall explanation

**Correct Answer**

1. Install

2. dnf install httpd -y

3. Configure Content

4. echo "Hello World!" > /var/www/html/index.html

5. Start and Enable

6. systemctl enable --now httpd

7. Configure the Firewall

8. firewall-cmd --permanent --add-service=http
9. firewall-cmd --permanent --add-service=https
10. firewall-cmd --reload

11. Verify

12. curl http://localhost

**Detailed Explanation**

- `**systemctl enable --now**`  
    This command sets the symlink for auto-start and starts the service process immediately.
    
- **Firewall Zones**  
    By default, `firewall-cmd` modifies the **public** zone. Adding `http` and `https` opens ports **80** and **443** respectively.
    
- **Testing**  
    Using `curl localhost` is the quickest way to verify the server is running and serving your file without needing a GUI browser.
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. For services:
    
    1. systemctl is-active httpd
    
    and
    
    2. systemctl is-enabled httpd
    
    must both succeed, and:
    
    3. firewall-cmd --list-all --permanent
    
    must match the runtime output — if the two differ you missed `--permanent` or the `--reload`.
```


**Question 9**

**Task:** Create a shell script named `/usr/local/bin/yes-no.sh` on **ServerB**.

1. The script should accept one argument.
    
2. If the argument is **yes** (case-insensitive), output "That is nice".
    
3. If the argument is **no** (case-insensitive), output "I am sorry".
    
4. If the argument is anything else, output "Unknown argument".
    
5. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Conditionally execute code).

```
Overall explanation

**Correct Answer:**

1. **Create Script:**
    
    1. vim /usr/local/bin/yes-no.sh
    
2. **Add Content:**
    
    1. #!/bin/bash
    2. # Convert input to lowercase to handle Yes/YES/yes
    3. INPUT=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    4. case "$INPUT" in
    5.     yes)
    6.         echo "That is nice"
    7.         ;;
    8.     no)
    9.         echo "I am sorry"
    10.         ;;
    11.     *)
    12.         echo "Unknown argument"
    13.         ;;
    14. esac
    
3. **Make Executable:**
    
    1. chmod +x /usr/local/bin/yes-no.sh
    

**Detailed Explanation:**

- `**tr '[:upper:]' '[:lower:]'**`**:** This translates all uppercase letters to lowercase. This ensures that if the user types "YES", the script converts it to "yes" so it matches the case statement.
    
- `**case**` **Statement:** This is cleaner than writing multiple `if...elif...else` statements when checking a single variable against multiple possible values.
    
- `***)**`**:** This is the "catch-all" or default option in a case statement, similar to `else`.
```


**Question 10**

**Task:** Update the kernel on **ServerB**.

1. Install the latest kernel update available in the repositories.
    
2. Ensure this new kernel is set as the **default** boot option.
    
3. Reboot the system to verify the new kernel is loaded.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install and update software packages, Modify the system bootloader).
```
Overall explanation

**Correct Answer:**

1. **Update Kernel:**
    
    1. dnf update kernel -y
    
2. **Verify Default (Optional but recommended):**
    
    1. grubby --default-kernel
    2. # It should match the version you just installed.
    
3. **Reboot:**
    
    1. reboot
    
4. **Verify Runtime:**
    
    1. uname -r
    2. # Ensure this matches the new version.
    

**Detailed Explanation:**

- **RHEL Behavior:** By default, when you install a new kernel RPM in RHEL/CentOS, the system scripts automatically update the GRUB configuration to make that new kernel the default. You usually do _not_ need to manually edit config files.
    
- **Safety:** The old kernel is preserved. If the new kernel fails to boot, you can select the old one from the startup menu.
    
- `**uname -r**`**:** This command prints the **R**elease of the kernel currently running in memory.
```

**Question 11**

**Task:** Configure the hostname of **ServerB**.

1. Set the static hostname to `rhel.server.com`.
    
2. Ensure this change is persistent across reboots.
    
3. Verify the change.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).
```
Overall explanation

**Correct Answer:**

1. **Set Hostname:**
    
    1. hostnamectl set-hostname rhel.server.com
    
2. **Verify:**
    
    1. hostnamectl
    2. # OR
    3. cat /etc/hostname
    

**Detailed Explanation for Learners:**

- `**hostnamectl**`**:** This is the standard command for RHEL 7/8/9/10. It communicates with the systemd-hostnamed service.
    
- **Persistence:** Unlike the old `hostname` command (which only changed the name in memory until the next reboot), `hostnamectl` automatically updates the `/etc/hostname` file, making the change permanent.

```

**Question 12**

**Task:** Perform a file search and backup on **ServerB**.

1. Create a directory named `/find/rootfiles`.
    
2. Locate all **regular files** in `/usr/bin` that are owned by the user `root`.
    
3. Copy these files into `/find/rootfiles`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use grep/find).

```
Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /find/rootfiles
    
2. **Find and Copy:**
    
    1. find /usr/bin -type f -user root -exec cp {} /find/rootfiles/ \;
    

**Detailed Explanation for Learners:**

- `**-type f**`**:** This tells `find` to look only for regular **f**iles, ignoring directories or symlinks.
    
- `**-user root**`**:** Filters the list to show only files owned by root.
    
- `**-exec ... \;**`**:** Runs a command on every result found.
    
- `**{}**`**:** This is the "placeholder." If `find` discovers `/usr/bin/ls`, it replaces `{}` with `/usr/bin/ls`, effectively running `cp /usr/bin/ls /find/rootfiles/`.
```

**Question 13**

**Task:** Configure global user policies on **ServerB**.

1. **Skeleton:** Ensure that a file named `Note` is automatically created in the home directory of any **new** user created on the system.
    
2. **Expiration:** Configure the system so that user passwords expire every **100 days**.
    
3. **Complexity:** Enforce a policy that passwords must be at least **9 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging).
```
Overall explanation

**Correct Answer:**

1. **Skeleton File:**
    
    1. touch /etc/skel/Note
    
2. **Password Aging (Max Days):**
    
    - Edit `/etc/login.defs`:
        
        1. vim /etc/login.defs
        
    - Set:
        
        1. PASS_MAX_DAYS 100
        
3. **Password Length:**
    
    - Edit `/etc/security/pwquality.conf`:
        
        1. vim /etc/security/pwquality.conf
        
    - Set (uncomment if needed):
        
        1. minlen = 9
        

**Detailed Explanation for Learners:**

- `**/etc/skel**`**:** This directory is copied recursively to the new user's home (`/home/username`) when you run `useradd`. It's the standard way to deploy "Welcome" files or default configs (`.bashrc`).
    
- `**libpwquality**`**:** RHEL uses this library to check password strength. If a user tries to set a short password ("12345"), the system checks `minlen` in `pwquality.conf` and rejects it.
```

**Question 14**

**Task:** Create a restricted user on **ServerB**.

1. Create a user named `sam`.
    
2. Manually assign the **UID** `1500`.
    
3. Configure the account so `sam` **cannot** access an interactive shell (prevent login).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).

```
Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd -u 1500 -s /sbin/nologin sam
    
2. **Verify:**
    
    1. id sam
    2. # Should show uid=1500(sam)
    3. grep sam /etc/passwd
    4. # Should end with :/sbin/nologin
    

**Detailed Explanation for Learners:**

- `**-u 1500**`**:** Sometimes you need a specific User ID (UID) to match a user on another server (e.g., for NFS file sharing).
    
- `**-s /sbin/nologin**`**:** This is a "fake" shell. If `sam` tries to SSH into the server, the system runs this program. It simply prints "This account is currently not available" and immediately kicks them out. This is commonly used for service accounts (like `apache` or `mysql`) that need to exist but shouldn't log in.
```

**Question 15**

**Task:** Configure **Access Control Lists (ACLs)** on **ServerB**.

1. Copy the file `/etc/fstab` to `/var/tmp/fstab`.
    
2. Modify the file's ownership: User `root`, Group `root`.
    
3. Remove all execute permissions from the file.
    
4. Configure **ACLs** so that:
    
    - User `stewart` has **Read/Write** access.
        
    - User `kevin` has **No** access (neither read, write, nor execute).
        

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - utilizing ACLs).

```
Overall explanation

**Correct Answer:**

1. **Prepare File:**
    
    1. cp /etc/fstab /var/tmp/fstab
    2. chown root:root /var/tmp/fstab
    3. chmod a-x /var/tmp/fstab
    
2. **Set ACL for Stewart:**
    
    1. setfacl -m u:stewart:rw /var/tmp/fstab
    
3. **Set ACL for Kevin:**
    
    1. setfacl -m u:kevin:--- /var/tmp/fstab
    
4. **Verify:**
    
    1. getfacl /var/tmp/fstab
    

**Detailed Explanation for Learners:**

- **Standard vs. ACL:** Standard permissions (`chmod`) apply to Owner, Group, and Others. If you need to treat `stewart` differently from `kevin` (and neither is the owner), standard permissions fail. ACLs solve this.
    
- `**setfacl -m**`**:** **M**odifies the ACL.
    
- `**u:kevin:---**`**:** Explicitly denies everything to Kevin. Even if "Others" have read access, this specific rule targets Kevin and blocks him.
```

**Question 16 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, configure a scheduled task using **Systemd Timer Units** (do not use Cron).

1. Create a script /usr/local/bin/clean-tmp.sh that deletes all **empty files** in the /tmp directory. Make it executable.
    
2. Create a Service Unit (clean-tmp.service) to execute this script.
    
3. Create a Timer Unit (clean-tmp.timer) that runs the service **once every day** (e.g., at midnight).
    
4. Enable and start the timer.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).


```
Overall explanation

**Correct Answer**

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/clean-tmp.sh
3. echo 'find /tmp -type f -empty -delete' >> /usr/local/bin/clean-tmp.sh
4. chmod +x /usr/local/bin/clean-tmp.sh

5. Create the Service Unit

Create the file:

1. /etc/systemd/system/clean-tmp.service

2. [Unit]
3. Description=Clean Empty Tmp Files

4. [Service]
5. Type=oneshot
6. ExecStart=/usr/local/bin/clean-tmp.sh

7. Create the Timer Unit

Create the file:

1. /etc/systemd/system/clean-tmp.timer

2. [Unit]
3. Description=Run Clean Tmp Daily

4. [Timer]
5. OnCalendar=daily
6. Persistent=true
7. Unit=clean-tmp.service

8. [Install]
9. WantedBy=timers.target

10. Activate

11. systemctl daemon-reload
12. systemctl enable --now clean-tmp.timer

**Detailed Explanation**

- `**OnCalendar=daily**`  
    This is the systemd equivalent of `@daily` or `0 0 * * *` in cron.
    
- `**Persistent=true**`  
    This is a cool feature of systemd timers. If the server is turned off at midnight (when the job should have run), it will run the job immediately when the server boots up next. Cron cannot do this by default.
    
- **The Logic**  
    The timer wakes up at midnight, triggers the `.service` file, which runs the `.sh` script, which executes the `find` command.
    
- **Timer and Service Units Are a Pair**  
    The timer carries only the schedule; the work lives in `clean-tmp.service`. That is why this answer creates two unit files — a timer with no service has nothing to activate, and a service with no timer never runs on a schedule.
    
- `**Unit=**`  
    systemd pairs a timer with the service of the same base name automatically, so `Unit=clean-tmp.service` states explicitly what would already happen. It becomes mandatory the moment the two names differ — without it the timer elapses exactly on schedule and activates nothing, which is a silent failure.
    
- `**Persistent=true**` **in Practice**  
    It applies only to calendar timers, and systemd records the last elapse under `/var/lib/systemd/timers/`. On a lab virtual machine that is shut down overnight, this is what makes a daily job actually run; without it a missed run is simply skipped.
    
- **Why** `**daemon-reload**` **Is Required**  
    systemd keeps unit files cached in memory. Until you reload, a newly created unit does not exist as far as systemd is concerned, and an edited one still runs its previous version. Run `systemctl daemon-reload` after every change under `/etc/systemd/system/`.
    
- **Enable the Timer, Not the Service**  
    `systemctl enable --now clean-tmp.timer` is what brings the schedule back after a reboot. Enabling `clean-tmp.service` instead would run the script once at boot and never again.
    
- **Verifying the Timer**
    
    1. systemctl list-timers
    
    2. systemctl status clean-tmp.timer
    
    3. journalctl -u clean-tmp.service
    
    `list-timers` proves a schedule exists and shows the next and last elapse; `status` confirms the unit is loaded, active, and enabled; `journalctl -u` is the only one of the three that proves the script actually ran.
    
    To test without waiting for midnight, trigger the service once by hand with:
    
    4. systemctl start clean-tmp.service
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. Confirm:
    
    1. systemctl is-enabled clean-tmp.timer
    
    returns `enabled`, then reboot and check that:
    
    2. systemctl list-timers
    
    still shows a future run.
```

**Question 17**

**Task:** Perform archival and restoration on **ServerB**.

1. Create a **bzip2** compressed archive of the `/etc` directory.
    
2. Save the archive as `/archive/myetc.tbz2`. (Create the directory if needed).
    
3. **Restore** the contents of this archive into the directory `/restored/myetc/`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack, and uncompress files using tar, bzip2).
```
Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /archive /restored/myetc
    
2. **Create Archive:**
    
    1. tar -cjf /archive/myetc.tbz2 /etc
    
3. **Restore:**
    
    1. tar -xjf /archive/myetc.tbz2 -C /restored/myetc/
    

**Detailed Explanation:**

- `**-j**`**:** This flag selects **bzip2** compression (high compression, slower speed). Common extensions are `.tar.bz2` or `.tbz2`.
    
- `**-C**` **(Directory Change):** By default, `tar` extracts files into your _current_ folder. The `-C` flag tells tar to change into the target directory (`/restored/myetc/`) before unpacking.
```


**Question 18**

**Task:** Optimize **ServerB** for a specific workload.

1. Install and start the `tuned` service.
    
2. Set the active profile to **powersave** (prioritizing low power consumption over performance).
    
3. Verify the active profile.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

```
Overall explanation

**Correct Answer:**

1. **Install:**
    
    1. dnf install tuned -y
    2. systemctl enable --now tuned
    
2. **Set Profile:**
    
    1. tuned-adm profile powersave
    
3. **Verify:**
    
    1. tuned-adm active
    

**Detailed Explanation:**

- **Tuned:** This daemon applies a massive list of kernel tweaks (CPU governor, disk spin-down times, network latency settings) with a single command.
    
- `**powersave**`**:** This profile tells the CPU to run at lower frequencies when idle and allows devices (like Wi-Fi cards or audio) to sleep more aggressively to save electricity.
```

**Question 19**

**Task:** Secure SSH access on ServerB.

1. Create a user alice on **ServerB**.
    
2. Generate SSH keys on **ServerA** (Client) and copy them to alice on **ServerB**.
    
3. Configure **ServerB** to allow alice to log in via SSH using keys without a password.
    
4. Edit the SSH configuration on **ServerB** to disable root login via SSH completely.
    
5. Edit the SSH configuration on **ServerB** to disable password authentication for all users.
    

**Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure firewall/SSH settings).

```
Overall explanation

**Correct Answer**

1. Create the User & Set a Password (On ServerB)

2. useradd alice
3. passwd alice

Set a temporary password (e.g., `password`) so `ssh-copy-id` can install the key later.

2. Set Up SSH Keys (On ServerA / Client)

3. ssh-keygen -t rsa

Press **Enter** for the defaults.

1. ssh-copy-id alice@serverb

You will be prompted for **alice**'s password once to install the key.

**Optional:** Verify access with:

1. ssh alice@serverb

You should log in without a password.

3. Edit the SSH Configuration (On ServerB)

Edit the file:

1. vim /etc/ssh/sshd_config

Modify or add the following lines:

1. PermitRootLogin no
2. PasswordAuthentication no

3. Apply the Changes (On ServerB)

4. systemctl restart sshd

**Detailed Explanation for Learners**

- **Username Change**  
    We use **alice** here because the user **sam** (created in Question 14) was configured with `/sbin/nologin`, which would prevent the SSH key copy process.
    
- **Why** `**passwd**`**?**  
    Although the goal is passwordless login, `ssh-copy-id` requires a password to connect initially and install the public key.
    
- **Client-Server Workflow**  
    Keys are always generated on the **Client** (source machine, like ServerA) and copied to the **Server** (destination, ServerB).
    
- **Hardening**  
    Disabling `PermitRootLogin` forces administrators to log in as a regular user and then escalate privileges using `sudo` or `su`. This creates a better audit trail.
    
- **Keys Only**  
    Disabling `PasswordAuthentication` drastically reduces the attack surface, as attackers cannot attempt brute-force password guessing.
    
    **Warning:** Ensure your key-based access works before disabling passwords and restarting the service, otherwise you may lock yourself out!
    
- **Why Key-Based Authentication Is Preferred**  
    The private key never crosses the network, so there is nothing for an eavesdropper to capture and nothing for an attacker to brute-force. Access is granted and revoked per key by editing one line in the user's `~/.ssh/authorized_keys`, and a stolen password on another system no longer opens this one. Password logins are the most attacked entry point on any reachable host, which is why RHCSA 10 pairs key setup with `PasswordAuthentication no`.
    
- **Choosing a Key Type**  
    `ssh-keygen -t ed25519` is the modern default — short keys, fast verification, and no key-size decision to get wrong. `ssh-keygen -t rsa`, used in the answer above, remains correct and is the safer choice when you must interoperate with older clients; if you use RSA, ask for at least **3072 bits** with:
    
    1. ssh-keygen -t rsa -b 3072
    
    Either type satisfies this task.
    
- **Verifying the Connection**
    
    1. ssh -v alice@serverb
    
    Read the verbose output for **Offering public key** followed by **Authentication succeeded (publickey)**. If you instead see **Authentications that can continue: password**, the server never accepted your key — fix that before disabling password logins.
    
- **Confirming the Server Configuration**  
    Three directives decide whether this task passes:
    
    1. PubkeyAuthentication yes
    2. PasswordAuthentication no
    3. PermitRootLogin no
    
    `PubkeyAuthentication yes` is the built-in default and need not appear in the file, but check it anyway — a drop-in under `/etc/ssh/sshd_config.d/` can override it.
    
    4. sshd -T | grep -Ei "pubkey|password|permitroot"
    
    prints the effective values after every include has been merged, which is more reliable than reading `sshd_config` on its own.
    
- **Common Mistakes That Block Key Authentication**
    
    - Wrong permissions — `~/.ssh` must be `700` and `~/.ssh/authorized_keys` must be `600`, both owned by the user.
        
    - A hand-made or copied `~/.ssh` that never got its SELinux label, fixed with:
        
        1. restorecon -Rv /home/alice/.ssh
        
    - Editing `sshd_config` without:
        
        1. systemctl restart sshd
        
    - Disabling password authentication before the key works, which locks you out.
        
    - Copying the private key instead of the `.pub` file.
        
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. Keep your current session open, test:
    
    1. ssh alice@serverb
    
    from a second terminal, confirm:
    
    2. systemctl is-enabled sshd
    
    then reboot and test again.
```

**Question 20**

**Task:** Add swap space to **ServerB**.

1. Create a partition of **500MiB** on /dev/sdb.
    
2. Format it as swap and activate it.
    
3. Ensure it persists after reboot using the **UUID**.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Add swap non-destructively).

```
Overall explanation

**Correct Answer**

1. Create the Partition

2. fdisk /dev/sdb

New partition, size `+500M`, Type `82` (Swap).

1. partprobe /dev/sdb

2. Format as Swap

3. mkswap /dev/sdb2

_(Assuming_ `_sdb2_` _is the new partition.)_

3. Configure Persistent Swap

Get the UUID

1. lsblk -f /dev/sdb2

Edit `/etc/fstab`

1. UUID=<your-uuid>  none  swap  defaults  0 0

2. Activate and Verify

3. swapon -a
4. free -m

**Detailed Explanation**

- **Why UUID?**  
    Device names (like `/dev/sdb2`) can change if you plug the cables into different ports or add a new drive. The UUID (Universally Unique Identifier) is written onto the disk header itself, so the system always finds the correct partition.
    
- `**swapon -a**`  
    Activates all swap devices listed in `/etc/fstab`.
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. For swap:
    
    1. swapon --show
    
    and
    
    2. free -m
    
    confirm it is active now, and the `/etc/fstab` entry is what brings it back. Run:
    
    3. mount -a
    
    to prove the file parses, then reboot and re-check:
    
    4. swapon --show
```

**Question 21**

**Task:** Customize the user environment and perform input/output operations on **ServerB**.

1. Configure a persistent **alias** for the user `root`. The command `myfiles` should execute `ls -l /tmp`. Ensure this works every time root logs in.
    
2. Search the file `/etc/services` for lines containing the string **http**. Redirect these lines to a new file `/root/http_services.txt`, overwriting it if it exists.
    
3. Append the text "Search Complete" to `/root/http_services.txt` without deleting the existing content.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create and edit text files, Use input-output redirection, Shell environment customization).

```
Overall explanation

**Correct Answer:**

1. **Configure Alias:**
    
    - Edit `/root/.bashrc`:
        
        1. vim /root/.bashrc
        
    - Add the line:
        
        1. alias myfiles='ls -l /tmp'
        
    - Apply immediately:
        
        1. source /root/.bashrc
        
2. **Redirect (Overwrite):**
    
    1. grep "http" /etc/services > /root/http_services.txt
    
3. **Redirect (Append):**
    
    1. echo "Search Complete" >> /root/http_services.txt
    

**Detailed Explanation for Learners:**

- `**.bashrc**` **vs** `**.bash_profile**`**:** `.bashrc` is executed for _every_ interactive shell (like opening a new terminal tab). This is the best place for aliases.
    
- `**>**` **vs** `**>>**`**:**
    
    - `>` (Greater Than): Creates a new file or **wipes** an existing one.
        
    - `>>` (Double Greater Than): **Appends** to the end of the file, keeping old data safe.
```

**Question 22**

**Task:** Configure a persistent NFS mount on **ServerB** using /etc/fstab (Do not use Autofs).

1. Create the directory /nfs_share on ServerB.
    
2. Configure the system to mount the remote export servera:/share (or your lab IP) to /nfs_share automatically at boot.
    
3. Ensure the system uses the _netdev option to prevent boot hanging if the network is down.
    

**Aspects/Domains Covered:** Create and configure file systems (Mount network file systems using NFS, Configure systems to mount file systems at boot).

**Prerequisite (Do This on ServerA First)**

Since the RHCSA exam provides a pre-configured server, but your lab does not, run these commands on **ServerA** to create the export.

1. # On ServerA
2. dnf install nfs-utils -y
3. systemctl enable --now nfs-server
4. mkdir -p /share
5. chmod 777 /share
6. echo "/share  *(rw,sync,no_root_squash)" >> /etc/exports
7. exportfs -r
8. firewall-cmd --permanent --add-service=nfs
9. firewall-cmd --permanent --add-service=mountd
10. firewall-cmd --permanent --add-service=rpc-bind
11. firewall-cmd --reload


```
Overall explanation

**Correct Answer (On ServerB)**

1. Create the Mount Point

2. mkdir /nfs_share

3. Edit `/etc/fstab`

Open the configuration file:

1. vim /etc/fstab

Add the following line (replace **servera** with the IP of **ServerA** if DNS is not configured):

1. servera:/share  /nfs_share  nfs  defaults,_netdev  0 0

2. Verify

3. mount -a

4. df -h /nfs_share

You should see the remote share mounted effectively.

**Detailed Explanation for Learners**

- **Static vs. Dynamic**  
    Autofs is dynamic (connects on demand), while `/etc/fstab` is static (connects at boot). The exam may ask for either method specifically.
    
- `**_netdev**`  
    This is a crucial flag for network drives in `fstab`. It tells systemd:
    
    "Do not try to mount this until the Network Service is fully up."
    
    Without it, your server might hang during boot indefinitely trying to reach a network that isn't ready yet.
    
- `**defaults**`  
    Applies standard mount options (`rw`, `suid`, `dev`, `exec`, `auto`, `nouser`, `async`).
    
- `**0 0**`  
    The first zero disables the **dump** backup utility. The second zero disables the **fsck** check at boot (network filesystems should not be checked by the client).
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. For a network mount:
    
    1. mount -a
    
    then:
    
    2. df -h /nfs_share
    
    confirms it works now. The reboot is the real test: if `_netdev` is missing the system may hang at boot waiting for a network that is not up yet.
```




**Question 23**

**Task:** Manage SELinux File Contexts on **ServerB**.

1. Create a custom web directory structure: /web/content/html.
    
2. Create a file /web/content/html/index.html.
    
3. Configure **SELinux** so that the Apache web server (httpd) can serve content from this directory.
    
    - Set the context httpd_sys_content_t on /web and all subdirectories recursively.
        
    - Ensure this context rule persists even if the filesystem is relabeled later.
        
    - Apply the context immediately.
        

- **Aspects/Domains Covered:** Manage security (List and identify SELinux file context, Restore default file contexts).

```
Overall explanation

**Correct Answer**

1. Create the Directory and File

2. mkdir -p /web/content/html
3. touch /web/content/html/index.html

4. Set the Persistent Rule (`semanage`)

5. semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"

6. Apply the Rule (`restorecon`)

7. restorecon -Rv /web

8. Verify

9. ls -Z /web/content/html/index.html

Output should include:

1. httpd_sys_content_t

**Detailed Explanation for Learners**

- `**semanage fcontext**`  
    This updates the policy database. It doesn't change the files on disk yet; it just writes the rule:
    
    "For the future, `/web` should be `httpd_sys_content_t`."
    
- `**restorecon**`  
    This reads the policy database and applies it to the actual files on the disk.
    
- **The Regex** `**"/web(/.*)?"**`  
    This matches the folder `/web` **and everything inside it** (recursively).
    
- **The Policy Database**  
    `semanage fcontext` writes your rule into the SELinux policy database — on disk at:
    
    1. /etc/selinux/targeted/contexts/files/file_contexts.local
    
    The rule states what the label should be, and it is what makes the labelling persistent: it survives a reboot and a full filesystem relabel.
    
- **Why** `**restorecon**` **Is Required**  
    The database is not the disk. `restorecon` reads the rules and stamps the labels onto the files themselves, which is what SELinux actually checks at access time. `semanage` without `restorecon` leaves the files wrongly labelled right now; `chcon` without `semanage` labels them correctly now but loses the change at the next relabel. The task asks for both halves, and both are graded.
    
- **Checking Your Work**
    
    1. semanage fcontext -l | grep /web
    
    2. restorecon -Rvn /web
    
    The first command shows the rule you added to the policy database. The second is a dry run — `-n` prints what `restorecon` would change without changing it, so silent output means the labels on disk already match the policy. Together with `ls -Z` these confirm the rule and the labels agree.
    
- **Exam Pitfall**
    
    - **Always Use Absolute Paths with SELinux.** When defining custom file contexts using `semanage fcontext`, you must use the absolute directory path (e.g., `/var/www/html(/.*)?`). Using a relative path while sitting in the parent directory will fail to apply the context correctly. This is a very common mistake under the time pressure of the real exam!
```


**Question 24**

**Task:** Manage file links on **ServerB**.

1. Create a file `/home/root/data.txt`.
    
2. Create a **Hard Link** to this file named `/home/root/data-hard`.
    
3. Create a **Soft (Symbolic) Link** to this file named `/var/tmp/data-soft`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create hard and soft links).

```
Overall explanation

**Correct Answer:**

1. **Create File:**
    
    1. touch /home/root/data.txt
    
2. **Hard Link:**
    
    1. ln /home/root/data.txt /home/root/data-hard
    
3. **Soft Link:**
    
    1. ln -s /home/root/data.txt /var/tmp/data-soft
    
4. **Verify:**
    
    1. ls -li /home/root/data*
    2. # Hard link shares the same Inode number.
    3. ls -l /var/tmp/data-soft
    4. # Soft link points (->) to the path.
    

**Detailed Explanation for Learners:**

- **Hard Link (**`**ln**`**):** It's like a backup name for the exact same data on the disk. If you delete the original file, the hard link still works because the data is still there. They share the same Inode.
    
- **Soft Link (**`**ln -s**`**):** It's like a Windows shortcut. It just points to the path. If you delete the original file, the soft link breaks.
```


**Question 25**

**Task:** Configure Access Control for the Cron scheduler on **ServerB**.

1. Configure the system so that only the user `tom` is allowed to create cron jobs.
    
2. All other users (except root) should be denied.
    
3. Verify by attempting to list cron jobs as a different user (e.g., `sam`).
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at and cron).

```
Overall explanation

**Correct Answer:**

1. **Create/Edit Allow File:**
    
    1. vim /etc/cron.allow
    
    - Add the user:*
        
        1. tom
        
2. **Verify:**
    
    - Switch to a denied user:
        
        1. su - sam
        2. crontab -l
        3. # Output: You (sam) are not allowed to use this program.
        

**Detailed Explanation for Learners:**

- **The Logic:**
    
    - If `/etc/cron.allow` exists, **ONLY** users listed in it can use cron. Everyone else is denied implicitly.
        
    - If `/etc/cron.allow` does NOT exist, the system checks `/etc/cron.deny`.
        
    - For the exam, creating `cron.allow` is the fastest way to implement "Deny Everyone Else."
```

**Question 26**

**Task:** Configure **ServerB**'s SELinux mode.

1. Check the current SELinux mode.
    
2. Set the system to run in **Enforcing** mode.
    
3. Ensure this setting is persistent across reboots.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

```
Overall explanation

**Correct Answer**

1. Check the Current Status

2. getenforce

or

1. sestatus

2. Set the Immediate Mode

3. setenforce 1

4. Configure Persistence

Edit:

1. vim /etc/selinux/config

Change:

1. SELINUX=permissive

(or `SELINUX=disabled`) to:

1. SELINUX=enforcing

**Note:** If it was previously `disabled`, you must reboot to activate SELinux.

**Detailed Explanation for Learners**

- `**setenforce 1**`  
    Changes the mode **right now** in the active kernel.
    
- `**/etc/selinux/config**`  
    Changes the mode for the **next boot**. You must do both to be correct.
    
- **Modes**
    
    - **Enforcing:** Blocks and logs policy violations. (Default/Target).
        
    - **Permissive:** Logs violations but does not block them. (Useful for debugging).
        
    - **Disabled:** Turns off the SELinux kernel subsystem entirely.
        
- `**setenforce**` **and** `**/etc/selinux/config**` **Do Different Jobs**  
    `setenforce 1` flips the mode in the running kernel and takes effect instantly, but the value is stored nowhere — the next boot reads the config file. Setting `SELINUX=enforcing` in `/etc/selinux/config` decides the mode for every future boot but changes nothing in the current session. A task worded **"set to enforcing and make it persistent"** is asking for two separate actions.
    
- **Coming Back from** `**disabled**`  
    `setenforce` only switches between **enforcing** and **permissive** — it cannot turn SELinux on. If the system booted with `SELINUX=disabled`, the kernel subsystem was never loaded, so the config file plus a reboot is the only route, and that first boot performs a full filesystem relabel. Budget time for it.
    
- **Verifying Both Halves at Once**
    
    1. getenforce
    
    2. sestatus | grep -E 'Current mode|Mode from config'
    
    `getenforce` prints the running mode in one word. `sestatus` shows the running mode and the **"Mode from config file"** line — the fastest single proof that you did the immediate change and the persistent one.
    
- **Exam Tip**  
    Immediate and persistent changes are two separate requirements on the RHCSA exam, and doing only one scores zero on a rebooted system. `setenforce 1` satisfies the first; `SELINUX=enforcing` in `/etc/selinux/config` satisfies the second. The same split applies to firewall rules (`--permanent`), SELinux booleans (`setsebool -P`), and mounts (`/etc/fstab`).
```

**Question 27 (New Topic: Flatpak)**

**Task:** Manage applications on **ServerB** using **Flatpak**.

1. Add the **Flathub** remote repository (URL: https://dl.flathub.org/repo/flathub.flatpakrepo) if it does not exist.
    
2. Search for the application GIMP (GNU Image Manipulation Program).
    
3. Install the GIMP application from Flathub.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

```
Overall explanation

**Correct Answer**

1. Add the Remote Repository

2. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

3. Search for GIMP

4. flatpak search gimp

Note the Application ID, e.g., `org.gimp.GIMP`.

3. Install the Application

4. flatpak install flathub org.gimp.GIMP -y

**Detailed Explanation for Learners**

- **Sandbox Security**  
    RHEL 10 emphasizes Flatpak for GUI apps because they run isolated. Even if GIMP gets hacked, it cannot easily touch your `/etc/passwd` file or system logs.
    
- **App IDs**  
    Flatpak uses "reverse domain" IDs (like `org.gimp.GIMP`) to prevent naming conflicts between different developers.
    
- **System-Wide and User Installations**  
    Run with root privileges, `flatpak install` places the application under `/var/lib/flatpak` and makes it available to every account on ServerB. `flatpak install --user` places it under `~/.local/share/flatpak` for the invoking account only and needs no sudo. Remotes are scoped the same way, so a `--user` installation also needs its remote added with `flatpak remote-add --user`.
    
- **Why This Task Uses a System-Wide Installation**  
    The task says to manage applications on ServerB and names no user, so GIMP must be available to everyone on the host. `flatpak remote-add` and `flatpak install` without `--user` are therefore the correct commands, and it is the system installation the grader inspects. Reach for `--user` only when the task names a specific account.
    
- **Everyday Flatpak Commands**
    
    1. flatpak remotes
    
    2. flatpak list
    
    3. flatpak list --app --columns=application,installation
    
    4. flatpak uninstall org.gimp.GIMP
    
    5. flatpak uninstall --unused
    
    `flatpak remotes` confirms Flathub was added — add `--user` to see per-user remotes. `flatpak list` shows everything installed including runtimes; `--app` narrows it to applications, and the installation column reports `system` or `user`. `flatpak uninstall` removes an application from the system scope — `flatpak uninstall --user` is a separate operation — and `--unused` reclaims runtimes nothing depends on any more.
    
- **Exam Tip**  
    Before moving to the next task, verify both functionality and persistence whenever the objective requires it. Confirm the remote with:
    
    1. flatpak remotes
    
    and the application with:
    
    2. flatpak list --app
    
    The installation itself persists, but the remote must still be present for any later task that installs from it.
```

**Question 28**

**Task:** Configure a shared group directory on **ServerB**.

1. Create a directory `/collaboration`.
    
2. Create a group named `managers`.
    
3. Set ownership so that `/collaboration` is owned by the group `managers`.
    
4. Configure permissions so that new files created inside `/collaboration` **automatically inherit** the group `managers`.
    

- **Aspects/Domains Covered:** Manage users and groups (Modify local groups), Create and configure file systems (Configure permission problems/SGID).

```
Overall explanation

**Correct Answer:**

1. **Create Resources:**
    
    1. mkdir /collaboration
    2. groupadd managers
    
2. **Set Ownership:**
    
    1. chown :managers /collaboration
    
3. **Set SGID Bit:**
    
    1. chmod g+s /collaboration
    
4. **Verify:**
    
    1. ls -ld /collaboration
    2. # Output permissions should look like: drwxr-sr-x
    

**Detailed Explanation for Learners:**

- **The "Collaboration" Problem:** Normally, if User A creates a file, User A's primary group owns it. User B (in the same team) might not be able to edit it.
    
- **The SGID Solution:** The `g+s` (Set Group ID) bit on a directory forces any new file inside to adopt the _directory's_ group, not the _user's_ primary group. This ensures files stay shared.
```

**Question 29**

**Task:** Install a software package from a remote URL on **ServerB**.

1. Install the `zsh` package.
    
2. Do not use the standard repository. Instead, install it directly from this URL: `http://example.com/pub/zsh.rpm` (Note: In the real exam, this will be a valid internal link).
    
3. Ensure dependencies are resolved automatically.
    

- **Aspects/Domains Covered:** Manage software (Install software packages from a remote repository or file system).

```
Overall explanation

**Correct Answer:**

1. **Install via DNF:**
    
    1. dnf install http://example.com/pub/zsh.rpm -y
    
    _(Note: If the URL requires authentication, use_ `_dnf install https://username:password@example.com/..._`_)_
    

**Detailed Explanation for Learners:**

- **DNF vs RPM:** You could use `rpm -ivh url...`, but `rpm` cannot download dependencies. If `zsh` needs a specific library, `rpm` will fail. `dnf` is smarter—it downloads the target RPM and then looks in your configured repos (BaseOS/AppStream) to fetch any dependencies needed to make it run.
```

**Question 30**

**Task:** Manage process priorities and signals on **ServerB**.

1. Start a background process: `sleep 5000 &`.
    
2. Locate the **PID** of this process.
    
3. Change the priority (niceness) of this running process to **15** (Lower priority).
    
4. Terminate the process gracefully using the **SIGTERM** signal.
    

- **Aspects/Domains Covered:** Operate running systems (Identify CPU intensive processes, Adjust process scheduling, Kill processes).
```
Overall explanation

**Correct Answer**

**1. Start Process:**

1. sleep 5000 &

**2. Find PID:** Instead of parsing a long list, use `pgrep` (Process Grep) to find the ID directly:

1. pgrep -a sleep
2. # OR
3. jobs -l

**3. Renice:** Set the priority to 15 for the found PID (e.g., 1234):

1. renice -n 15 -p 1234

**4. Kill (Graceful):** The `kill` command sends **SIGTERM** (Signal 15) by default, so no flag is strictly necessary.

1. kill 1234
2. # Explicit alternative: kill -SIGTERM 1234

**Detailed Explanation for Learners**

- **Finding PIDs (**`**pgrep**`**):** This command is much more efficient than running `ps aux | grep sleep`. It returns strictly the PIDs of matching processes. Adding `-a` shows the name so you can confirm it is the right one.
    
- **Signals:**
    
    - **SIGTERM (15):** The default signal. It says "Please stop." It allows the program to save data and close files before quitting.
        
    - **SIGKILL (9):** "Die immediately." The kernel rips the process from memory. Use this only as a last resort if SIGTERM fails.
        
- **Niceness:** Remember, a higher number (15) means the process is "Nicer" to others, meaning it takes _less_ CPU time.
```

