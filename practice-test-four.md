**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `countersign` to regain access to the system.
    
2. Ensure that the system boots normally and that SELinux context violations do not prevent login.
    

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).

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

**Question 2**

**Task:** Configure a software repository on **ServerB** using the locally mounted RHEL 10 DVD/ISO.

1. Create the directory /mnt/repo.
    
2. Mount the ISO/DVD device /dev/sr0 to /mnt/repo automatically at boot.
    
3. Configure a DNF repository to install packages from /mnt/repo (BaseOS and AppStream).
    
4. Enable GPG checking using the key located at /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Mount file systems at boot).
Overall explanation

**Correct Answer**

1. Create the Mount Point

2. mkdir -p /mnt/repo

3. Configure Persistent Mounting

Add the following line to the end of `**/etc/fstab**`:

1. /dev/sr0  /mnt/repo  iso9660  defaults  0 0

Then mount the device immediately:

1. mount -a

2. Configure the Repository File

Create:

1. /etc/yum.repos.d/dvd.repo

2. [BaseOS_DVD]
3. name=BaseOS DVD
4. baseurl=file:///mnt/repo/BaseOS
5. enabled=1
6. gpgcheck=1
7. gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

8. [AppStream_DVD]
9. name=AppStream DVD
10. baseurl=file:///mnt/repo/AppStream
11. enabled=1
12. gpgcheck=1
13. gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

14. Verify the Configuration

Clean the metadata cache and verify that the repositories are recognized:

1. dnf clean all
2. dnf repolist

**Detailed Explanation for Learners**

- **Why RHEL 10?**  
    While the structure is similar to previous versions, ensuring the paths point to the correct mount point (`/mnt/repo`) is critical for passing the grading script.
    
- **GPG Checking**  
    Setting `gpgcheck=1` instructs the system to verify the authenticity of the RPM (Red Hat Package Manager) files. Pointing to the specific `gpgkey` path ensures the system has the "lock" to verify the package signatures.
    
- **AppStream vs. BaseOS**  
    In modern RHEL versions, the installation media is split. **BaseOS** provides the core operating system, while **AppStream** contains the modules, runtimes, and tools. Both repositories are required for a fully functional installation source.
    
- **Why the Mount Must Be Persistent**  
    The `/etc/fstab` entry is the graded half of this task. Mounting `/dev/sr0` manually works only until the next reboot. After reboot, the mount point is empty, both repositories point to nothing, and every `dnf` command fails. Test the entry with:
    
    1. mount -a
    
    before rebooting — a malformed `/etc/fstab` entry can drop the system into emergency mode.
    
- **Why BaseOS and AppStream Are Separate Repositories**  
    Since RHEL 8, the installation media contains two independent package trees, each with its own `repodata` directory.
    
    - **BaseOS** contains the core operating system (kernel, `systemd`, `glibc`, etc.).
        
    - **AppStream** contains applications, programming languages, databases, and modules that have independent release cycles.
        
    
    Because each tree has its own metadata, DNF cannot read them through a single base URL. For example:
    
    1. file:///mnt/repo
    
    does **not** contain repository metadata. That is why two repository definitions point to:
    
    2. file:///mnt/repo/BaseOS
    
    and
    
    3. file:///mnt/repo/AppStream
    
- **How GPG Verification Works**  
    `gpgcheck=1` tells DNF to verify each package's signature before installation, while `gpgkey=` specifies the public key used for verification. Red Hat provides this key at:
    
    1. /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    
    which is why the repository uses a `file://` URL instead of downloading a key. The first package installation from a new repository prompts you to import the key. To view imported keys:
    
    2. rpm -qa gpg-pubkey*
    
- **Validating the Repositories**
    
    1. dnf repolist
    
    2. dnf repolist --all
    
    3. dnf repoinfo BaseOS_DVD
    
    `dnf repolist` displays enabled repository IDs and package counts. A repository showing **0 packages** is usually reachable but points to the wrong directory. `--all` also displays disabled repositories so you can identify an unintended `enabled=0`. `dnf repoinfo <id>` shows the base URL, `gpgcheck` setting, and metadata timestamp, confirming that DNF is using the expected repository configuration.
    
- **Common Troubleshooting**
    
    - **ISO not mounted** — `lsblk` shows `/dev/sr0` without a mount point, or `ls /mnt/repo` is empty. In a virtual machine, ensure the optical drive is connected and **Connect at startup** is enabled, then run:
        
        1. mount -a
        
    - **Incorrect mount point** — the `/etc/fstab` entry and `baseurl` must reference the same directory. Mounting at `/mnt/dvd` while the repository uses `/mnt/repo` results in an empty repository. Verify with:
        
        1. findmnt /mnt/repo
        
    - **Incorrect** `**baseurl**` — the correct syntax is:
        
        1. file:///mnt/repo/BaseOS
        
        (`file://` plus an absolute path). Using only two slashes or stopping at `/mnt/repo` causes repository failures. Verify the metadata exists:
        
        2. ls /mnt/repo/BaseOS/repodata/repomd.xml
        
    - **Missing GPG key** — if installation fails with **"public key is not installed"** or **"GPG check FAILED"**, verify the key exists:
        
        1. ls /etc/pki/rpm-gpg/
        
        If necessary, import it manually:
        
        2. rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For a repository, ensure:
    
    1. dnf repolist
    
    shows a non-zero package count and a test:
    
    1. `dnf install <package>`
    
    successfully resolves. Then reboot and verify again, because it is usually the `/etc/fstab` mount—not the `.repo` file—that fails after a restart.
**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings:

- **IPv4:** `192.168.1.5/24`, Gateway: `192.168.1.1`, DNS: `8.8.8.8`.
    
- **IPv6:** `fd01::105/64`, Gateway: `fd01::1`.
    
- **Secondary IPv4:** `10.0.0.5/24`.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).

Overall explanation

**Correct Answer:**

1. **Identify Connection:**
    
    1. nmcli con show
    2. # Assume connection 'enp0s3'
    
2. **Apply Primary Settings:**
    
    1. nmcli con mod "enp0s3" \
    2. ipv4.method manual ipv4.addresses 192.168.1.5/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 \
    3. ipv6.method manual ipv6.addresses fd01::105/64 ipv6.gateway fd01::1
    
3. **Add Secondary IP:**
    
    1. nmcli con mod "enp0s3" +ipv4.addresses 10.0.0.5/24
    
4. **Activate:**
    
    1. nmcli con up "enp0s3"
    

**Detailed Explanation:**

- **Merging:** This single question covers the objectives of original Q3, Q4, and Q5.
    
- `**+ipv4.addresses**`**:** The plus sign is critical. Without it, the `10.0.0.5` address would overwrite the `192.168.1.5` address set in the previous step.
**Question 4**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters).

Overall explanation

**Correct Answer:**

1. **Create Config File:**
    
    - Create `/etc/sysctl.d/99-forwarding.conf`:
        
        1. vim /etc/sysctl.d/99-forwarding.conf
        
2. **Add Parameters:**
    
    1. net.ipv4.ip_forward = 1
    2. net.ipv6.conf.all.forwarding = 1
    
3. **Apply:**
    
    1. sysctl -p /etc/sysctl.d/99-forwarding.conf
    

**Detailed Explanation:**

- `**/etc/sysctl.d/**`**:** It is better to create a new file here than to edit the main `/etc/sysctl.conf`. It keeps your custom changes separate from system defaults.
    
- `**sysctl -p**`**:** Loads the settings from the file into the running kernel immediately.

**Question 5 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, replace a legacy Cron job with a **Systemd Timer**.

1. Create a script /usr/local/bin/notify.sh that prints "Time for Break!" to the system log (use logger). Make it executable.
    
2. Create a service unit notify.service.
    
3. Create a timer unit notify.timer that runs this service **daily at 7:00 AM**.
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).

Overall explanation

**Correct Answer**

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/notify.sh
3. echo 'logger "Time for Break!"' >> /usr/local/bin/notify.sh
4. chmod +x /usr/local/bin/notify.sh

5. Create the Service Unit

Create the file:

1. /etc/systemd/system/notify.service

2. [Unit]
3. Description=Notify Service

4. [Service]
5. Type=oneshot
6. ExecStart=/usr/local/bin/notify.sh

7. Create the Timer Unit

Create the file:

1. /etc/systemd/system/notify.timer

2. [Unit]
3. Description=Run Notify at 7AM

4. [Timer]
5. OnCalendar=*-*-* 07:00:00
6. Unit=notify.service

7. [Install]
8. WantedBy=timers.target

9. Activate

10. systemctl daemon-reload
11. systemctl enable --now notify.timer

**Detailed Explanation**

- `**OnCalendar**`  
    The syntax:
    
    1. *-*-* 07:00:00
    
    means:
    
    **Any Year, Any Month, Any Day, at 07:00:00**
    
    This is the direct replacement for Cron's:
    
    2. 0 7 * * *
    
- `**logger**`  
    Using `logger` writes to the system log (`journald`, and depending on configuration, `/var/log/messages` or `/var/log/syslog`). This is a cleaner way to log background tasks than printing to a specific terminal (`/dev/pts/0`).
    
- **Timer and Service Units Are a Pair**  
    The timer carries only the schedule; the work lives in `notify.service`. That is why this answer creates two unit files — a timer on its own has nothing to activate. `Unit=notify.service` names the unit to trigger; systemd would pair the two automatically because the base names match, but stating it is good practice and becomes mandatory the moment the names differ, since a timer that finds no matching unit elapses on schedule and does nothing at all.
    
- **Reading** `**OnCalendar**` **Syntax**  
    The format is:
    
    1. DayOfWeek Year-Month-Day Hour:Minute:Second
    
    where `*` means **every**.
    
    Therefore:
    
    2. *-*-* 07:00:00
    
    means **every day at 07:00**.
    
    The day-of-week field is optional. For example:
    
    3. Mon-Fri *-*-* 07:00:00
    
    runs only on weekdays.
    
    Useful shorthands include:
    
    - `daily` → `*-*-* 00:00:00`
        
    - `hourly` → `*-*-* *:00:00`
        
    
    Never guess the syntax under exam pressure — validate it:
    
    1. systemd-analyze calendar "*-*-* 07:00:00"
    
    This prints the normalized form and the next scheduled run, or an error if the expression is malformed.
    
- **Why** `**daemon-reload**` **Is Required**  
    systemd keeps unit files cached in memory. Until you run:
    
    1. systemctl daemon-reload
    
    a newly created unit does not exist as far as systemd is concerned, and an edited one still runs its previous version. Run it after every change under `/etc/systemd/system/`.
    
- **Enable the Timer, Not the Service**  
    `systemctl enable --now notify.timer` does both halves:
    
    - **enable** creates the symlink so the timer starts automatically after reboot.
        
    - **--now** starts it immediately.
        
    
    Enabling `notify.service` instead would run the script once at boot and never again, losing the schedule entirely.
    
- **Verification and Checking Execution**
    
    1. systemctl list-timers
    
    2. systemctl list-timers --all
    
    3. journalctl -u notify.service
    
    `list-timers` shows **NEXT**, **LEFT**, **LAST**, and **PASSED** for active timers. `--all` includes inactive timers, making it easier to spot a timer that loaded but never scheduled. `journalctl -u notify.service` is the only one that proves the service actually ran — and because this script uses `logger`, you can also locate the log message with:
    
    4. journalctl -t root -g "Time for Break"
    
- **Why** `**OnCalendar**` **Replaces Cron for Many Enterprise Workloads**  
    A timer is an ordinary systemd unit, so the job inherits everything the rest of the system already has:
    
    - Structured logs through `journalctl -u`
        
    - Recorded exit status in `systemctl status`
        
    - Ordering with `After=` and `Requires=`
        
    - Resource limits
        
    - Optional private `/tmp`
        
    
    Cron provides only a mail message and a log entry. `OnCalendar` also supports features Cron lacks, such as:
    
    - `Persistent=true` to catch up missed runs after downtime.
        
    - `RandomizedDelaySec=` to spread scheduled jobs across many servers and avoid all systems running at exactly **07:00**.
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm:
    
    1. systemctl is-enabled notify.timer
    
    returns `enabled`, then reboot and verify:
    
    2. systemctl list-timers
    
    still shows the next scheduled run.

**Question 6**

**Task:** Configure system time settings on **ServerB**.

1. Set the system timezone to **America/Cancun**.
    
2. Configure **NTP** using `chrony` to synchronize the system clock.
    
3. Ensure the `chronyd` service is enabled and running.
    
4. Verify that NTP synchronization is active.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).

Overall explanation

**Correct Answer:**

1. **Set Timezone:**
    
    1. timedatectl set-timezone America/Cancun
    
2. **Enable and Start Chrony:**
    
    1. dnf install chrony -y
    2. systemctl enable --now chronyd
    
3. **Enable NTP Sync:**
    
    1. timedatectl set-ntp true
    
4. **Verify:**
    
    1. timedatectl
    2. # Look for "Time zone: America/Cancun" and "NTP synchronized: yes"
    

**Detailed Explanation for Learners:**

- `**timedatectl**`**:** This is the unified command tool for the `systemd-timedated` service. It handles both the timezone (by symlinking `/etc/localtime`) and the NTP state.
    
- **NTP vs. Hardware Clock:** While you can set time manually, the exam requires _synchronization_. This means the server automatically corrects its clock drift by talking to internet time servers.
**Question 7**

**Task:** Configure **ServerB** to boot into the **Graphical Target** by default.

1. Ensure that upon reboot, the system presents a graphical login screen (GUI).
    
2. Verify the default target setting.
    

- **Aspects/Domains Covered:** Operate running systems (Configure systems to boot into a specific target automatically).
Overall explanation

**Correct Answer:**

1. **Set Target:**
    
    1. systemctl set-default graphical.target
    
2. **Verify:**
    
    1. systemctl get-default
    2. # Output: graphical.target
    

**Detailed Explanation for Learners:**

- **Targets:**
    
    - `**multi-user.target**`**:** Command Line Interface (CLI) only. Similar to Runlevel 3.
        
    - `**graphical.target**`**:** GUI with CLI underneath. Similar to Runlevel 5.
        
- **Dependencies:** If you set `graphical.target` but the server doesn't have a desktop environment installed (like GNOME), it will fall back to multi-user automatically. However, for the exam, simply setting the target is the requirement.
**Question 8**

**Task:** Manage user accounts on **ServerB**.

1. Create a user named `john`.
    
2. Manually assign the **UID** `1250`.
    
3. Configure the account to **expire** on **December 21, 2029** (2029-12-21).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).
Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd -u 1250 -e 2029-12-21 john
    
2. **Verify:**
    
    1. id john
    2. # check uid=1250
    3. chage -l john
    4. # check Account expires: Dec 21, 2029
    

**Detailed Explanation for Learners:**

- **Expiration (**`**-e**`**) vs. Password Aging:**
    
    - **Account Expiration:** The _entire account_ locks on a specific date. Used for temporary contractors.
        
    - **Password Aging:** The _password_ expires after X days, forcing a change. The account remains active.
        
- **Date Format:** YYYY-MM-DD is the standard ISO format accepted by `useradd`.
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

Overall explanation

**Correct Answer:**

1. **Create Resources:**
    
    1. touch /var/test
    2. useradd oliver
    3. groupadd admins
    4. useradd jack
    5. useradd jacob
    
2. **Set Base Permissions:**
    
    1. chown oliver:admins /var/test
    2. chmod 644 /var/test
    3. # (Owner rw, Group r, Other r)
    
3. **Set ACLs:**
    
    1. setfacl -m u:jack:rw /var/test
    2. setfacl -m u:jacob:--- /var/test
    
4. **Verify:**
    
    1. getfacl /var/test
    

**Detailed Explanation for Learners:**

- **The Mask:** When you add an ACL to a file, the "Group" permission shown by `ls -l` changes meaning. It becomes a "Mask"—the maximum permission allowed for any ACL user or group.
    
- **Specificity:** ACLs allow you to override general rules. Even if "Others" have Read access, an ACL specifically denying `jacob` takes precedence for that specific user.

**Question 10**

**Task:** Configure **LVM** storage on **ServerB**.

1. Using disk `/dev/sdb`, create a Volume Group named `vg1`. (Create a 2GiB partition first if necessary).
    
2. Create a Logical Volume named `lv1` with a size of **1GiB**.
    
3. Format `lv1` with **ext4** and mount it persistently at `/lv1`.
    
4. **Extend** the Logical Volume by **500MiB** and resize the filesystem.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).

Overall explanation

**Correct Answer:**

1. **Prepare Partition:**
    
    1. fdisk /dev/sdb
    2. # Create partition 1, +2G, type 8e.
    3. pvcreate /dev/sdb1
    
2. **Create VG and LV:**
    
    1. vgcreate vg1 /dev/sdb1
    2. lvcreate -n lv1 -L 1G vg1
    
3. **Format and Mount:**
    
    1. mkfs.ext4 /dev/vg1/lv1
    2. mkdir /lv1
    3. echo "/dev/vg1/lv1 /lv1 ext4 defaults 0 0" >> /etc/fstab
    4. mount -a
    
4. **Extend:**
    
    1. lvextend -r -L +500M /dev/vg1/lv1
    

**Detailed Explanation for Learners:**

- `**lvextend**` **vs** `**lvresize**`**:** They are largely interchangeable for growing volumes, but `lvextend` is specifically mnemonic for _growing_.
    
- **Order of Operations:** You must extend the container (LV) _before_ you extend the contents (Filesystem). The `-r` flag handles this order automatically. If you did it manually, you would run `lvextend` then `resize2fs`.


**Question 11**

**Task:** Configure deduplicated and compressed storage on ServerB using VDO.

- Using disk /dev/sdc (or an available partition), create a Volume Group named vdovg.
    
- Create a VDO Logical Volume named myvdo.
    
- Set the Physical size to **5GiB** (to accommodate VDO metadata).
    
- Set the Logical (Virtual) size to **50GiB**.
    
- Format the volume with xfs.
    
- Mount it persistently at /mydir.
    

**Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - VDO).


Overall explanation

**Correct Answer**

1. Install the VDO Tools

Ensure the necessary **LVM** and **VDO** management packages are installed.

1. dnf install lvm2 vdo -y

2. Prepare the Physical Volume and Volume Group

3. pvcreate /dev/sdc

4. vgcreate vdovg /dev/sdc

5. Create the VDO Volume

**Note:** RHEL 10 requires a minimum physical size of approximately **5GB** for VDO metadata.

1. lvcreate --type vdo --name myvdo --size 5G --virtualsize 50G vdovg

2. Format and Mount

3. mkfs.xfs /dev/vdovg/myvdo
4. mkdir /mydir
5. echo "/dev/vdovg/myvdo /mydir xfs defaults 0 0" >> /etc/fstab
6. mount -a

7. Verify

8. vdostats --human-readable

or

1. lvs -o+vdo_compression,vdo_deduplication

**Detailed Explanation for Learners**

- **VDO in LVM**  
    In RHEL 9 and RHEL 10, VDO is managed entirely through **LVM**. You no longer use the legacy `vdo` command.
    
- **Concept**  
    VDO sits between the filesystem and the disk. It compresses data and removes duplicate blocks before writing them to physical storage. This allows you to present a **50GB** logical volume while consuming only **5GB** of physical storage, assuming the data compresses well or contains duplicate blocks.
    
- **Size Requirement**  
    VDO requires a significant amount of physical space for its internal **UDS (Universal Deduplication Service)** index. In RHEL 10, a physical size of roughly **5GB** is the practical minimum.
    
- **VDO Architecture — Three Layers in One Device**  
    Virtual Data Optimizer sits between the filesystem and the physical storage and presents a device much larger than the backing storage. Every write passes through three stages:
    
    1. Zero-block elimination.
        
    2. Deduplication.
        
    3. Compression.
        
    
    Only the remaining data is written to disk. Reads reverse this process transparently, so the filesystem never knows these optimizations are occurring.
    
- **Deduplication**  
    VDO maintains a **Universal Deduplication Service (UDS)** index containing fingerprints of every **4KiB** block already stored. When a new block matches an existing fingerprint, VDO stores only another reference instead of writing the block again.
    
    This is why VDO performs especially well for:
    
    - Virtual machine images
        
    - Container layers
        
    - Backup repositories
        
    
    It provides little benefit for already compressed or encrypted files because their blocks are typically unique.
    
- **Compression**  
    Data that survives deduplication is compressed using **LZ4**, which prioritizes speed over maximum compression ratio. Multiple compressed blocks can share a single physical block. Compression and deduplication operate independently and are both enabled by default, which is why:
    
    1. lvs -o+vdo_compression,vdo_deduplication
    
    confirms both features are active.
    
- **Physical Versus Virtual Size**  
    `--size 5G` allocates actual storage from the volume group.
    
    `--virtualsize 50G` defines the size seen by the filesystem and `df`.
    
    The **50GiB** is an address space rather than reserved storage. A **10:1** ratio is common because compression and deduplication are expected to reduce physical usage. The downside is that if the physical pool fills before the virtual space does, writes fail and the filesystem may become read-only.
    
- **Metadata Overhead — Why 5GiB Is the Minimum**  
    The UDS index and block map consume physical storage before user data is written. That fixed overhead is why RHEL 10 rejects physical sizes significantly smaller than **5GiB**. A newly created VDO volume already reports some space in use because the metadata has already been allocated.
    
- **Monitoring Usage**
    
    1. vdostats --human-readable
    
    2. lvs -o+vdo_compression,vdo_deduplication
    
    3. lvs -o lv_name,lv_size,data_percent vdovg
    
    `vdostats --human-readable` reports:
    
    - Physical size
        
    - Used space
        
    - Space-saving ratio
        
    - Percentage saved
        
    
    `lvs` with VDO columns confirms compression and deduplication are enabled.
    
    `data_percent` shows how full the physical backing store is.
    
    Monitor **data_percent**, not `df`. `df` reports the **50GiB** virtual capacity and may still show free space even when the physical storage is nearly exhausted.
    
- **Why VDO Is Managed Through LVM in Modern RHEL**  
    In RHEL 8, VDO was a separate subsystem with its own:
    
    - `vdo` command
        
    - Configuration files
        
    - Service
        
    
    Beginning with RHEL 9, VDO became a native **LVM segment type**, so:
    
    1. lvcreate --type vdo
    
    creates it exactly like any other logical volume.
    
    This means:
    
    - `lvs`
        
    - `lvextend`
        
    - `vgs`
        
    
    all understand VDO natively, simplifying administration.
    
    **For the RHCSA exam:** if the task says **"Create a VDO volume"**, the correct solution is:
    
    1. lvcreate --type vdo
    
    **not** the legacy `vdo create` command.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For VDO:
    
    1. vdostats --human-readable
    
    should show the VDO volume, and:
    
    2. df -h /mydir
    
    should confirm the filesystem is mounted.
    
    Run:
    
    3. mount -a
    
    before rebooting, then reboot and verify that `/mydir` is mounted automatically. A VDO volume omitted from `/etc/fstab` is one of the most common reasons to lose this task even though the volume itself was created correctly.

**Question 12**

**Task:** Optimize **ServerB** for a specific workload using **Tuned**.

1. Enable the `tuned` service.
    
2. Apply a combined profile configuration:
    
    - Base profile: `virtual-guest` (to optimize for running inside a VM).
        
    - Overlay profile: `accelerator-performance` (or `throughput-performance` if the accelerator profile is unavailable) to disable latency-inducing power saving states.
        
3. Verify the active profiles.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).
Overall explanation

**Correct Answer:**

1. **Enable Service:**
    
    1. systemctl enable --now tuned
    
2. **Apply Profiles:**
    
    1. tuned-adm profile virtual-guest accelerator-performance
    2. # If 'accelerator-performance' is missing in your lab, use 'throughput-performance'.
    
3. **Verify:**
    
    1. tuned-adm active
    

**Detailed Explanation for Learners:**

- **Profile Stacking:** When you list multiple profiles, Tuned applies them in order. The last profile "wins" if there are conflicts.
    
- `**accelerator-performance**`**:** This profile is designed to maximize throughput by pinning CPUs to high frequencies and disabling deep sleep states, which reduces latency for network packets or disk I/O.

**Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install `httpd`.
    
2. Configure the default page (`index.html`) to display: "Welcome to the RHCSA Exam".
    
3. Configure the **Firewall** to allow HTTP and HTTPS.
    
4. Ensure the service starts on boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Firewall).

Overall explanation

**Correct Answer:**

1. **Install:**
    
    1. dnf install httpd -y
    
2. **Content:**
    
    1. echo "Welcome to the RHCSA Exam" > /var/www/html/index.html
    
3. **Firewall:**
    
    1. firewall-cmd --permanent --add-service={http,https}
    2. firewall-cmd --reload
    
4. **Start:**
    
    1. systemctl enable --now httpd
    

**Detailed Explanation for Learners:**

- **Curly Brace Expansion:** `{http,https}` is a Bash shortcut that expands to `http https`, saving you from typing the command twice.
    
- **Verification:** Always test with `curl localhost` to ensure the web server is actually serving your file and not a default "Test Page."



**Question 14**

**Task:** Perform file archiving on **ServerB**.

1. Create a directory `/archive`.
    
2. Create a **gzip** compressed tar archive named `/archive/sysconfig.tar.gz`.
    
3. The archive must contain the `/etc` directory and the file `/root/anaconda-ks.cfg`.
    
4. **Restore** the archive into the directory `/restored/` (create if needed).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files).
  
  Overall explanation

**Correct Answer:**

1. **Create Directories:**
    
    1. mkdir -p /archive /restored
    
2. **Archive:**
    
    1. tar -czf /archive/sysconfig.tar.gz /etc /root/anaconda-ks.cfg
    
3. **Restore:**
    
    1. tar -xzf /archive/sysconfig.tar.gz -C /restored
    

**Detailed Explanation for Learners:**

- `**-z**`**:** Uses gzip. (Filename usually ends in .tar.gz or .tgz).
    
- **Multiple Sources:** Tar accepts multiple file/folder arguments (`/etc /root/...`). It will bundle them all into one file.
    
- **Permissions:** You need root privileges to read `/root/anaconda-ks.cfg` and many files in `/etc`, so run this with `sudo` or as root.
  
  **Question 15**

**Task:** Perform system initialization and hardening on **ServerB**.

1. **Hostname:** Set the static hostname to test.server.com.
    
2. **SSH Security:** Configure the SSH daemon to **disable** password authentication (forcing key-based auth).
    
3. **Restart:** Ensure all changes are applied and persistent.
    

**Aspects/Domains Covered:** Manage Basic Networking (Hostname), Manage security (Configure SSH).


Overall explanation

**Correct Answer**

1. Set the Hostname

2. hostnamectl set-hostname test.server.com

3. Configure SSH Security

Edit the SSH configuration file:

1. vim /etc/ssh/sshd_config

Find the line:

1. PasswordAuthentication yes

and change it to:

1. PasswordAuthentication no

2. Verify the Configuration (The "Sanity Check")

Before restarting the SSH daemon, verify how `sshd` interprets the configuration:

1. sshd -T | grep -i password

Expected output:

1. passwordauthentication no

2. Apply and Persist the Changes

3. systemctl restart sshd

4. systemctl status sshd

Ensure the service is **active (running)**.

Why This Update Matters

- **Version 10 Readiness**  
    As the first instructor covering RHCSA 10, teaching students to use `sshd -T` sets a high technical standard.
    
- **Risk Mitigation**  
    It prevents students from failing the task due to a simple syntax error that prevents the service from starting.
    
- **DNF / SSH Cohesion**  
    It reinforces the idea that in RHEL 10, verifying the **runtime** configuration is just as important as editing the configuration file.
    

**Detailed Explanation for Learners**

- **What** `**sshd -T**` **Actually Does**  
    It parses the complete effective configuration — `/etc/ssh/sshd_config` plus every file included through:
    
    1. Include /etc/ssh/sshd_config.d/*.conf
    
    — and prints the resulting settings in lowercase, one per line.
    
    It shows the daemon's actual interpretation rather than simply displaying the configuration file. This is why:
    
    2. sshd -T | grep -i password
    
    is more reliable than searching `sshd_config` directly: a drop-in configuration file may silently override the setting you edited.
    
- **Why Validating Before Restarting Prevents Service Failures**  
    `sshd` refuses to start if its configuration contains a syntax error. Restarting with a typo stops the service and leaves it unable to start again—which, on a remote system, can lock you out completely.
    
    Running:
    
    1. sshd -T
    
    or
    
    2. sshd -t
    
    checks the configuration without interrupting the running daemon.
    
    Two good habits:
    
    - Keep a second SSH session open while making changes.
        
    - Test a new SSH connection before closing the existing one.
        
- **Useful Verification Commands**
    
    1. sshd -T | grep -Ei "passwordauthentication|permitrootlogin"
    
    2. sshd -t
    
    The first command displays the effective values of the directives being graded.
    
    The second performs a pure syntax check. Successful execution produces no output; failures display the file and line number containing the error.
    
- **Prefer** `**ed25519**` **Keys**  
    `ssh-keygen -t ed25519` is the modern default because it provides short, fixed-size keys and fast authentication without requiring key-size decisions.
    
    Use:
    
    1. ssh-keygen -t rsa -b 3072
    
    only when compatibility with older systems is required.
    
    Either key type satisfies RHCSA objectives, although **ed25519** is generally preferred.
    
- **Order Matters When Disabling Password Authentication**  
    Configure and verify key-based authentication first. Only after confirming a successful key-based login should you set:
    
    1. PasswordAuthentication no
    
    Reversing the order on a remote machine can lock you out.
    
    Remember that the authorized key must reside in:
    
    2. ~/.ssh/authorized_keys
    
    with:
    
    - `~/.ssh` → `700`
        
    - `authorized_keys` → `600`
        
    
    Otherwise, `sshd` ignores the key.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm:
    
    1. systemctl is-enabled sshd
    
    then run:
    
    2. sshd -T
    
    once more after restarting the service. Finally, reboot the system and verify that you can still log in from **ServerA**. Because this task combines a hostname change with an SSH configuration change, it is one of the best candidates for a reboot verification before ending the exam.
    
    **Question 16**

**Task:** Configure **ServerB** (or `test.server.com`) to run SELinux in **Permissive** mode.

1. Check the current SELinux status.
    
2. Set the current runtime mode to Permissive.
    
3. Ensure the system stays in Permissive mode after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).
  
  Overall explanation

**Correct Answer:**

1. **Set Immediate Mode:**
    
    1. setenforce 0
    
2. **Set Persistent Mode:**
    
    - Edit `/etc/selinux/config`:
        
        1. vim /etc/selinux/config
        
    - Modify the line:
        
        1. SELINUX=permissive
        
3. **Verify:**
    
    1. getenforce
    2. # Output: Permissive
    

**Detailed Explanation for Learners:**

- **Why Permissive?** Permissive mode is useful for troubleshooting. It loads the SELinux policy and logs violations (in `/var/log/audit/audit.log`) but does _not_ actually block the actions.
    
- **Persistence:** Editing `/etc/selinux/config` is mandatory for the exam. Just running `setenforce 0` will fail the persistence check after a reboot.
  
  **Question 17 (New Topic: Flatpak)**

**Task:** Manage desktop applications on **ServerB** using Flatpak.

1. Add the **Flathub** remote repository: `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
2. Install the application `org.kde.kcalc` (KCalc) from this remote.
    
3. Ensure the installation is successful.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).
  
  
  
  Overall explanation

**Correct Answer:**

1. **Add Remote:**
    
    1. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
2. **Install Application:**
    
    1. flatpak install flathub org.kde.kcalc -y
    
3. **Verify:**
    
    1. flatpak list | grep kcalc
    

**Detailed Explanation for Learners:**

- **New RHEL 10 Objective:** This replaces the old "Manage Containers" objective.
    
- **Syntax:** `flatpak install [remote] [app-id]`.
    
- **System vs. User:** By default, `sudo flatpak install` installs the app for the whole system (`/var/lib/flatpak`). If you run it without sudo, it might try to install it just for your user (`~/.local/share/flatpak`). For the exam, usually install as root (system-wide).
  
  
  **Task:** Configure default file permissions on **ServerB**.

1. Create a user named `sarah`.
    
2. Configure `sarah`'s environment so that **every time she logs in**, her default **Umask** ensures:
    
    - New **files** have permissions `600` (`rw-------`).
        
    - New **directories** have permissions `700` (`rwx------`).
        

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).
  
  **Correct Answer:**

1. **Create User:**
    
    1. useradd sarah
    
2. **Calculate Umask:**
    
    - Target File: `600`. Base: `666`. `666 - 600` = `066`? No, because directory base is `777`.
        
    - Target Dir: `700`. Base: `777`. `777 - 700` = `077`.
        
    - Correct Umask: **077**. (Checks out for files too: `666 - 077` mathematically results in negatives masked out to `600`).
        
3. **Configure Persistence:**
    
    - Edit `/home/sarah/.bashrc`:
        
        1. vim /home/sarah/.bashrc
        
    - Add line to bottom:
        
        1. umask 077
        
4. **Verify:**
    
    1. su - sarah
    2. touch testfile
    3. ls -l testfile
    4. # Output: -rw-------
    

**Detailed Explanation for Learners:**

- **Umask 077:** This is the most restrictive standard umask. It removes _all_ rights for Group and Others, leaving only the User (Owner) with access.
  
  
  **Question 19**

**Task:** Perform advanced shell redirection on **ServerB**.

1. Execute the command ls /root /fake_directory. (This will generate both a file list output and an error message).
    
2. Redirect **both** the Standard Output (success) and Standard Error (failure) to the same file named /var/tmp/ls_output.txt.
    
3. Ensure the file is overwritten if it already exists.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use input-output redirection 2>&1, &>).
  
  
  
  Overall explanation

Correct Answer

1. Execute the Redirection

2. ls /root /fake_directory > /var/tmp/ls_output.txt 2>&1

**OR (Bash shorthand):**

1. ls /root /fake_directory &> /var/tmp/ls_output.txt

2. Verify

3. cat /var/tmp/ls_output.txt

You should see both:

- The directory listing from `/root`
    
- The **"No such file or directory"** error for `/fake_directory`
    

Detailed Explanation for Learners

- **The File Descriptor Numbers**
    
    - **0** → Standard Input (**stdin**)
        
    - **1** → Standard Output (**stdout**)
        
    - **2** → Standard Error (**stderr**)
        
- `**> file 2>&1**`  
    Read it from left to right:
    
    1. Redirect **stdout** to the file.
        
    2. Redirect **stderr** to wherever **stdout** is currently pointing.
        
- `**&> file**`  
    A Bash shortcut that redirects both **stdout** and **stderr** to the same file.
    
- **Why the Two Streams Are Separate**  
    Every process starts with three file descriptors:
    
    - `0` → Standard Input
        
    - `1` → Standard Output
        
    - `2` → Standard Error
        
    
    Normal command output is written to **stdout**, while error messages go to **stderr**. Keeping them separate allows commands to pipe normal output into another program while still displaying errors on the terminal.
    
    That is why:
    
    1. ls /root /fake_directory > file
    
    captures only the directory listing—the error message still goes to the terminal because **stderr** was never redirected.
    
- **Why Order Matters**
    
    Correct:
    
    1. > file 2>&1
    
    means:
    
    Send **stdout** to the file, then send **stderr** to the same destination.
    
    Incorrect:
    
    2. 2>&1 > file
    
    first redirects **stderr** to the current location of **stdout** (the terminal), then redirects **stdout** to the file. As a result:
    
    - **stdout** → file
        
    - **stderr** → terminal
        
    
    This is one of the most common shell redirection mistakes.
    
    Using:
    
    1. &> file
    
    avoids this problem entirely and is usually the fastest option during the exam.
    
- **Useful Variations**
    
    Discard only error messages:
    
    1. command 2> /dev/null
    
    Overwrite a file:
    
    2. >
    
    Append to a file:
    
    3. >>
    
    Store normal output and errors separately:
    
    4. command > out.txt 2> err.txt
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Redirection tasks are graded based on the contents of the output file—not on what appeared in the terminal. Always finish with:
    
    1. cat /var/tmp/ls_output.txt
    
    and confirm that both the successful output and the error message are present in the file.
    
    
    
    **Question 20**

**Task:** Configure environment variables on **ServerB**.

1. Create a **global** environment variable named CLASS with the value RHCSA.
    
2. Ensure this variable is available to **all users** on the system automatically when they log in.
    
3. Verify by switching to a user (e.g., sarah) and echoing the variable.
    

**Aspects/Domains Covered:** Create simple shell scripts (Environment variables, startup scripts).


Overall explanation

Correct Answer

1. Create the Configuration File

Create a new script under `**/etc/profile.d/**` (recommended method):

1. vim /etc/profile.d/class_var.sh

2. Add the Following Content

3. export CLASS="RHCSA"

4. Verify

5. su - sarah

6. echo $CLASS

Expected output:

1. RHCSA

Detailed Explanation for Learners

- `**/etc/profile**` **vs.** `**/etc/profile.d/**`  
    Although you could edit `/etc/profile` directly, package updates may overwrite local modifications.
    
    The recommended practice is to place a separate script ending with `**.sh**` inside `**/etc/profile.d/**`, which is automatically processed for every login shell.
    
- **Why** `**export**` **Is Required**  
    `export` makes the variable part of the process environment so that child processes and subshells inherit it.
    
    Without `export`, the variable exists only in the current shell and may disappear when running scripts or launching new shells.
    
- **Why** `**/etc/profile.d/**` **Is the Correct Solution**  
    During login, `/etc/profile` automatically sources every `**.sh**` file inside `/etc/profile.d/`.
    
    This approach:
    
    - avoids modifying package-managed files,
        
    - keeps each customization separate,
        
    - is easy to remove later by deleting a single file.
        
    
    The filename **must** end with `**.sh**`, or it will not be sourced.
    
    The file does **not** need executable permissions because it is **sourced**, not executed.
    
- **Quote the Variable Value**  
    Write:
    
    1. export CLASS="RHCSA"
    
    rather than:
    
    2. export CLASS=RHCSA
    
    or
    
    3. CLASS = "RHCSA"
    
    Quoting prevents problems if the value later contains spaces or wildcard characters.
    
    Also remember that shell assignments never contain spaces around the equals sign.
    
- **Login Shells vs. Interactive Shells**  
    Files under `/etc/profile.d/` are read only by **login shells**.
    
    That is why the verification uses:
    
    1. su - sarah
    
    The hyphen (`-`) starts a login shell, causing `/etc/profile` and `/etc/profile.d/*.sh` to be processed.
    
    Using:
    
    2. su sarah
    
    does **not** start a login shell, so the variable may appear to be missing even though the configuration is correct.
    
    Related files include:
    
    - `~/.bash_profile` — per-user login shell initialization.
        
    - `~/.bashrc` — per-user interactive shell initialization.
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Verify exactly as a grader would:
    
    1. su - sarah
    2. echo $CLASS
    
    or:
    
    1. bash -lc "echo $CLASS"
    
    Testing only in your current shell proves the variable exists now, but it does **not** prove that new login sessions automatically receive it.
    
    
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
  
  
  
  
  Overall explanation

Correct Answer

1. Create the File

2. vim /root/dates.txt

Paste the content, then save and exit.

2. Search Using `grep`

3. grep '-0[56]-' /root/dates.txt > /root/summer_birthdays.txt

**Alternatively (Extended Regular Expressions):**

1. grep -E '-(05|06)-' /root/dates.txt > /root/summer_birthdays.txt

2. Verify

3. cat /root/summer_birthdays.txt

Expected output:

1. 2000-05-01 Sam
2. 2002-06-15 Sue
3. 2005-05-10 Mike

Detailed Explanation for Learners

- **Understanding** `**-0[56]-**`
    
    This regular expression uses a **character class**:
    
    - `-` → matches a literal hyphen.
        
    - `0` → matches the digit **0**.
        
    - `[56]` → matches either **5** or **6**.
        
    - `-` → matches the closing hyphen.
        
    
    Therefore it matches only:
    
    - `-05-`
        
    - `-06-`
        
- **Why the Hyphens Matter**
    
    Searching for:
    
    1. 05
    
    alone could accidentally match:
    
    - the year `2005`
        
    - the day `05`
        
    
    Using:
    
    1. -05-
    
    ensures the match occurs only in the **month** field of the date.
    
- **Anchor Patterns When Needed**
    
    `-0[56]-` is already easy to read because the surrounding hyphens identify the month field.
    
    For more complex patterns, use anchors:
    
    - `^` → beginning of line
        
    - `$` → end of line
        
    - `\.` → literal period
        
    
    Well-anchored expressions are easier to understand and debug.
    
- **Basic vs. Extended Regular Expressions**
    
    Standard `grep` uses **Basic Regular Expressions (BRE)**.
    
    Characters such as:
    
    - `(`
        
    - `)`
        
    - `|`
        
    - `+`
        
    - `?`
        
    
    require escaping to act as regex operators.
    
    Using:
    
    1. grep -E
    
    enables **Extended Regular Expressions (ERE)**, allowing constructs like:
    
    2. grep -E '-(05|06)-'
    
    without backslashes.
    
    When grouping or alternation is needed, `grep -E` usually produces shorter and more readable patterns.
    
- **Always Quote Regular Expressions**
    
    Write:
    
    1. grep '-0[56]-'
    
    rather than:
    
    2. grep -0[56]-
    
    Single quotes prevent the shell from interpreting:
    
    - `[ ]`
        
    - `*`
        
    - `?`
        
    
    as filename wildcards before `grep` receives the pattern.
    
- **Useful** `**grep**` **Options**
    
    Print only the matching text:
    
    1. grep -o
    
    Count matching lines:
    
    2. grep -c
    
    Invert the match:
    
    3. grep -v
    
    Display line numbers:
    
    4. grep -n
    
    A useful workflow is to test a new pattern with `-o` before redirecting the final results to a file.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Test the regular expression directly in the terminal before redirecting the output. Once you execute:
    
    1. > /root/summer_birthdays.txt
    
    the target file is overwritten immediately, making it harder to determine whether the pattern matched too many or too few lines.
    
    
    **Question 22**

**Task:** Create a shell script named `/usr/local/bin/process_lines.sh`.

1. The script should read the file `/root/dates.txt` (created in the previous step) line by line.
    
2. For each line, it should print: "Name: [Name] was born on [Date]".
    
3. Use a `while` loop to process the file.
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs, Process file input).
  
  
  
  Overall explanation

Correct Answer

1. Create the Script

2. vim /usr/local/bin/process_lines.sh

3. Add the Following Content

4. #!/bin/bash
5. while read DATE NAME
6. do
7.   echo "Name: $NAME was born on $DATE"
8. done < /root/dates.txt

9. Make the Script Executable

10. chmod +x /usr/local/bin/process_lines.sh

11. Verify

12. /usr/local/bin/process_lines.sh

Detailed Explanation for Learners

- `**while read VAR1 VAR2**`  
    The `read` command automatically splits each input line into fields based on whitespace.
    
    With:
    
    1. while read DATE NAME
    
    the input:
    
    2. 2000-05-01 Sam
    
    becomes:
    
    - `DATE=2000-05-01`
        
    - `NAME=Sam`
        
- `**done < filename**`  
    Redirecting the file into the loop:
    
    1. done < /root/dates.txt
    
    causes the loop to execute once for every line in the file.
    
- **Quote Variables Inside the Loop**
    
    Write:
    
    1. echo "Name: $NAME was born on $DATE"
    
    Quoting preserves the values correctly if a field contains spaces or special characters. Although the sample input is simple, quoting is considered good scripting practice.
    
- **Why** `**done < file**` **Is Better Than** `**cat file | while ...**`
    
    Prefer:
    
    1. while read ...
    2. do
    3.     ...
    4. done < file
    
    instead of:
    
    1. cat file | while read ...
    
    because a pipeline executes the loop in a **subshell**.
    
    Variables modified inside the loop disappear after the loop finishes.
    
    Redirecting the file directly keeps the loop in the current shell and avoids creating an unnecessary extra process.
    
- **How** `**read**` **Assigns Fields**
    
    With:
    
    1. while read DATE NAME
    
    the first field is stored in `DATE`.
    
    The final variable (`NAME`) receives the remainder of the line.
    
    Therefore:
    
    2. 1990-05-04 Sam Smith
    
    results in:
    
    - `DATE=1990-05-04`
        
    - `NAME=Sam Smith`
        
    
    This behavior is often exactly what you want.
    
    For processing arbitrary text files, a more robust pattern is:
    
    1. while IFS= read -r line
    
    which preserves leading whitespace and backslashes exactly as they appear.
    
- **Readability and Executable Permissions**
    
    Good scripting practices include:
    
    - Two-space indentation inside loops.
        
    - One command per line.
        
    - A proper shebang:
        
        1. #!/bin/bash
        
    - Making the script executable:
        
        1. chmod +x /usr/local/bin/process_lines.sh
        
    
    Without the executable bit, running the script directly results in:
    
    1. Permission denied
    
    regardless of whether the script itself is correct.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Execute the script exactly as the task specifies:
    
    1. /usr/local/bin/process_lines.sh
    
    rather than:
    
    2. bash /usr/local/bin/process_lines.sh
    
    Running the script through `bash` hides missing executable permissions or a missing shebang—both of which the RHCSA grading system can detect.
    
    
    
    **Question 23**

**Task:** Manage process signals on **ServerB**.

1. Start the process `sleep 10000` in the background.
    
2. Find the PID of this process.
    
3. Send the **SIGINT** (Interrupt) signal to this process (simulating a Ctrl+C).
    
4. Verify the process has terminated.
    

- **Aspects/Domains Covered:** Operate running systems (Kill processes).
  
  
  Overall explanation

**Correct Answer:**

1. **Start Process:**
    
    1. sleep 10000 &
    
2. **Find PID:**
    
    1. ps aux | grep sleep
    2. # Assume PID is 5555
    
3. **Send Signal:**
    
    1. kill -2 5555
    2. # OR
    3. kill -SIGINT 5555
    
4. **Verify:**
    
    1. jobs
    2. # Should show "Terminated" or "Interrupt"
    

**Detailed Explanation for Learners:**

- **Signal 2 (SIGINT):** This is the "Keyboard Interrupt" signal. It's exactly what happens when you press `Ctrl+C` in a terminal.
    
- **Signal 15 (SIGTERM):** The default `kill` signal. Polite termination.
    
- **Signal 9 (SIGKILL):** Forceful kill.
  
  **Question 24**

**Task:** Configure **ServerB** to boot into **Rescue Mode** by default.

1. Set the default systemd target to `rescue.target`.
    
2. This ensures that upon the next reboot, the system drops into a single-user maintenance shell requiring the root password.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually).
  
  
  Overall explanation

**Correct Answer:**

1. **Set Default Target:**
    
    1. systemctl set-default rescue.target
    
2. **Verify:**
    
    1. systemctl get-default
    2. # Output: rescue.target
    

**Detailed Explanation for Learners:**

- **Rescue Target:** This mounts local filesystems and starts some basic services but does not start the network or allow multiple users. It is used for fixing critical config errors.
    
- **Kernel Option Alternative:** You _could_ also do this by adding `systemd.unit=rescue.target` to the kernel boot line using `grubby`, but `systemctl set-default` is the standard way to make it persistent/permanent.
  
  
  **Question 25**

**Task:** Configure system logging on **ServerB** to be persistent.

1. Configure `systemd-journald` so that logs are stored on disk (`/var/log/journal`) instead of only in memory.
    
2. Restart the journal service.
    
3. Verify that the directory `/var/log/journal` has been created and populated.
    

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).
  
  
  
  Overall explanation

Correct Answer

1. Configure Persistent Journal Storage

Option A — Manual Method

1. mkdir -p /var/log/journal

2. chmod 2755 /var/log/journal

3. chown root:systemd-journal /var/log/journal

**OR**

Option B — Configuration File

Edit:

1. /etc/systemd/journald.conf

Set:

1. Storage=persistent

2. Restart the Journal Service

3. systemctl restart systemd-journald

4. Verify

5. ls -l /var/log/journal

You should see a directory whose name is a long machine UUID.

Detailed Explanation for Learners

- **Volatile vs. Persistent Journals**  
    By default, RHEL stores journal logs in:
    
    1. /run/log/journal
    
    which resides in **RAM**.
    
    Memory-based logs disappear after every reboot.
    
    When:
    
    2. /var/log/journal
    
    exists, `systemd-journald` automatically begins storing logs on disk, making them survive reboots.
    
- **Directory Permissions**
    
    The directory should have:
    
    - Owner:
        
        1. root
        
    - Group:
        
        1. systemd-journal
        
    - Mode:
        
        1. 2755
        
    
    The leading **2** sets the **SGID (Set Group ID)** bit.
    
    This causes newly created journal files to inherit the **systemd-journal** group, allowing authorized users in that group to read journal files without requiring root privileges.
    
- `**Storage=auto**` **vs.** `**Storage=persistent**`
    
    The default configuration is:
    
    1. Storage=auto
    
    which means:
    
    - If `/var/log/journal` exists → store logs persistently.
        
    - Otherwise → store logs only in memory.
        
    
    Setting:
    
    1. Storage=persistent
    
    makes the intent explicit.
    
    If necessary, `systemd-journald` creates `/var/log/journal` automatically and always stores logs on disk.
    
    Both methods satisfy this RHCSA task.
    
    Other possible values include:
    
    - `volatile` — memory only.
        
    - `none` — discard all journal entries.
        
- **Why the Permissions Matter**
    
    If the ownership or SGID bit is incorrect:
    
    - `systemd-journald` may fail to write logs.
        
    - Journal files may become readable only by root.
        
    
    Instead of configuring permissions manually, you can also use:
    
    1. systemd-tmpfiles --create --prefix /var/log/journal
    
    which creates the directory using the correct ownership and permissions.
    
- **Useful Verification Commands**
    
    Display journal disk usage:
    
    1. journalctl --disk-usage
    
    List available boots:
    
    2. journalctl --list-boots
    
    Display the previous boot's journal:
    
    3. journalctl -b -1
    
    `journalctl --disk-usage` reports how much storage the journal occupies.
    
    `journalctl --list-boots` is one of the best indicators that persistence is working.
    
    If more than one boot is listed, previous boot logs have been preserved.
    
    `journalctl -b -1` displays the journal from the immediately preceding boot.
    
    On a volatile system, this command reports that no previous boot logs are available.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. This objective cannot be fully verified without a reboot. Restart the system, then run:
    
    1. journalctl --list-boots
    
    If only the current boot appears, the journal is still being stored in memory. Multiple boot entries confirm that persistent logging has been configured successfully.
    
    **Question 26**

**Task:** Configure **ServerB** to allow the Apache web server process (`httpd_t`) to run in **Permissive** mode, while keeping the rest of the system in **Enforcing** mode.

1. Use the `semanage` command to set the permissive mode for the `httpd_t` domain.
    
2. Verify that the domain is in the permissive list.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux - specifically domains).
  
  
  Overall explanation

Correct Answer

1. Set the `httpd_t` Domain to Permissive

2. semanage permissive -a httpd_t

3. Verify

4. semanage permissive -l

Expected output should include:

1. httpd_t

Detailed Explanation for Learners

- **Domain vs. Global SELinux Mode**  
    Setting the global SELinux mode (using `setenforce 0`) affects the **entire system**.
    
    If the whole system is placed into **Permissive** mode, every SELinux policy violation is allowed, significantly reducing the system's security.
    
    Using:
    
    1. semanage permissive -a httpd_t
    
    affects **only** the Apache (`httpd_t`) domain while the remainder of the system continues enforcing SELinux policy.
    
- **Global Mode vs. Permissive Domains**
    
    1. setenforce 0
    
    changes every SELinux domain to permissive.
    
    In contrast:
    
    2. semanage permissive -a httpd_t
    
    exempts only the `**httpd_t**` domain.
    
    Every other service—including SSH, databases, and system services—remains protected by SELinux.
    
    Think of it as the difference between unlocking the entire building and unlocking a single office.
    
- **Why a Permissive Domain Is Useful**
    
    A permissive domain is intended for **troubleshooting**, not as a permanent solution.
    
    When `httpd_t` is permissive:
    
    - Apache is allowed to continue operating.
        
    - Every SELinux denial is still logged.
        
    
    This allows you to collect all policy violations in a single test instead of fixing them one at a time.
    
    Common permanent fixes include:
    
    - Correcting file contexts:
        
        1. semanage fcontext
        2. restorecon
        
    - Allowing additional ports:
        
        1. semanage port
        
    - Enabling required SELinux booleans:
        
        1. setsebool -P
        
    
    Once troubleshooting is complete, remove the exemption:
    
    1. semanage permissive -d httpd_t
    
    Leaving a production service permanently permissive is considered a security finding rather than a solution.
    
- **Verify the Domain and the Global Mode Separately**
    
    List permissive domains:
    
    1. semanage permissive -l
    
    Display the current global mode:
    
    2. getenforce
    
    Show both the running mode and the configured boot mode:
    
    3. sestatus
    
    `semanage permissive -l` confirms that `**httpd_t**` is configured as a permissive domain.
    
    `getenforce` should still report:
    
    4. Enforcing
    
    proving that only the Apache domain has been exempted.
    
    `sestatus` confirms both:
    
    - the current running mode, and
        
    - the configured mode that will apply after reboot.
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. A permissive domain created with:
    
    1. semanage permissive -a
    
    is stored in the SELinux policy and persists across reboots. After restarting the system, verify both:
    
    2. semanage permissive -l
    
    to confirm that `**httpd_t**` remains in the permissive list, and:
    
    3. getenforce
    
    to ensure the overall system is still running in **Enforcing** mode.
    
    
    **Question 27**

**Task:** Create a shell script named `/usr/local/bin/audit_suid.sh` on **ServerB**.

1. The script should find all files in the `/usr` directory that have the **SUID** (Set User ID) bit set.
    
2. It should only list files smaller than **10MiB**.
    
3. The script should copy these files to the directory `/root/audit_results/` (creating it if it doesn't exist).
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts, Understand and use essential tools (Find files).
  
  
  
  Overall explanation

Correct Answer

1. Create the Script

2. vim /usr/local/bin/audit_suid.sh

3. Add the Following Content

4. #!/bin/bash
5. mkdir -p /root/audit_results
6. find /usr -type f -perm /u=s -size -10M -exec cp -a {} /root/audit_results/ \;

7. Make the Script Executable

8. chmod +x /usr/local/bin/audit_suid.sh

Detailed Explanation for Learners

- `**-perm /u=s**`  
    This symbolic permission test searches for files that have the **Set User ID (SUID)** bit enabled.
    
    The equivalent numeric form is:
    
    1. -perm -4000
    
    Both forms satisfy the RHCSA objective.
    
- `**-size -10M**`  
    The leading minus sign means:
    
    **Smaller than 10 MiB**
    
    Therefore, only files whose size is less than **10MiB** are selected.
    
- **Why** `**cp -a**` **Instead of** `**cp**`
    
    The purpose of this audit is to preserve the properties that make the files interesting.
    
    Using:
    
    1. cp -a
    
    preserves:
    
    - file permissions (including the **SUID** bit),
        
    - ownership,
        
    - timestamps,
        
    - symbolic links,
        
    - extended attributes.
        
    
    A plain:
    
    1. cp
    
    creates new files and typically strips the SUID bit, making the copied files unsuitable for auditing.
    
    While:
    
    2. cp -p
    
    preserves ownership, permissions, and timestamps, it does not preserve symbolic links or behave as comprehensively as archive mode.
    
- **SELinux Contexts**
    
    Even with:
    
    1. cp -a
    
    the copied files normally receive the SELinux context inherited from the destination directory.
    
    If the original SELinux labels must also be preserved, use:
    
    2. cp -a --preserve=context
    
    Verify the resulting labels with:
    
    3. ls -Z /root/audit_results
    
- **Understanding** `**-exec**`
    
    The command:
    
    1. -exec cp -a {} /root/audit_results/ \;
    
    executes:
    
    2. cp -a
    
    once for every matching file.
    
    The escaped semicolon:
    
    3. \;
    
    terminates the `-exec` clause.
    
    The backslash prevents the shell from interpreting the semicolon before `find` sees it.
    
    For improved performance on large directory trees, `find` can batch multiple files into a single command:
    
    4. -exec cp -a -t /root/audit_results {} +
    
    The trailing `+` causes fewer `cp` processes to be started and requires `{}` to appear as the final argument.
    
- **Ordering** `**find**` **Tests**
    
    `find` evaluates its tests from left to right.
    
    Placing inexpensive tests first improves efficiency:
    
    1. -type f
    
    eliminates directories immediately before evaluating more expensive permission and size checks.
    
    While the performance difference under `/usr` is usually small, this ordering becomes important during full filesystem scans.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Run:
    
    1. ls -l /root/audit_results
    
    and confirm that the copied files still display the `**s**` in the owner's execute field (for example, `-rwsr-xr-x`). If the copied files instead show ordinary permissions such as `-rwxr-xr-x`, the SUID bit was not preserved and the audit copy does not accurately reflect the original files.
    
    
    
    **Question 28**

**Task:** Perform a file management operation on ServerB.

- Create a directory `/find/sam_files`.
    
- Find all files and directories in `/home` that are owned by the user **sam**.
    
- Copy them to `/find/sam_files`, ensuring that **permissions and ownership are preserved**.
    

**Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use find).

Overall explanation

**Correct Answer:**

1. **Create Directory:** `mkdir -p /find/sam_files`
    
2. **Find and Copy (Preserving Attributes):** `find /home -user sam -exec cp -rp {} /find/sam_files/ \;` _(Alternatively,_ `_cp -a_` _is also valid and robust)._
    

**Detailed Explanation for Learners:**

- **-user sam:** Filters results to items owned by UID sam.
    
    - _Note:_ `find` matches **all** file types (files, directories, symlinks, etc.) by default unless you restrict it using the `-type` flag (e.g., `-type f` for files only).
        
- **-exec:** Executes a command on every file found.
    
- **cp -rp:**
    
    - **-r (Recursive):** Necessary for copying directories and their contents.
        
    - **-p (Preserve):** Critical. It forces the system to keep the original **mode** (permissions), **ownership** (user/group), and **timestamps**. Without this, the copies would be owned by `root` (the user running the command) and have the current time as the timestamp.
        
- **cp -a (Archive):** An even stronger alternative. It implies `-r` and `-p`, plus it preserves links and SELinux contexts. It is often the preferred choice for full backups.
    
- **{}:** A placeholder for the file name found by `find`.
    
- **;**: Ends the `-exec` command.
  
  
  
  **Question 29**

**Task:** Schedule a one-time task on **ServerB**.

1. Use the `at` command to schedule a job to run at **23:30** (11:30 PM) today.
    
2. The job should create an empty file named `/var/tmp/late_night_check.txt`.
    
3. Verify the job is in the queue.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at).
  
  
  Overall explanation

**Correct Answer:**

1. **Schedule Job:**
    
    1. at 23:30
    
    _The prompt will change to_ `_at>_`_. Type:_
    
    2. touch /var/tmp/late_night_check.txt
    
    _Press_ `_Ctrl+D_` _to save and exit._
    
2. **Verify:**
    
    1. atq
    2. # Output should list a job number and the time 23:30.
    

**Detailed Explanation for Learners:**

- `**at**` **vs** `**cron**`**:** `cron` is for repeating tasks (every day). `at` is for "do this once, later."
    
- **Service Dependency:** Ensure `atd` is running (`systemctl status atd`). If `at` command is missing, install it (`dnf install at -y`).
  
  
  
  **Question 30**

**Task:** Perform a recursive text search on **ServerB**.

1. Search the entire `/var/log` directory structure.
    
2. Find all files containing the string **"error"** (case-insensitive).
    
3. Save the list of matching lines to `/root/error_report.txt`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use grep and regular expressions to analyze text).
  
  
  
  Overall explanation

Correct Answer

1. Execute the Search

2. grep -ri "error" /var/log > /root/error_report.txt

3. Verify

4. head /root/error_report.txt

Detailed Explanation for Learners

- `**-r**` **(Recursive)**  
    The `-r` option tells `grep` to search every subdirectory beneath the specified directory.
    
    Without `-r`, `grep` searches only the files directly inside the specified directory.
    
- `**-i**` **(Ignore Case)**  
    The `-i` option performs a case-insensitive search.
    
    All of the following match:
    
    1. error
    2. Error
    3. ERROR
    4. eRrOr
    
- **Output Redirection (**`**>**`**)**  
    Redirecting the output:
    
    1. > /root/error_report.txt
    
    saves every matching line into a file instead of displaying thousands of lines on the terminal.
    
    This is a common real-world troubleshooting technique when analyzing system logs.
    
- **Understanding Recursive Searches**
    
    Running:
    
    1. grep -ri "error" /var/log
    
    causes `grep` to examine every accessible file beneath `/var/log`.
    
    Rotated log archives such as:
    
    2. *.gz
    
    are treated as binary files and are not searched as plain text.
    
    For compressed logs, use:
    
    3. zgrep
    
    If you want to skip binary files explicitly, add:
    
    4. -I
    
    Also note the distinction:
    
    - `-r` — recursive search without following symbolic links.
        
    - `-R` — recursive search that follows symbolic links.
        
- **Restricting the Search**
    
    On large directory trees, searching only selected files can greatly improve performance.
    
    Search only `.log` files:
    
    1. --include="*.log"
    
    Skip an entire directory:
    
    2. --exclude-dir=<directory>
    
    These options reduce both execution time and the size of the generated report.
    
- **Useful Output Options**
    
    Print only filenames containing matches:
    
    1. grep -rl
    
    Count matching lines per file:
    
    2. grep -rc
    
    Include line numbers:
    
    3. grep -rn
    
    When reviewing log files, line numbers often make the report much easier to investigate.
    
- **Permissions Matter**
    
    Many files under `/var/log` require root privileges.
    
    Running the search as an ordinary user may generate numerous:
    
    1. Permission denied
    
    messages on **stderr**, and those files will not be searched.
    
    If you intentionally want to suppress these errors, redirect **stderr**:
    
    2. 2>/dev/null
    
    Be aware that this hides evidence that parts of the directory tree were inaccessible.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm that the report actually contains results:
    
    1. wc -l /root/error_report.txt
    
    should report a non-zero line count, and:
    
    2. head /root/error_report.txt
    
    should display actual matching log entries. An empty report often indicates that the search was performed without sufficient permissions to read the log files.
