**Question 1**

**Task:** You have forgotten the root password for **ServerC**.

1. Reset the root password to `watchword` to regain access to the system.
    
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

**Task:** Configure **ServerC** to use the YUM repositories hosted on **ServerB** via HTTP.

1. Configure a repository for **BaseOS** at `http://ServerB/dvd/BaseOS`.
    
2. Configure a repository for **AppStream** at `http://ServerB/dvd/AppStream`.
    
3. Disable all other existing repositories to ensure packages are pulled only from ServerB.
    
4. Disable GPG checking for these repositories.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).
  
  
  Overall explanation

Correct Answer

1. Disable All Existing Repositories

2. dnf config-manager --set-disabled "*"

3. Create the Repository File

Create:

1. /etc/yum.repos.d/serverb.repo

Add:

1. [BaseOS_HTTP]
2. name=BaseOS HTTP
3. baseurl=http://ServerB/dvd/BaseOS
4. enabled=1
5. gpgcheck=0

6. [AppStream_HTTP]
7. name=AppStream HTTP
8. baseurl=http://ServerB/dvd/AppStream
9. enabled=1
10. gpgcheck=0

11. Refresh Repository Metadata

12. dnf clean all
13. dnf makecache

14. Verify

List enabled repositories:

1. dnf repolist

Display detailed repository information:

1. dnf repoinfo BaseOS_HTTP

Detailed Explanation

Disable Existing Repositories

1. dnf config-manager --set-disabled "*"

disables every configured repository on the system.

This ensures that **all package installations come exclusively from ServerB**, preventing DNF from contacting subscription repositories, installation media, or other mirrors that could interfere with the task.

To re-enable a repository later:

1. dnf config-manager --set-enabled <repository-id>

Why Two Repository Definitions?

Since RHEL 8, installation media is divided into two independent software trees.

RepositoryContentsBaseOSCore operating system packages (kernel, systemd, glibc, etc.)AppStreamApplications, runtimes, programming languages, databases, modules

Each repository has its own **repodata** directory.

Therefore:

1. http://ServerB/dvd/BaseOS

and

1. http://ServerB/dvd/AppStream

must be configured separately.

Using only:

1. http://ServerB/dvd

does not work because DNF cannot locate repository metadata there.

Why HTTP Repositories?

HTTP repositories are commonly used because one server can provide packages to hundreds of systems simultaneously.

Advantages include:

- no local ISO required
    
- easy central management
    
- compatible with firewalls and proxies
    
- scalable for enterprise environments
    
- identical configuration whether using a simple Apache server or Red Hat Satellite
    

GPG Checking

The task specifies:

1. gpgcheck=0

which disables package signature verification.

Although production systems normally enable GPG checking, many RHCSA lab environments disable it to simplify repository configuration.

Always follow the task requirements.

Repository Metadata Cache

DNF caches repository metadata under:

1. /var/cache/dnf

After changing repository configuration, remove stale metadata:

1. dnf clean all

Then rebuild the cache:

1. dnf makecache

This ensures DNF downloads fresh metadata from ServerB before installing packages.

Verification Commands

Display enabled repositories:

1. dnf repolist

Display all repositories:

1. dnf repolist --all

Show repository details:

1. dnf repoinfo BaseOS_HTTP

A healthy repository shows:

- Enabled: Yes
    
- Correct Base URL
    
- Non-zero package count
    
- Recently downloaded metadata
    

Troubleshooting

HTTP Service Not Running

On ServerB verify:

1. systemctl status httpd

and confirm HTTP is allowed through the firewall:

1. firewall-cmd --list-services

Incorrect Repository Path

Verify the repository metadata exists:

1. curl http://ServerB/dvd/BaseOS/repodata/repomd.xml

Expected result:

- XML document → correct path
    
- 404 → incorrect directory
    
- 403 → permission or SELinux problem
    

Name Resolution Problems

If DNS is unavailable, verify ServerC can resolve ServerB:

1. getent hosts ServerB

If necessary, create an `/etc/hosts` entry.

Cached Metadata

If DNF still uses old information:

1. dnf clean all
2. dnf makecache

Common Mistakes

- Forgetting to disable existing repositories.
    
- Using one repository for both BaseOS and AppStream.
    
- Pointing `baseurl` to `/dvd` instead of `/dvd/BaseOS` or `/dvd/AppStream`.
    
- Forgetting `dnf clean all` after changing repository configuration.
    
- Assuming `dnf repolist` refreshes stale metadata automatically.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. dnf repolist

to confirm only the two HTTP repositories are enabled, then verify package availability with:

1. dnf repoinfo BaseOS_HTTP

or install a small package to prove the repositories are working. Since the configuration is stored in `/etc/yum.repos.d/`, it persists automatically across reboots, but if the repositories are accessed by hostname (`ServerB`), ensure hostname resolution still works after the system restarts.


Question 3:

**Question 3 (Merged Scenario)**

**Task:** Perform system initialization on **ServerC**.

1. **Hostname:** Set the static hostname to `ServerB` (yes, renaming C to B as per the prompt).
    
2. **Boot Target:** Configure the system to boot into the **Multi-User Target** (CLI) by default.
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Hostname), Operate running systems (Boot targets).
  
  
  Overall explanation

Correct Answer

1. Set the Static Hostname

2. hostnamectl set-hostname ServerB

3. Configure the Default Boot Target

4. systemctl set-default multi-user.target

5. Verify

6. hostnamectl
7. systemctl get-default

Detailed Explanation

Setting the Hostname

The command:

1. hostnamectl set-hostname ServerB

sets the **static hostname** and immediately updates the running system.

The hostname is stored in:

1. /etc/hostname

so it automatically persists across reboots.

Static vs. Pretty vs. Transient Hostnames

`hostnamectl` manages three hostname types:

TypePurposeStaticPermanent hostname stored in `/etc/hostname`PrettyHuman-friendly descriptive nameTransientTemporary hostname, often assigned by DHCP

RHCSA tasks always require changing the **static hostname**.

Multi-User Target

The command:

1. systemctl set-default multi-user.target

configures the system to boot into the traditional **text-based server environment**.

This target includes:

- networking
    
- SSH
    
- system services
    
- multiple virtual consoles
    

It does **not** start a graphical desktop.

Multi-User vs. Graphical Target

TargetEquivalent RunlevelDescriptionmulti-user.target3CLI server environmentgraphical.target5Multi-user target plus graphical desktop

Most production servers boot into **multi-user.target** because it consumes fewer resources and reduces the attack surface.

How the Default Target Persists

`systemctl set-default` changes the symbolic link:

1. /etc/systemd/system/default.target

to point at the selected target.

For example:

1. default.target -> /usr/lib/systemd/system/multi-user.target

This symlink is read during every boot, so no additional persistence step is required.

Switching Targets Temporarily

To change the running system **without** changing the default boot target:

1. systemctl isolate multi-user.target

or

1. systemctl isolate graphical.target

`isolate` affects only the current session and does **not** survive a reboot.

Verification

Check the hostname:

1. hostnamectl

or

1. cat /etc/hostname

Verify the default boot target:

1. systemctl get-default

Expected output:

1. multi-user.target

Optionally verify the symlink:

1. ls -l /etc/systemd/system/default.target

Common Mistakes

- Using `hostname ServerB` instead of `hostnamectl set-hostname` (temporary only).
    
- Setting the pretty hostname instead of the static hostname.
    
- Using `systemctl isolate` instead of `systemctl set-default`.
    
- Assuming the shell prompt changes immediately—open a new login session if necessary.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. hostnamectl
2. systemctl get-default

to confirm the configuration, then reboot the system. After reboot, the login prompt should display the new hostname (**ServerB**) and the system should start directly in the **multi-user.target** (text-mode) environment.

**Question 4**

**Task:** On **ServerB** (formerly ServerC), configure the network interface `enp0s3` with the following static settings:

- **Profile Name:** `myprofile6`.
    
- **IPv4:** `192.168.1.7/24`, Gateway: `192.168.1.1`, DNS: `8.8.8.8`.
    
- **IPv6:** `fd01::107/64`, Gateway: `fd01::100`, DNS: `fd01::111`.
    
- **Secondary IPs:** `10.0.0.7/24` (IPv4).
    
- Ensure the connection starts automatically at boot.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).
  
  Overall explanation

Correct Answer

1. Create the Connection Profile

2. nmcli con add con-name myprofile6 ifname enp0s3 type ethernet \
3. ipv4.method manual ipv4.addresses 192.168.1.7/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 \
4. ipv6.method manual ipv6.addresses fd01::107/64 ipv6.gateway fd01::100 ipv6.dns fd01::111

5. Add the Secondary IPv4 Address

6. nmcli con mod myprofile6 +ipv4.addresses 10.0.0.7/24

7. Ensure Autoconnect is Enabled

8. nmcli con mod myprofile6 connection.autoconnect yes

9. Activate the Connection

10. nmcli con up myprofile6

Detailed Explanation

Create Everything in One Step

`nmcli con add` allows you to configure nearly all required network settings while creating the profile.

Using one command is:

- faster
    
- less error-prone
    
- ideal during the RHCSA exam
    

Static IPv4 Configuration

The following properties configure IPv4:

1. ipv4.method manual
2. ipv4.addresses 192.168.1.7/24
3. ipv4.gateway 192.168.1.1
4. ipv4.dns 8.8.8.8

Setting `ipv4.method manual` disables DHCP and tells NetworkManager to use the specified static address.

Static IPv6 Configuration

Similarly,

1. ipv6.method manual
2. ipv6.addresses fd01::107/64
3. ipv6.gateway fd01::100
4. ipv6.dns fd01::111

configure static IPv6 networking.

Without `ipv6.method manual`, NetworkManager typically attempts automatic configuration using SLAAC or DHCPv6.

Adding Secondary Addresses

Secondary addresses are **not** added during profile creation.

Instead, append them afterwards:

1. nmcli con mod myprofile6 +ipv4.addresses 10.0.0.7/24

The leading `**+**` tells NetworkManager to append the address.

Without it:

1. nmcli con mod myprofile6 ipv4.addresses 10.0.0.7/24

the primary address would be overwritten.

The same behavior applies to IPv6 using `+ipv6.addresses`.

NetworkManager Profiles

A NetworkManager profile is a persistent configuration stored under:

1. /etc/NetworkManager/system-connections/

The profile—not the interface—is what the RHCSA grading scripts evaluate.

Using commands like:

1. ip addr add ...

changes only the running kernel configuration and does **not** survive a reboot.

Activation Is Separate from Configuration

Creating or modifying a profile only writes its configuration.

To apply the changes immediately:

1. nmcli con up myprofile6

If you edit profile files manually instead of using `nmcli`, reload them first:

1. nmcli con reload

Autoconnect

Profiles created with `nmcli con add` normally have:

1. connection.autoconnect=yes

However, explicitly configuring it is good practice:

1. nmcli con mod myprofile6 connection.autoconnect yes

Without autoconnect, the profile works immediately after activation but does **not** automatically start after reboot.

Verification

Display the active network configuration:

1. nmcli device show enp0s3

Verify the kernel addresses:

1. ip addr show enp0s3

Verify the default routes:

1. ip route
2. ip -6 route

Confirm automatic startup:

1. nmcli -f connection.autoconnect con show myprofile6

Expected output:

1. yes

Common Mistakes

- Forgetting `ipv4.method manual`.
    
- Forgetting `ipv6.method manual`.
    
- Omitting the `+` when adding secondary addresses.
    
- Forgetting to activate the profile with `nmcli con up`.
    
- Using `ip addr add` instead of configuring the NetworkManager profile.
    
- Forgetting to verify `connection.autoconnect`.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

For networking, confirm:

1. nmcli con show --active
2. nmcli device show enp0s3
3. ip addr show enp0s3
4. ip route
5. ip -6 route
6. nmcli -f connection.autoconnect con show myprofile6

Ensure the secondary IPv4 address appears, the correct gateways and DNS servers are configured, and `connection.autoconnect` reports **yes**. Finally, reboot the system and verify that the profile automatically activates with all settings intact.



**Question 5**

**Task:** Configure kernel networking parameters on **ServerB**.

1. Enable **IPv4** packet forwarding.
    
2. Enable **IPv6** packet forwarding.
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters).
  
  
  Overall explanation

**Correct Answer:**

1. **Create Config:**
    
    - Create `/etc/sysctl.d/99-forwarding.conf`:
        
        1. vim /etc/sysctl.d/99-forwarding.conf
        
2. **Add Settings:**
    
    1. net.ipv4.ip_forward = 1
    2. net.ipv6.conf.all.forwarding = 1
    
3. **Apply:**
    
    1. sysctl -p /etc/sysctl.d/99-forwarding.conf
    

**Detailed Explanation:**

- **Why Forwarding?** This allows the Linux server to act as a router, passing traffic between different network interfaces (e.g., between a physical LAN and a virtual container network).
  
  
  **Question 6**

**Task:** Configure system time settings on **ServerB**.

1. Set the system timezone to **America/Chicago**.
    
2. Configure **NTP** using `chrony` to synchronize the system clock.
    
3. Ensure the `chronyd` service is enabled and running.
    
4. Verify that NTP synchronization is active.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).
  
  
  Overall explanation

Correct Answer

1. Set the Timezone

2. timedatectl set-timezone America/Chicago

3. Install Chrony

4. dnf install chrony -y

5. Enable and Start the Service

6. systemctl enable --now chronyd

7. Enable NTP Synchronization

8. timedatectl set-ntp true

9. Verify

10. timedatectl
11. chronyc sources

Detailed Explanation

Setting the Timezone

The command:

1. timedatectl set-timezone America/Chicago

changes the system's timezone by updating the symbolic link:

1. /etc/localtime

to the appropriate file under:

1. /usr/share/zoneinfo/

This change is persistent across reboots.

To view available timezones:

1. timedatectl list-timezones

or search for one:

1. timedatectl list-timezones | grep Chicago

Timezone names are case-sensitive.

Timezone vs. System Clock

Changing the timezone **does not** change the actual system time.

Linux keeps its internal clock in **UTC** and simply displays it according to the selected timezone.

For example:

- UTC: 18:00
    
- America/Chicago: 13:00
    

Both represent the same instant.

Chrony and NTP

Chrony is the default Network Time Protocol (NTP) implementation in modern RHEL systems.

Unlike older NTP daemons, **chronyd**:

- synchronizes quickly
    
- handles intermittent network connections well
    
- gradually adjusts ("slews") the clock instead of making large jumps
    
- provides excellent accuracy
    

Enabling Chrony

1. systemctl enable --now chronyd

does two things:

- starts the service immediately
    
- enables it at boot
    

Running only:

1. systemctl start chronyd

would work until the next reboot but would not satisfy the persistence requirement.

Enabling NTP

1. timedatectl set-ntp true

tells **systemd-timedated** to manage NTP synchronization.

When Chrony is installed, this enables and coordinates the **chronyd** service.

The list of time servers is configured in:

1. /etc/chrony.conf

Synchronization Is Not Immediate

After enabling NTP, synchronization may take several seconds or even a few minutes.

Initially you may see:

1. System clock synchronized: no

or

1. NTP synchronized: no

After Chrony contacts a valid time source, this changes to:

1. yes

This delay is expected.

Verification

Display overall time status:

1. timedatectl

Typical output includes:

1. Time zone: America/Chicago
2. System clock synchronized: yes
3. NTP service: active

(Some RHEL releases display **NTP synchronized** instead of **System clock synchronized**.)

View available NTP sources:

1. chronyc sources

The currently selected source is marked with:

1. ^*

Display synchronization statistics:

1. chronyc tracking

Verify the service:

1. systemctl status chronyd

or

1. systemctl is-enabled chronyd

Expected output:

1. enabled

Common Mistakes

- Setting the timezone but forgetting to enable Chrony.
    
- Starting **chronyd** without enabling it.
    
- Assuming synchronization is immediate.
    
- Forgetting to install the **chrony** package.
    
- Confusing timezone configuration with clock synchronization.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. timedatectl
2. chronyc sources
3. systemctl is-enabled chronyd

Confirm that:

- the timezone is **America/Chicago**
    
- the **chronyd** service is **enabled** and **active**
    
- the system reports **System clock synchronized: yes** (or **NTP synchronized: yes**)
    
- `chronyc sources` shows at least one reachable source (marked with `^*` once synchronization is established)
    

Finally, reboot the system and verify that the timezone remains unchanged and `chronyd` starts automatically with NTP synchronization active.


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
    
2. Manually assign the **UID** `1234`.
    
3. Configure the account to **expire** on **June 21, 2030** (2030-06-21).
    

- **Aspects/Domains Covered:** Manage users and groups (Create, delete, and modify local user accounts).
  
  Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd -u 1234 -e 2030-06-21 john
    
2. **Verify:**
    
    1. id john
    2. # check uid=1234
    3. chage -l john
    4. # check Account expires: Jun 21, 2030
    

**Detailed Explanation for Learners:**

- **Expiration (**`**-e**`**) vs. Password Aging:**
    
    - **Account Expiration:** The _entire account_ locks on a specific date. Used for temporary contractors.
        
    - **Password Aging:** The _password_ expires after X days, forcing a change. The account remains active.
        
- **Date Format:** YYYY-MM-DD is the standard ISO format accepted by `useradd`.
  
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

Overall explanation

**Correct Answer:**

1. **Create Resources:**
    
    1. touch /tmp/tmpfile
    2. useradd leo
    3. groupadd science
    4. useradd james
    
2. **Set Base Permissions:**
    
    1. chown leo:science /tmp/tmpfile
    2. chmod a+x /tmp/tmpfile
    3. chmod a-w /tmp/tmpfile
    4. # Resulting permissions: r-x r-x r-x
    
3. **Set ACLs:**
    
    1. setfacl -m u:james:rwx /tmp/tmpfile
    
4. **Verify:** `getfacl /tmp/tmpfile`
    
    **Expected Output:**
    
    1. # file: tmp/tmpfile
    2. # owner: leo
    3. # group: science
    4. user::r-x
    5. user:james:rwx
    6. group::r-x
    7. mask::rwx
    8. other::r-x
    

**Detailed Explanation for Learners:**

- **The Mask:** Notice the line `mask::rwx` in the output. When you add a specific user ACL (like `user:james:rwx`), Linux automatically creates a "mask" to accommodate the maximum permission granted to any named user. If this mask were not `rwx`, James would be effectively blocked from writing, regardless of his specific ACL entry.
    
- **Override:** The specific ACL for James overrides the standard restrictions, allowing him full `rwx` access while everyone else (Owner, Group, Others) remains restricted to `r-x`.
  
  **Question 10**

**Task:** Configure **LVM** storage on **ServerB**.

1. Using disk `/dev/sdb`, create a Volume Group named `vg6`. (Create a 4GB partition first if necessary).
    
2. Create a Logical Volume named `lv6` with a size of **2GiB**.
    
3. Format `lv6` with **ext4** and mount it persistently at `/lv6`.
    
4. **Extend** the Logical Volume by **500MiB** and resize the filesystem.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).
  
  
  Overall explanation

Correct Answer

1. Prepare the Disk

2. fdisk /dev/sdb

Inside `fdisk`:

1. n        # New partition
2. Enter
3. Enter
4. +4G
5. t
6. 8e       # Linux LVM (or type 44/LVM on GPT-based fdisk)
7. w

Reload the partition table:

1. partprobe

Create the Physical Volume:

1. pvcreate /dev/sdb1

2. Create the Volume Group and Logical Volume

3. vgcreate vg6 /dev/sdb1
4. lvcreate -n lv6 -L 2G vg6

5. Format and Mount

Create the filesystem:

1. mkfs.ext4 /dev/vg6/lv6

Create the mount point:

1. mkdir /lv6

Add a persistent mount:

1. echo "/dev/vg6/lv6 /lv6 ext4 defaults 0 0" >> /etc/fstab

Mount the filesystem:

1. mount -a

2. Extend the Logical Volume

3. lvextend -r -L +500M /dev/vg6/lv6

Detailed Explanation

Preparing the Disk

LVM requires a **Physical Volume (PV)**.

The sequence is:

1. Disk
2.    ↓
3. Partition
4.    ↓
5. Physical Volume (PV)
6.    ↓
7. Volume Group (VG)
8.    ↓
9. Logical Volume (LV)
10.    ↓
11. Filesystem

After creating the partition, `pvcreate` initializes it for LVM.

Creating the Volume Group

1. vgcreate vg6 /dev/sdb1

creates a storage pool named **vg6**.

Every Logical Volume in this task will allocate space from this pool.

Verify:

1. vgs

or

1. vgdisplay vg6

Creating the Logical Volume

1. lvcreate -n lv6 -L 2G vg6

creates:

- LV name: **lv6**
    
- Size: **2 GiB**
    
- Inside VG: **vg6**
    

The device becomes available as either:

1. /dev/vg6/lv6

or

1. /dev/mapper/vg6-lv6

Both refer to the same device.

Formatting and Mounting

The task specifies **ext4**, so create it with:

1. mkfs.ext4 /dev/vg6/lv6

Create the mount point:

1. mkdir /lv6

Configure persistence by adding an entry to:

1. /etc/fstab

Then verify:

1. mount -a

Always run `mount -a` before rebooting to catch any syntax errors in `/etc/fstab`.

Using UUID (Recommended)

Although the task uses the device path, using the UUID is more reliable because device names can change.

Retrieve it:

1. lsblk -f /dev/vg6/lv6

or

1. blkid /dev/vg6/lv6

Example:

1. UUID=<uuid> /lv6 ext4 defaults 0 0

Extending the Logical Volume

Increase the LV by **500 MiB**:

1. lvextend -r -L +500M /dev/vg6/lv6

The important parts are:

- `+500M` → add 500 MiB to the current size
    
- `-r` → automatically resize the filesystem
    

Without the `+`:

1. -L 500M

the LV would become **exactly 500 MiB**, which is almost certainly not what the task requires.

Why `-r` Is Important

Growing storage actually involves two separate operations:

1. Extend the Logical Volume.
    
2. Extend the filesystem.
    

Without `-r`, only the LV grows.

For ext4, the manual procedure would be:

1. lvextend -L +500M /dev/vg6/lv6
2. resize2fs /dev/vg6/lv6

`lvextend -r` performs both steps automatically.

LVM Components

Verify each layer separately:

Physical Volumes:

1. pvs

Volume Groups:

1. vgs

Logical Volumes:

1. lvs

Filesystem:

1. df -h /lv6

Verification

Confirm the LV size:

1. lvs

Verify the filesystem size:

1. df -h /lv6

Verify the VG still has free space:

1. vgs

Verify the mount:

1. lsblk -f

Common Mistakes

- Forgetting to run `pvcreate`.
    
- Forgetting `mkfs.ext4`.
    
- Forgetting to create the mount point.
    
- Forgetting to update `/etc/fstab`.
    
- Forgetting `mount -a`.
    
- Using `-L 500M` instead of `-L +500M`.
    
- Forgetting the `-r` option and leaving the filesystem unexpanded.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. pvs
2. vgs
3. lvs
4. df -h /lv6
5. mount | grep /lv6

Confirm that:

- the Physical Volume belongs to **vg6**
    
- the Logical Volume **lv6** exists
    
- the LV size has increased from **2 GiB** to **2.5 GiB**
    
- `df -h /lv6` reports the expanded filesystem size
    
- `/lv6` is mounted successfully
    

Finally, run:

1. mount -a

to validate the `/etc/fstab` entry, then reboot and verify that `/lv6` is mounted automatically with the expanded filesystem.




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
  
  
  Overall explanation

Correct Answer

1. Prepare the Physical Volume

Create a partition (if required):

1. fdisk /dev/sdb

Inside `fdisk`:

1. n
2. Enter
3. Enter
4. +4G
5. t
6. 8e       # Linux LVM (or type 44/LVM on GPT-based fdisk)
7. w

Reload the partition table:

1. partprobe

Create the Physical Volume and Volume Group:

1. pvcreate /dev/sdb2
2. vgcreate vg1 /dev/sdb2

3. Create the Thin Pool

4. lvcreate -L 2G --thinpool vg1/thinpool1

5. Create the Thin Volume

6. lvcreate -V 1T -T vg1/thinpool1 -n thinvol1

7. Extend the Thin Pool

8. lvextend -L +500M /dev/vg1/thinpool1

9. Rename the Thin Pool

10. lvrename vg1 thinpool1 thinpool2

11. Rename the Thin Volume

12. lvrename vg1 thinvol1 thinvol2

13. Format and Mount

Create the filesystem:

1. mkfs.xfs /dev/vg1/thinvol2

Create the mount point:

1. mkdir /thinvol2

Configure persistent mounting:

1. echo "/dev/vg1/thinvol2 /thinvol2 xfs defaults 0 0" >> /etc/fstab

Mount the filesystem:

1. mount -a

Detailed Explanation

Preparing the LVM Stack

Thin provisioning uses the normal LVM hierarchy:

1. Disk
2.    ↓
3. Partition
4.    ↓
5. Physical Volume (PV)
6.    ↓
7. Volume Group (VG)
8.    ↓
9. Thin Pool
10.    ↓
11. Thin Volume
12.    ↓
13. Filesystem

The Thin Pool owns the real storage.

The Thin Volume consumes storage from the pool **only as data is written**.

Thin Pool

Create the pool:

1. lvcreate -L 2G --thinpool vg1/thinpool1

The **2 GiB** specifies the actual physical storage allocated from the Volume Group.

The Thin Pool also contains hidden metadata used to track allocated blocks.

Thin Volume

Create the Thin Volume:

1. lvcreate -V 1T -T vg1/thinpool1 -n thinvol1

Notice the difference:

- `-L` → real storage
    
- `-V` → virtual storage presented to the filesystem
    

The filesystem believes it has:

1. 1 TiB

even though only:

1. 2 GiB

actually exists.

This is **thin provisioning**.

Virtual Size vs. Physical Size

The virtual size is simply the maximum address space available.

Initially, almost no storage is consumed.

As data is written:

- blocks are allocated from the Thin Pool
    
- pool usage increases
    
- the filesystem remains unaware of the physical allocation
    

This allows significant over-provisioning.

Extending the Thin Pool

Increase the pool by **500 MiB**:

1. lvextend -L +500M /dev/vg1/thinpool1

Always use:

1. +500M

to add capacity.

Without the `+`, the pool would become exactly **500 MiB**.

Renaming

Both Thin Pools and Thin Volumes are simply Logical Volumes.

Rename the pool:

1. lvrename vg1 thinpool1 thinpool2

Rename the Thin Volume:

1. lvrename vg1 thinvol1 thinvol2

After renaming, all subsequent commands should reference:

1. /dev/vg1/thinvol2

Formatting

Create the XFS filesystem:

1. mkfs.xfs /dev/vg1/thinvol2

Although the virtual size is **1 TiB**, XFS initially consumes only a small amount of actual storage.

Persistent Mount

Create the mount point:

1. mkdir /thinvol2

Configure persistence:

1. /etc/fstab

Always verify:

1. mount -a

before rebooting.

Monitoring Thin Provisioning

Display all logical volumes:

1. lvs

Display Thin Pool utilization:

1. lvs -o lv_name,lv_size,pool_lv,data_percent,metadata_percent

Display Volume Group information:

1. vgs

The important values are:

- **Data%** → percentage of Thin Pool currently used
    
- **Meta%** → metadata usage
    
- **VFree** → remaining free extents in the Volume Group
    

Why `df` Can Be Misleading

Running:

1. df -h /thinvol2

reports the **virtual** filesystem size:

1. 1.0T

This does **not** indicate how much real storage remains.

The actual capacity is determined by the Thin Pool's **Data%**, visible with `lvs`.

Verification

Verify the Thin Pool:

1. lvs

Verify the mounted filesystem:

1. df -h /thinvol2

Verify the mount:

1. mount | grep thinvol2

Verify filesystem type:

1. lsblk -f

Common Mistakes

- Creating a standard Logical Volume instead of a Thin Pool.
    
- Using `-L` instead of `-V` when creating the Thin Volume.
    
- Forgetting the `+` when extending the pool.
    
- Formatting the Thin Pool instead of the Thin Volume.
    
- Forgetting to update `/etc/fstab`.
    
- Assuming `df` reports Thin Pool usage.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. lvs
2. lvs -o lv_name,lv_size,pool_lv,data_percent,metadata_percent
3. vgs
4. df -h /thinvol2
5. mount | grep thinvol2

Confirm that:

- **vg1** exists.
    
- The Thin Pool has been renamed to **thinpool2**.
    
- The Thin Volume has been renamed to **thinvol2**.
    
- The Thin Pool size is **2.5 GiB**.
    
- The Thin Volume reports a virtual size of **1 TiB**.
    
- `/thinvol2` is mounted using **XFS**.
    

Finally, run:

1. mount -a

to validate the `/etc/fstab` entry, then reboot and verify that the Thin Volume mounts automatically.


**Question 12**

**Task:** Optimize **ServerB** for a virtualized environment.

1. Install and enable `tuned`.
    
2. Apply a profile configuration that optimizes for **Virtual Guests** while also prioritizing **low power consumption**. (Combine `virtual-guest` and `powersave`).
    
3. Verify that both profiles are active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).
  
  Overall explanation

**Correct Answer:**

1. **Enable Service:**
    
    1. dnf install tuned -y
    2. systemctl enable --now tuned
    
2. **Apply Profiles:**
    
    1. tuned-adm profile virtual-guest powersave
    
3. **Verify:**
    
    1. tuned-adm active
    2. # Output: Current active profile: virtual-guest powersave
    

**Detailed Explanation for Learners:**

- **Order Matters:** When stacking profiles, the last one listed has priority for conflicting settings. Here, `powersave` will override any performance settings in `virtual-guest` that use too much energy.
  
  **Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server.
    
2. Create an `index.html` file in the default document root containing the text: "Hello World!".
    
3. Configure the firewall to allow **HTTP** and **HTTPS**.
    
4. Ensure the service starts on boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Start services), Manage security (Firewall).
  
  
  Overall explanation

**Correct Answer:**

1. **Install:**
    
    1. dnf install httpd -y
    
2. **Content:**
    
    1. echo "Hello World!" > /var/www/html/index.html
    
3. **Firewall:**
    
    1. firewall-cmd --permanent --add-service={http,https}
    2. firewall-cmd --reload
    
4. **Start:**
    
    1. systemctl enable --now httpd
    
5. **Verify:**
    
    1. curl http://localhost
    

**Detailed Explanation for Learners:**

- **Efficiency:** Use `{service1,service2}` expansion to add multiple firewall rules in one command line.
    
- **Persistence:** Always verify with `systemctl status httpd` to ensure the "Enabled" flag is set.
  
  
  **Question 14**

**Task:** Perform a file search and backup operation on **ServerB**.

1. Create a directory `/find/rootfiles`.
    
2. Find all **regular files** in the `/usr` directory that are owned by the user **root**.
    
3. Copy these files to `/find/rootfiles`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create/copy files, Use find).
  
  
  Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /find/rootfiles
    
2. **Find and Copy:**
    
    1. find /usr -type f -user root -exec cp {} /find/rootfiles/ \;
    

**Detailed Explanation for Learners:**

- `**-type f**`**:** Restricts search to files. Copying directories (`-type d`) without the recursive flag (`cp -r`) would cause errors.
    
- `**-exec**`**:** Executes the copy command for every single file found.
  
  
  **Question 15 (New Topic: Flatpak)**

**Task:** Manage desktop applications on ServerB using Flatpak.

- Configure the **Flathub** remote repository: `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
- Install the application **Calculator** (`org.gnome.Calculator`) from this remote.
    
- Verify the installation.
    

**Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).


Overall explanation

Correct Answer

1. Add the Flathub Remote

2. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

3. Install the Application

4. flatpak install flathub org.gnome.Calculator -y

5. Verify the Installation

6. flatpak list

Detailed Explanation

What Is Flatpak?

Flatpak is a universal application packaging system that installs applications in isolated containers.

Unlike traditional RPM packages, Flatpak applications:

- bundle their own libraries
    
- reduce dependency conflicts
    
- receive independent updates
    
- leave the core operating system largely untouched
    

This makes Flatpak particularly useful for desktop applications on enterprise systems.

The Flathub Remote

A **remote** is the Flatpak equivalent of a DNF repository.

The command:

1. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

registers Flathub as a software source.

The `--if-not-exists` option makes the command idempotent by preventing an error if the remote has already been configured.

You can view configured remotes with:

1. flatpak remotes

Application IDs

Flatpak applications are installed using **Application IDs**, which follow reverse-DNS naming conventions.

Examples:

1. org.gnome.Calculator
2. org.mozilla.firefox
3. org.gimp.GIMP
4. org.libreoffice.LibreOffice

Using the exact Application ID avoids ambiguity and ensures the correct application is installed.

If you do not know the ID, search for it:

1. flatpak search Calculator

System vs. User Installations

Running Flatpak as **root** installs applications system-wide:

1. /var/lib/flatpak

making them available to every user.

Alternatively,

1. flatpak install --user

installs applications only for the current account under:

1. ~/.local/share/flatpak

Since this task specifies only **ServerB** and does not name a particular user, the correct solution is a **system-wide installation**.

Verification

Display configured remotes:

1. flatpak remotes

List installed applications and runtimes:

1. flatpak list

List only installed applications:

1. flatpak list --app

Show the installation scope:

1. flatpak list --app --columns=application,installation

Expected output includes:

1. org.gnome.Calculator    system

Common Mistakes

- Forgetting to add the Flathub remote.
    
- Typing the Application ID incorrectly.
    
- Installing into the user scope (`--user`) when the task expects a system-wide installation.
    
- Forgetting to verify the installation.
    
- Assuming the application name ("Calculator") can be used instead of the Application ID.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. flatpak remotes
2. flatpak list --app
3. flatpak list --app --columns=application,installation

Confirm that:

- the **Flathub** remote is configured
    
- **org.gnome.Calculator** appears in the installed application list
    
- the installation scope is **system**
    

Flatpak installations and remotes are persistent by default, so no additional configuration is required for them to survive a reboot.


**Question 16**

**Task:** Create a shell script named `/sum.sh` in the root directory of ServerB.

- The script should accept an unspecified number of integer arguments (e.g., `./sum.sh 5 10 -3 20`).
    
- It should calculate the sum of all arguments that are **greater than 0**. (Ignore negative numbers or zero).
    
- Print the result in the format: "The sum is [total]".
    
- Make the script executable.
    

**Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, Loops, Conditional logic).


Overall explanation

**Correct Answer:**

1. **Create Script:** `vim /sum.sh`
    
2. **Add Content:**
    
    1. #!/bin/bash
    2. TOTAL=0
    3. for NUM in "$@"
    4. do
    5.   if [ "$NUM" -gt 0 ]; then
    6.     TOTAL=$((TOTAL + NUM))
    7.   fi
    8. done
    9. echo "The sum is $TOTAL"
    
    _(Save and exit with_ `_:wq_`_)_
    
3. **Make Executable:** `chmod +x /sum.sh`
    
4. **Verify:** `./sum.sh 5 10 -3 20` _Output should be 35 (5 + 10 + 20)._
    

**Detailed Explanation for Learners:**

- **"$@":** This special variable expands to "all arguments passed to the script" as a separate list. This allows the `for` loop to iterate through every number you type after the script name.
    
- **-gt 0:** The comparison operator "Greater Than".
    
- **$(( ... )):** Arithmetic expansion. This tells Bash to perform math calculations inside the parentheses.
    
- **Logic:** The `if` statement ensures that negative numbers (like -3) are skipped, and only positive integers are added to the `TOTAL` variable.
  
  
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
  
  
  Overall explanation

**Correct Answer:**

1. **Create Groups/Users:**
    
    1. groupadd Innovation
    2. groupadd Solution
    3. useradd -G Innovation James
    4. useradd -G Innovation Ethan
    5. useradd -G Solution Lucas
    6. useradd -G Solution Oliver
    
2. **Create Directories:**
    
    1. mkdir -p /groups/Innovation /groups/Solution
    
3. **Ownership & Base Permissions:**
    
    1. chown :Innovation /groups/Innovation
    2. chown :Solution /groups/Solution
    3. chmod 2770 /groups/Innovation /groups/Solution
    
4. **Set ACL:**
    
    1. setfacl -m g:Solution:rx /groups/Innovation
    

**Detailed Explanation for Learners:**

- **SGID (**`**chmod 2770**`**):** The `2` sets the SGID bit. This ensures that if James creates a file in `/groups/Innovation`, the file is owned by the group `Innovation`, not James's primary group. This allows Ethan to edit it later.
    
- **ACL:** The ACL grants specific access (`r-x`) to a secondary group (`Solution`) without opening the directory to the whole world ("Others").
  
  
  
  **Question 18**

**Task:** Configure LVM with a custom Physical Extent size on **ServerB**.

1. Using disk `/dev/sdb` (create a partition `sdb2` if needed), create a Volume Group named `myvg`.
    
2. Configure `myvg` to use a **Physical Extent (PE) size of 16MiB**.
    
3. Create a Logical Volume named `mylv` inside this group.
    
4. The LV must contain exactly **50 Extents**.
    
5. Format with **xfs** and mount persistently at `/mnt/mylv`.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Assign physical volumes to volume groups).
  
  
  Overall explanation

Correct Answer

1. Prepare the Disk

Create the partition:

1. fdisk /dev/sdb

Inside `fdisk`:

1. n
2. Enter
3. Enter
4. +4G
5. t
6. 8e       # Linux LVM (or type 44/LVM on GPT-based fdisk)
7. w

Reload the partition table:

1. partprobe

Create the Physical Volume:

1. pvcreate /dev/sdb2

2. Create the Volume Group with a 16 MiB PE Size

3. vgcreate -s 16M myvg /dev/sdb2

4. Create the Logical Volume Using Extents

5. lvcreate -l 50 -n mylv myvg

6. Format and Mount

Create the filesystem:

1. mkfs.xfs /dev/myvg/mylv

Create the mount point:

1. mkdir -p /mnt/mylv

Configure persistent mounting:

1. echo "/dev/myvg/mylv /mnt/mylv xfs defaults 0 0" >> /etc/fstab

Mount the filesystem:

1. mount -a

2. Verify

Verify the Physical Extent size:

1. vgdisplay myvg | grep "PE Size"

Expected output:

1. PE Size               16.00 MiB

Verify the Logical Extents:

1. lvdisplay /dev/myvg/mylv | grep "Current LE"

Expected output:

1. Current LE            50

Detailed Explanation

LVM Allocation Units

LVM allocates storage using **extents**, not individual sectors or megabytes.

The hierarchy is:

1. Disk
2.    ↓
3. Partition
4.    ↓
5. Physical Volume (PV)
6.    ↓
7. Volume Group (VG)
8.    ↓
9. Physical Extents (PE)
10.    ↓
11. Logical Volume (LV)
12.    ↓
13. Logical Extents (LE)
14.    ↓
15. Filesystem

Physical Extents (PE)

A **Physical Extent (PE)** is the smallest allocation unit inside a Volume Group.

By default, LVM uses:

1. 4 MiB

This task requires:

1. vgcreate -s 16M myvg /dev/sdb2

The `-s` (or `--physicalextentsize`) option sets the PE size when the Volume Group is created.

The PE size is a property of the **Volume Group**, not the Physical Volume or Logical Volume.

Logical Extents (LE)

Logical Volumes are allocated using **Logical Extents (LE)**.

For a normal linear LV:

1. 1 LE = 1 PE

Since:

1. PE Size = 16 MiB

and

1. 50 LE

the Logical Volume size becomes:

1. 50 × 16 MiB = 800 MiB

`-l` vs. `-L`

LVM provides two sizing methods.

Specify a size:

1. lvcreate -L 800M ...

Specify extents:

1. lvcreate -l 50 ...

This task explicitly requires **50 Extents**, so `-l` is the correct option.

Although `-L 800M` creates the same size today, it does **not** satisfy the stated requirement.

Percentage Allocation

The `-l` option also supports percentages, for example:

1. lvcreate -l 100%FREE

or

1. lvcreate -l 50%VG

These are useful when the task requests using all remaining space.

Formatting

The task specifies **XFS**, so create it with:

1. mkfs.xfs /dev/myvg/mylv

Persistent Mount

Create the mount point:

1. mkdir -p /mnt/mylv

Configure persistence in:

1. /etc/fstab

Although the device path works, using the UUID is generally more robust:

1. blkid /dev/myvg/mylv

Example:

1. UUID=<uuid> /mnt/mylv xfs defaults 0 0

Always verify the entry:

1. mount -a

before rebooting.

Verification

Check the Volume Group:

1. vgdisplay myvg

Check the Logical Volume:

1. lvdisplay /dev/myvg/mylv

Display concise VG information:

1. vgs -o vg_name,vg_extent_size,vg_extent_count

Display Logical Volumes:

1. lvs

Verify the filesystem:

1. df -h /mnt/mylv

Verify the mount:

1. lsblk -f

Common Mistakes

- Forgetting to specify `-s 16M` during `vgcreate`.
    
- Using `-L 800M` instead of `-l 50`.
    
- Forgetting to create the mount point.
    
- Forgetting to update `/etc/fstab`.
    
- Forgetting `mount -a`.
    
- Assuming the PE size can be changed easily after creating the Volume Group.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. vgdisplay myvg
2. lvdisplay /dev/myvg/mylv
3. vgs -o vg_name,vg_extent_size
4. lvs
5. df -h /mnt/mylv
6. mount | grep /mnt/mylv

Confirm that:

- **PE Size** is **16.00 MiB**.
    
- **Current LE** is **50**.
    
- The Logical Volume size is **800 MiB**.
    
- The filesystem is **XFS**.
    
- `/mnt/mylv` is mounted successfully.
    

Finally, execute:

1. mount -a

to validate the `/etc/fstab` entry, then reboot and verify that `/mnt/mylv` mounts automatically.


**Question 19 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, replace a legacy Cron job with a **Systemd Timer**.

1. Create a script `/usr/local/bin/cleanup.sh` that deletes all **empty files** (not directories) in `/tmp`. Make it executable.
    
2. Create a service unit named `cleanup.service`.
    
3. Create a timer unit named `cleanup.timer` that runs this service **daily at 16:15** (4:15 PM).
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).
  
  Overall explanation

Correct Answer

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/cleanup.sh
3. echo 'find /tmp -type f -empty -delete' >> /usr/local/bin/cleanup.sh
4. chmod +x /usr/local/bin/cleanup.sh

5. Create the Service Unit

Create **/etc/systemd/system/cleanup.service**

1. [Unit]
2. Description=Cleanup Tmp Files

3. [Service]
4. Type=oneshot
5. ExecStart=/usr/local/bin/cleanup.sh

6. Create the Timer Unit

Create **/etc/systemd/system/cleanup.timer**

1. [Unit]
2. Description=Run Cleanup Daily at 16:15

3. [Timer]
4. OnCalendar=*-*-* 16:15:00
5. Unit=cleanup.service

6. [Install]
7. WantedBy=timers.target

8. Activate the Timer

Reload systemd:

1. systemctl daemon-reload

Enable and start the timer:

1. systemctl enable --now cleanup.timer

Detailed Explanation for Learners

Why Replace Cron?

Systemd timers are the modern replacement for many cron jobs.

Compared to cron, they provide:

- Native integration with systemd
    
- Centralized logging through **journalctl**
    
- Dependency management
    
- Automatic handling of missed executions (`Persistent=true`)
    
- More flexible scheduling options
    

For modern RHEL systems, systemd timers are the preferred scheduling mechanism.

Timer Units and Service Units Work Together

A timer **never performs work itself**.

Instead:

1. cleanup.timer
2.         │
3.         ▼
4. cleanup.service
5.         │
6.         ▼
7. /usr/local/bin/cleanup.sh

The timer only decides **when** something runs.

The service defines **what** runs.

Without a matching service, the timer simply expires and nothing happens.

Although matching names (`cleanup.timer` → `cleanup.service`) are paired automatically, explicitly specifying

1. Unit=cleanup.service

is considered best practice and becomes mandatory when the names differ.

Why Type=oneshot?

The script performs one task and exits.

Therefore the service should be:

1. Type=oneshot

Unlike long-running daemons, oneshot services finish successfully after the command exits.

Understanding OnCalendar

The syntax is:

1. DayOfWeek Year-Month-Day Hour:Minute:Second

An asterisk means "every."

This task uses:

1. OnCalendar=*-*-* 16:15:00

Meaning:

- Every year
    
- Every month
    
- Every day
    
- At **16:15:00**
    

Equivalent to the cron entry:

1. 15 16 * * *

Validate the Schedule

Instead of guessing the syntax, validate it:

1. systemd-analyze calendar "*-*-* 16:15:00"

Example output:

1. Normalized form: *-*-* 16:15:00
2. Next elapse: Thu 2026-08-06 16:15:00

If the expression is invalid, systemd immediately reports the error.

Why daemon-reload Is Required

Systemd caches unit files.

Whenever a file is created or modified under:

1. /etc/systemd/system/

reload the cache:

1. systemctl daemon-reload

Without this command:

- new services are invisible
    
- edited services continue using the old version
    

Enable the Timer — Not the Service

Correct:

1. systemctl enable --now cleanup.timer

This performs two actions:

- **enable** → starts automatically after every reboot
    
- **--now** → starts immediately
    

Do **not** enable the service:

1. systemctl enable cleanup.service

That would execute the service at boot but **would not schedule daily execution**.

This is one of the most common mistakes in RHCSA exams.

Testing Without Waiting Until 16:15

You can manually trigger the service:

1. systemctl start cleanup.service

Then verify:

1. find /tmp -type f -empty

or inspect the service status:

1. systemctl status cleanup.service

Verification

List active timers:

1. systemctl list-timers

Include inactive timers:

1. systemctl list-timers --all

Verify the timer is enabled:

1. systemctl is-enabled cleanup.timer

Verify the timer is active:

1. systemctl status cleanup.timer

Review the service log:

1. journalctl -u cleanup.service

Review the timer log:

1. journalctl -u cleanup.timer

Optional Enhancements

A production timer often includes:

1. Persistent=true

If the machine was powered off at 16:15, the job runs immediately after the next boot.

Example:

1. [Timer]
2. OnCalendar=*-*-* 16:15:00
3. Persistent=true

You can also spread execution across multiple systems:

1. RandomizedDelaySec=5m

which prevents hundreds of servers from running simultaneously.

Although useful in production, these options are **not required** unless the exam explicitly asks for them.

Common Mistakes

- Forgetting `systemctl daemon-reload`.
    
- Enabling `cleanup.service` instead of `cleanup.timer`.
    
- Forgetting `WantedBy=timers.target`.
    
- Forgetting `Type=oneshot`.
    
- Creating only the timer without creating the service.
    
- Forgetting to make the script executable (`chmod +x`).
    
- Using an incorrect `OnCalendar` expression.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. systemctl list-timers
2. systemctl is-enabled cleanup.timer
3. systemctl status cleanup.timer
4. journalctl -u cleanup.service

Then manually execute:

1. systemctl start cleanup.service

to confirm the script works correctly.

Finally, reboot the system and verify:

1. systemctl list-timers

still shows **cleanup.timer** scheduled for its next execution.





**Question 20**

**Task:** Perform file archiving on **ServerB**.

1. Create a directory `/Backup`.
    
2. Create a **gzip** compressed tar archive named `/Backup/myhome.tgz`.
    
3. The archive should contain the contents of `/home`.
    
4. **Exclude** all files with the extension `.pdf` from the archive.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files).
  
  
  Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /Backup
    
2. **Create Archive:**
    
    1. tar -czf /Backup/myhome.tgz --exclude='*.pdf' /home
    
3. **Verify:**
    
    1. tar -tf /Backup/myhome.tgz | grep ".pdf"
    2. # Should return empty.
    

**Detailed Explanation for Learners:**

- `**--exclude**`**:** Use quotes `'*.pdf'` to prevent the shell from expanding the wildcard. If you have PDFs in your current directory, the shell might replace `*.pdf` with actual filenames before running the command, which breaks the logic. Quoting passes the literal asterisk to `tar`.
  
  **Question 21**

**Task:** Configure local storage on **ServerB** using standard partitions (not LVM).

1. Create a **2GiB** partition on `/dev/sdb`.
    
2. Format the partition with the **ext4** file system.
    
3. Configure the system to mount this partition automatically at boot under `/mnt/drive`.
    
4. Use the **UUID** to ensure the mount configuration is persistent.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Configure systems to mount file systems).
  
  Overall explanation

Correct Answer

1. Create the Partition

2. fdisk /dev/sdb

Inside `fdisk`:

1. n        # New partition
2. `<Enter>`  # Default partition number
3. `<Enter>`  # Default first sector
4. +2G      # Partition size
5. w        # Write changes

Reload the partition table:

1. partprobe /dev/sdb

2. Format the Partition

3. mkfs.ext4 /dev/sdbX

Replace **X** with the actual partition number (for example, `/dev/sdb1`).

3. Create the Mount Point

4. mkdir -p /mnt/drive

5. Configure Persistent Mounting

Obtain the filesystem UUID:

1. blkid /dev/sdbX

Example:

1. /dev/sdb1: UUID="5d6a7d90-45c2-4ec5-8d73-9b3d5b1fcb55" TYPE="ext4"

Edit **/etc/fstab**:

1. vim /etc/fstab

Add:

1. `UUID=<your-uuid>`   /mnt/drive   ext4   defaults   0 0

2. Verify

Test the configuration:

1. mount -a

Verify the mount:

1. df -h /mnt/drive

Detailed Explanation for Learners

Why Use a Standard Partition?

Not every storage requirement needs LVM.

Standard partitions are:

- Simpler
    
- Faster to configure
    
- Easier to troubleshoot
    
- Common for dedicated disks and removable media
    

This task specifically evaluates your ability to use traditional Linux partitioning tools instead of LVM.

Why Run `partprobe`?

After modifying the partition table, the kernel may still use the old layout.

1. partprobe /dev/sdb

tells the kernel to reread the partition table immediately, avoiding a reboot.

Verify the new partition exists:

1. lsblk

Why UUID Instead of `/dev/sdb1`?

Device names are **not guaranteed**.

For example:

1. Today:
2. /dev/sdb1

3. After adding another disk:
4. /dev/sdc1

If `/etc/fstab` references `/dev/sdb1`, the system may fail to mount the filesystem after hardware changes.

A filesystem UUID is written into the filesystem itself and remains unchanged regardless of device enumeration.

Display UUIDs with:

1. blkid

or

1. lsblk -f

Using:

1. `UUID=<uuid>`

is therefore considered best practice and is commonly expected in RHCSA exams.

Understanding an `/etc/fstab` Entry

Each line contains six fields:

1. Device    MountPoint    Type    Options    Dump    Pass

Example:

1. UUID=5d6a7d90-45c2-4ec5-8d73-9b3d5b1fcb55  /mnt/drive  ext4  defaults  0 0

Meaning:

FieldDescriptionDeviceFilesystem UUIDMount Point`/mnt/drive`Filesystem`ext4`Options`defaults`DumpUsually `0`PassFilesystem check order (`0` = do not fsck during boot)

Using the wrong filesystem type (for example, `xfs` instead of `ext4`) causes the mount to fail.

Why `mount -a` Is Essential

After editing `/etc/fstab`, always run:

1. mount -a

This mounts every unmounted filesystem listed in `/etc/fstab`.

If the command produces **no output**, the configuration is valid.

If an error appears, fix it immediately before rebooting.

A malformed `/etc/fstab` entry can prevent normal boot and drop the system into **emergency mode**.

Useful Verification Commands

Display filesystems and UUIDs:

1. lsblk -f

Show mounted filesystems:

1. df -h

Display the active mount and mount options:

1. findmnt /mnt/drive

Display UUID information:

1. blkid

These commands complement each other:

- **lsblk -f** → filesystem, UUID, and mount point.
    
- **df -h** → confirms the filesystem is mounted and shows usable capacity.
    
- **findmnt** → confirms the actual mount options currently in effect.
    

Common Mistakes

- Forgetting to run `partprobe` after partitioning.
    
- Formatting the wrong partition.
    
- Using `/dev/sdb1` instead of `UUID=` in `/etc/fstab`.
    
- Specifying the wrong filesystem type in `/etc/fstab`.
    
- Forgetting to create the mount point.
    
- Forgetting to test `/etc/fstab` with `mount -a`.
    
- Rebooting before verifying the mount.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. mount -a
2. lsblk -f
3. findmnt /mnt/drive
4. df -h /mnt/drive

If `mount -a` completes without errors and `findmnt` confirms the filesystem is mounted at **/mnt/drive**, reboot the system and verify the mount returns automatically. A correctly configured UUID entry should survive device renumbering and every reboot.


**Question 22**

**Task:** Add swap space to ServerB.

- Create a new partition of **1GiB** on `/dev/sdb`.
    
- Format the partition as swap.
    
- Activate the swap space immediately.
    
- Ensure it persists across reboots using the **UUID**.
    

**Aspects/Domains Covered:** Configure local storage (Add swap to a system non-destructively).

Overall explanation

Correct Answer

1. Create the Swap Partition

2. fdisk /dev/sdb

Inside `fdisk`:

1. n        # New partition
2. `<Enter> `` # Default partition number
3. `<Enter>`  # Default first sector
4. +1G      # Partition size

5. t        # Change partition type
6. 82       # Linux swap (MBR)
7. # (On GPT, choose "Linux swap" from the available partition types.)

8. w        # Write changes

Reload the partition table:

1. partprobe /dev/sdb

2. Format the Partition as Swap

3. mkswap /dev/sdbX

Replace **X** with the actual partition number (for example, `/dev/sdb2`).

3. Configure Persistent Swap

Obtain the UUID:

1. blkid /dev/sdbX

Edit **/etc/fstab**:

1. vim /etc/fstab

Add:

1. `UUID=<your-uuid>`    none    swap    defaults    0 0

2. Activate the Swap Space

Activate all swap entries from **/etc/fstab**:

1. swapon -a

Alternatively, activate only the new partition:

1. swapon /dev/sdbX

2. Verify

Display active swap devices:

1. swapon --show

Verify the total swap:

1. free -h

Detailed Explanation for Learners

What Is Swap?

Swap is disk space used as **virtual memory** when physical RAM becomes scarce.

Instead of terminating processes immediately when memory fills, Linux can move inactive memory pages to swap.

Although swap is much slower than RAM, it improves system stability and supports features such as **hibernation**.

Why Set the Partition Type?

When using **MBR**, swap partitions traditionally use type:

1. 82

On **GPT**, select the **Linux swap** partition type.

Although modern kernels recognize swap by its signature, setting the correct partition type makes the disk layout easier for administrators and tools to understand.

Why `mkswap`?

Unlike a filesystem, swap has its own on-disk format.

1. mkswap /dev/sdb2

creates:

- the swap signature
    
- the swap UUID
    
- metadata used by the kernel
    

Only after running `mkswap` does the partition become usable as swap.

Why Use a UUID?

Swap uses UUIDs for the same reason filesystems do.

Device names may change:

1. Today:
2. /dev/sdb2

3. Tomorrow:
4. /dev/sdc2

The UUID remains constant because it is stored in the swap signature.

Display it with:

1. blkid

or

1. lsblk -f

Using UUIDs prevents boot failures caused by changing device names.

Understanding the `/etc/fstab` Entry

Swap entries differ from filesystem entries:

1. `UUID=<uuid>`    none    swap    defaults    0 0

FieldMeaningDeviceUUID of the swap areaMount Point`none` (swap is not mounted like a filesystem)Type`swap`Options`defaults`Dump`0`Pass`0`

Notice that there is **no mount directory** because swap is managed directly by the kernel.

Activating Swap

Two commands are commonly used.

Activate a single device:

1. swapon /dev/sdb2

Activate every swap entry listed in `/etc/fstab`:

1. swapon -a

For RHCSA, `swapon -a` is particularly useful because it also validates the `/etc/fstab` configuration before rebooting.

Useful Verification Commands

Display active swap devices:

1. swapon --show

Show memory and swap usage:

1. free -h

Show UUID information:

1. blkid /dev/sdb2

Display filesystem and swap information:

1. lsblk -f

These commands complement each other:

- **swapon --show** → lists active swap devices, priorities, and sizes.
    
- **free -h** → shows the total available swap.
    
- **lsblk -f** → confirms the partition type and UUID.
    

Managing Swap Later

Disable swap:

1. swapoff /dev/sdb2

Disable every active swap device:

1. swapoff -a

Re-enable them:

1. swapon -a

Common Mistakes

- Forgetting to run `mkswap`.
    
- Forgetting to reload the partition table with `partprobe`.
    
- Using `/dev/sdb2` instead of `UUID=` in `/etc/fstab`.
    
- Forgetting to activate the swap with `swapon`.
    
- Forgetting to verify using `swapon --show`.
    
- Rebooting before testing the `/etc/fstab` entry.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. swapon --show
2. free -h
3. swapon -a

If `swapon -a` completes without errors and `swapon --show` lists the new partition, reboot the system and verify that the swap area is automatically activated again. A correctly configured UUID entry should survive every reboot and any future device renumbering.

**Question 23**

**Task:** Configure Secure SSH Access on **ServerB**.

1. **User:** Create a user named `john`.
    
2. **Key Setup:** Configure passwordless SSH login for `john` from **ServerA** (or localhost). Generate the key pair and copy it appropriately.
    
3. **Hardening:** Configure the SSH daemon to **disable** `PasswordAuthentication`. (Ensure you have key access first so you don't lock yourself out!).
    
4. **Restart:** Apply the configuration.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure SSH).
  
  
  Overall explanation

Correct Answer

1. Create the User

2. useradd john

(Optional, if a password is needed for `ssh-copy-id`.)

1. passwd john

2. Generate and Copy the SSH Keys

Switch to the user:

1. su - john

Generate an SSH key pair:

1. ssh-keygen -t rsa

Accept the default prompts.

Copy the public key to the target account:

1. ssh-copy-id john@localhost

Exit back to root:

1. exit

2. Configure the SSH Daemon

Edit the configuration:

1. vim /etc/ssh/sshd_config

Set:

1. PasswordAuthentication no

2. Validate the Configuration

Check the effective configuration:

1. sshd -T | grep -i passwordauthentication

Expected output:

1. passwordauthentication no

Perform a syntax check:

1. sshd -t

No output indicates the configuration is valid.

5. Apply the Changes

Restart the SSH daemon:

1. systemctl restart sshd

2. Verify

Test key-based login:

1. ssh john@localhost

The login should succeed without prompting for a password.

To verify that password authentication is disabled:

1. ssh -o PasswordAuthentication=yes \
2.     -o PubkeyAuthentication=no \
3.     john@localhost

Expected result:

1. Permission denied (publickey).

Detailed Explanation for Learners

Why Use Key-Based Authentication?

SSH keys are significantly more secure than passwords.

Instead of proving your identity with something you **know** (a password), you authenticate with something you **possess** (your private key).

Benefits include:

- Resistant to brute-force attacks
    
- No passwords transmitted over the network
    
- Faster authentication
    
- Recommended for servers and automation
    

How SSH Keys Work

Generating a key pair creates:

1. ~/.ssh/id_rsa

Private key (keep secret)

and

1. ~/.ssh/id_rsa.pub

Public key (safe to distribute)

The public key is copied to the server inside:

1. ~/.ssh/authorized_keys

During login:

1. The server sends a challenge.
    
2. The client signs it using the private key.
    
3. The server verifies it using the public key.
    
4. If the signatures match, login succeeds.
    

The private key never leaves the client.

Why `ssh-copy-id`?

Although you can manually copy the public key, `ssh-copy-id` performs several important tasks automatically:

- Creates `~/.ssh` if necessary.
    
- Creates `authorized_keys`.
    
- Sets the correct permissions.
    
- Prevents duplicate keys.
    

Required permissions are:

1. ~/.ssh            700
2. authorized_keys  600

Incorrect permissions cause SSH to ignore the keys.

Verify with:

1. ls -ld ~/.ssh
2. ls -l ~/.ssh/authorized_keys

Validate Before Restarting

Never restart `sshd` without validating the configuration.

Display the effective configuration:

1. sshd -T

Unlike simply reading `sshd_config`, this command processes:

- `/etc/ssh/sshd_config`
    
- every file included from `/etc/ssh/sshd_config.d/`
    

This makes it the authoritative view of the running configuration.

To confirm the setting required by this task:

1. sshd -T | grep passwordauthentication

Check the Syntax

Before restarting:

1. sshd -t

If the configuration is valid, the command produces no output.

If a syntax error exists, SSH reports the offending file and line number without stopping the running daemon.

Avoid Locking Yourself Out

Always follow this order:

1. Create the user.
    
2. Generate SSH keys.
    
3. Copy the public key.
    
4. Verify key-based login works.
    
5. Keep your current SSH session open.
    
6. Disable password authentication.
    
7. Validate the configuration.
    
8. Restart `sshd`.
    
9. Test from a second terminal.
    

Never disable password authentication before confirming that key-based authentication works.

Prefer Ed25519 for New Systems

The example uses RSA because it is universally compatible:

1. ssh-keygen -t rsa

For modern systems, however, Ed25519 is generally preferred:

1. ssh-keygen -t ed25519

Advantages include:

- Smaller keys
    
- Faster authentication
    
- Strong security
    
- No key-size selection required
    

If RSA is required, use at least a 3072-bit key:

1. ssh-keygen -t rsa -b 3072

Both satisfy RHCSA objectives unless a specific key type is requested.

Useful Verification Commands

Check whether SSH starts automatically at boot:

1. systemctl is-enabled sshd

Check service status:

1. systemctl status sshd

Display the effective configuration:

1. sshd -T

Check syntax:

1. sshd -t

Test SSH locally:

1. ssh john@localhost

Common Mistakes

- Disabling password authentication before testing SSH keys.
    
- Forgetting to copy the public key.
    
- Incorrect permissions on `~/.ssh` or `authorized_keys`.
    
- Restarting `sshd` without running `sshd -t`.
    
- Assuming the configuration file is correct without checking `sshd -T`.
    
- Closing the only SSH session before verifying the new configuration.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. sshd -T | grep passwordauthentication
2. sshd -t
3. systemctl is-enabled sshd
4. systemctl status sshd

Then open a **new terminal** and verify that **john** can log in using the SSH key. Finally, reboot the system and test again. If key-based authentication still works and password authentication remains disabled, the task is complete.

**Question 24**

**Task:** Configure system identity and name resolution on **ServerB**.

1. Set the hostname to `rhel.server.com` persistently.
    
2. Update `/etc/hosts` to ensure that `rhel.server.com` resolves to:
    
    - The loopback address `127.0.0.1`.
        
    - The network address `192.168.1.6`.
        

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).
  
  
  Overall explanation

**Correct Answer:**

1. **Set Hostname:**
    
    1. hostnamectl set-hostname rhel.server.com
    
2. **Edit Hosts:**
    
    1. vim /etc/hosts
    
    - Add/Modify:*
        
        1. 127.0.0.1   localhost localhost.localdomain rhel.server.com
        2. 192.168.1.6 rhel.server.com
        

**Detailed Explanation for Learners:**

- **Split Resolution:** It is common to map the hostname to both the external IP (for network traffic) and the loopback IP (for internal system communication). This ensures that if the network cable is unplugged, the server can still talk to itself using its own name.
  
  **Question 25**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux mode.
    
2. Set the system to **Enforcing** mode.
    
3. Ensure the system remains in Enforcing mode after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).
  
  Overall explanation

Correct Answer

1. Check the Current SELinux Mode

2. getenforce

Or view detailed status:

1. sestatus

2. Set the Runtime Mode

3. setenforce 1

4. Configure Persistent Mode

Edit the SELinux configuration:

1. vim /etc/selinux/config

Set:

1. SELINUX=enforcing

2. Verify

Confirm the current mode:

1. getenforce

Expected output:

1. Enforcing

Confirm both the current and persistent modes:

1. sestatus

Detailed Explanation for Learners

SELinux Modes

SELinux operates in three modes:

ModeBehavior**Enforcing**Enforces the SELinux policy. Unauthorized actions are blocked and logged.**Permissive**Does not block violations but logs them for troubleshooting.**Disabled**SELinux is completely turned off. No policy is loaded or enforced.

Think of them as:

- **Enforcing** → Security guard stops unauthorized actions.
    
- **Permissive** → Security guard records violations but allows them.
    
- **Disabled** → No security guard at all.
    

Runtime vs. Persistent Configuration

This task has **two independent requirements**.

Runtime Change

1. setenforce 1

Changes the running kernel immediately.

The change is **temporary** and is lost after a reboot.

Persistent Change

1. SELINUX=enforcing

inside:

1. /etc/selinux/config

determines the SELinux mode at every boot.

Editing the file alone **does not** affect the running system until the next reboot.

Therefore, RHCSA tasks that ask for both immediate and persistent enforcement require **both** actions.

What `getenforce` Shows

1. getenforce

Outputs only the **current runtime mode**:

1. Enforcing

It does **not** indicate what will happen after reboot.

Why `sestatus` Is Better

1. sestatus

Displays both:

- Current mode
    
- Mode from configuration file
    

For example:

1. Current mode:                   enforcing
2. Mode from config file:          enforcing

One command confirms both the runtime and persistent configurations.

What If SELinux Is Disabled?

`setenforce` cannot enable SELinux if it was booted with:

1. SELINUX=disabled

In that situation:

1. Edit:
    

2. /etc/selinux/config

3. Change:
    

4. SELINUX=enforcing

5. Reboot.
    

During the first boot, the system performs a complete filesystem relabel, which may take several minutes.

This is expected behavior.

Useful Verification Commands

Check the runtime mode:

1. getenforce

Display complete SELinux status:

1. sestatus

Verify the configuration file:

1. grep ^SELINUX= /etc/selinux/config

These commands complement one another:

- **getenforce** → current runtime mode.
    
- **sestatus** → runtime mode and persistent configuration.
    
- **grep** → confirms the configuration file contains the expected setting.
    

Related RHCSA Pattern

Many RHCSA objectives have separate **runtime** and **persistent** configurations.

Examples include:

TaskRuntimePersistentSELinux mode`setenforce/etc/selinux/config`SELinux boolean`setseboolsetsebool -P`Firewall`firewall-cmdfirewall-cmd --permanent`Mounts`mount/etc/fstab`

Recognizing this pattern helps avoid losing points on persistence-related tasks.

Common Mistakes

- Running only `setenforce 1`.
    
- Editing `/etc/selinux/config` without changing the running mode.
    
- Using `getenforce` alone to verify persistence.
    
- Forgetting that `setenforce` cannot enable a disabled SELinux system.
    
- Rebooting without checking the configuration.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. getenforce
2. sestatus
3. grep ^SELINUX= /etc/selinux/config

Then reboot the system and run:

1. sestatus

If both **Current mode** and **Mode from config file** report **enforcing**, the task has been completed successfully.


**Question 26**

**Task:** Configure **VDO** (Virtual Data Optimizer) for efficient storage on ServerB.

- Using disk `/dev/sde` (create a partition if needed), create a Volume Group named `vdovg`.
    
- Create a **VDO Logical Volume** named `myvdo` inside this group.
    
- Set the **Physical Size** (space taken on disk) to **5GiB**.
    
- Set the **Logical/Virtual Size** (space presented to user) to **50GiB**.
    
- Format with **xfs** and mount persistently at `/vdo`.
    
- Ensure the mount configuration is correct and efficient.
    

**Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - VDO/Thin Provisioning).

Overall explanation

Correct Answer

1. Install the Required Packages

2. dnf install -y lvm2 vdo

**Note:** Modern RHEL manages VDO through LVM, but the **vdo** package supplies the utilities (`vdoformat`) required during VDO creation.

2. Prepare the Physical Volume and Volume Group

If using the entire disk:

1. pvcreate /dev/sde
2. vgcreate vdovg /dev/sde

If the task requires a partition first:

1. fdisk /dev/sde
2. partprobe /dev/sde
3. pvcreate /dev/sde1
4. vgcreate vdovg /dev/sde1

5. Create the VDO Logical Volume

6. lvcreate --type vdo \
7.   --name myvdo \
8.   --size 5G \
9.   --virtualsize 50G \
10.   vdovg

11. Format the Filesystem

12. mkfs.xfs /dev/vdovg/myvdo

13. Create the Mount Point

14. mkdir -p /vdo

15. Configure Persistent Mounting

Using the device path:

1. /dev/vdovg/myvdo    /vdo    xfs    defaults    0 0

**Recommended (Best Practice):** Use the filesystem UUID.

Obtain the UUID:

1. blkid /dev/vdovg/myvdo

Example `/etc/fstab` entry:

1. UUID=<your-uuid>    /vdo    xfs    defaults    0 0

Apply the configuration:

1. mount -a

2. Verify

Confirm the mount:

1. df -h /vdo

Verify VDO features:

1. lvs -o+vdo_compression,vdo_deduplication

Display VDO statistics:

1. vdostats --human-readable

Detailed Explanation for Learners

What Is VDO?

**Virtual Data Optimizer (VDO)** reduces storage consumption by combining:

- Zero-block elimination
    
- Deduplication
    
- Compression
    

Applications see a large logical disk, while VDO stores much less physical data whenever possible.

Why Is VDO Managed Through LVM?

Beginning with **RHEL 9**, VDO became a native LVM segment type.

Instead of using the legacy `vdo create` command, you now create VDO volumes using:

1. lvcreate --type vdo

This integrates VDO with:

- LVM snapshots
    
- Volume groups
    
- Logical volume management
    
- Standard LVM administration tools
    

Understanding Physical vs. Virtual Size

This command:

1. lvcreate --type vdo \
2.   --size 5G \
3.   --virtualsize 50G

creates two different capacities.

OptionMeaning`--size 5G`Real storage allocated from the volume group`--virtualsize 50G`Capacity presented to applications

Applications believe they have a **50 GiB** disk even though only **5 GiB** is physically reserved.

How VDO Saves Space

Every write passes through three stages:

1. Application
2.       │
3.       ▼
4. Zero-block elimination
5.       │
6.       ▼
7. Deduplication
8.       │
9.       ▼
10. Compression
11.       │
12.       ▼
13. Physical disk

Only the optimized data is written to disk.

Deduplication

VDO stores fingerprints of previously written 4 KiB blocks.

If a block already exists:

- No new copy is written.
    
- VDO simply references the existing block.
    

This is extremely effective for:

- Virtual machine images
    
- Container layers
    
- Backups
    
- Repeated operating system files
    

It provides little benefit for:

- Encrypted files
    
- Videos
    
- Random binary data
    

Compression

After deduplication, remaining blocks are compressed using **LZ4**.

LZ4 is designed for:

- Very high speed
    
- Low CPU overhead
    
- Good compression ratio
    

Compression and deduplication operate independently and are enabled by default.

Why the Physical Size Must Be at Least 5 GiB

VDO stores metadata, including:

- Block maps
    
- Deduplication index (UDS)
    

These structures consume several gigabytes.

Because of this overhead, RHEL requires approximately **5 GiB** of physical storage before user data can be stored.

A newly created VDO volume therefore reports some space already in use.

This is expected.

Monitoring VDO Usage

Check VDO status:

1. vdostats --human-readable

Verify compression and deduplication:

1. lvs -o+vdo_compression,vdo_deduplication

Display mounted capacity:

1. df -h /vdo

Remember:

- **df** reports the **virtual** capacity.
    
- **vdostats** reports the **actual physical** usage.
    

Always monitor the physical usage to avoid exhausting the backing store.

Why Use UUID in `/etc/fstab`?

Although this answer uses:

1. /dev/vdovg/myvdo

the recommended RHCSA practice is:

1. UUID=<uuid>

The UUID remains constant even if device names change, making the mount configuration more robust.

Common Mistakes

- Forgetting to install the **vdo** package.
    
- Creating a normal logical volume instead of `--type vdo`.
    
- Confusing physical size with virtual size.
    
- Using less than 5 GiB for the physical size.
    
- Forgetting to format the filesystem.
    
- Forgetting to add the mount to `/etc/fstab`.
    
- Forgetting to test the configuration with `mount -a`.
    
- Relying only on `df`, which reports the virtual size rather than actual physical usage.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. lvs -o+vdo_compression,vdo_deduplication
2. vdostats --human-readable
3. mount -a
4. df -h /vdo

Finally, reboot the system and verify that:

- `/vdo` mounts automatically.
    
- `vdostats` reports healthy physical usage.
    
- Compression and deduplication remain enabled.
    

For VDO tasks, `**vdostats**` **is more meaningful than** `**df**`, because `df` reports the **virtual filesystem size**, not the actual physical space consumed.

**Question 27**

**Task:** Configure Firewall Rich Rules on **ServerB**.

1. Allow **SSH** traffic from the trusted network `192.168.1.0/24`.
    
2. **Reject** SSH traffic from all other sources.
    
3. Ensure the configuration is permanent.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewalld).
  
  
  Overall explanation

Correct Answer

1. Remove the Standard SSH Service (Recommended)

2. firewall-cmd --permanent --remove-service=ssh

This prevents the default SSH service from allowing connections from every source.

2. Allow SSH from the Trusted Network

3. firewall-cmd --permanent \
4. --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'

5. Reject SSH from All Other IPv4 Sources

6. firewall-cmd --permanent \
7. --add-rich-rule='rule family="ipv4" service name="ssh" reject'

8. Reload the Firewall

9. firewall-cmd --reload

10. Verify

11. firewall-cmd --list-rich-rules

12. firewall-cmd --list-services

13. firewall-cmd --list-all

Detailed Explanation for Learners

Why Remove the Standard SSH Service?

If the zone already contains:

1. firewall-cmd --permanent --add-service=ssh

then SSH is allowed from **every IP address**.

Adding an allow rich rule alone does **not** restrict existing access.

Removing the standard service ensures the rich rules become the only policy governing SSH access.

How Rich Rules Work

Rich rules allow much more granular control than ordinary services.

For example, you can match:

- Source networks
    
- Destination addresses
    
- Ports
    
- Protocols
    
- Interfaces
    
- Logging
    
- Rate limits
    
- Accept, reject, or drop actions
    

This task uses source-address matching.

Why Two Rules Are Required

The first rule:

1. Trusted subnet
2.         │
3.         ▼
4. Accept SSH

The second rule:

1. Everyone else
2.         │
3.         ▼
4. Reject SSH

Together they implement:

1. 192.168.1.0/24  ─────► ACCEPT

2. Everything else ─────► REJECT

Without the reject rule, behavior depends on the zone's default policy, which may not explicitly deny SSH.

How firewalld Evaluates Rules

Firewalld does **not** simply read rules from top to bottom.

Within a zone, evaluation follows a defined order:

1. Rich rules with explicit priorities
    
2. Port forwarding rules
    
3. Rich rules
    
4. Services
    
5. Ports
    
6. Zone target (default policy)
    

Because ordinary services are evaluated separately, leaving the standard SSH service enabled can unintentionally allow all SSH traffic.

Removing it eliminates ambiguity.

Reject vs. Drop

Two common blocking actions exist.

**Reject**

1. Client ──► Firewall
2.            │
3.            └──► "Connection rejected"

The client immediately knows access is denied.

**Drop**

1. Client ──► Firewall
2.            │
3.            └──► (Silently discard)

The client waits until the connection times out.

For administration, **reject** is usually preferable because failures occur immediately and are easier to troubleshoot.

Runtime vs. Permanent Configuration

Firewalld maintains two configurations:

- Runtime
    
- Permanent
    

Commands with `--permanent` modify only the permanent configuration.

Changes do **not** affect the running firewall until:

1. firewall-cmd --reload

Alternatively, omit `--permanent` to modify only the runtime configuration.

For RHCSA tasks requesting persistence, always use:

1. --permanent

followed by:

1. firewall-cmd --reload

Verification

List rich rules:

1. firewall-cmd --list-rich-rules

Verify the SSH service is no longer enabled:

1. firewall-cmd --list-services

Display the complete active zone:

1. firewall-cmd --list-all

Verify the permanent configuration:

1. firewall-cmd --permanent --list-rich-rules

2. firewall-cmd --permanent --list-services

Matching runtime and permanent output confirms the configuration will survive a reboot.

Common Mistakes

- Leaving the standard SSH service enabled.
    
- Forgetting `--permanent`.
    
- Forgetting `firewall-cmd --reload`.
    
- Typing the wrong CIDR prefix.
    
- Using `drop` when the task explicitly requests `reject`.
    
- Editing the wrong active firewall zone.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Run:

1. firewall-cmd --list-rich-rules
2. firewall-cmd --permanent --list-rich-rules
3. firewall-cmd --list-services
4. firewall-cmd --permanent --list-services

The runtime and permanent configurations should match.

If possible, test from a **second SSH session**:

- A client inside **192.168.1.0/24** should connect successfully.
    
- A client outside that network should receive an immediate **connection rejected** response.
  
  **Question 28**

**Task:** Configure global user environment settings on **ServerB**.

1. **Variable:** Create a system-wide environment variable named `VAR` with the value `RHCSA`. Ensure it is accessible to all users.
    
2. **History:** Configure the system so that the Bash history file size (`HISTFILESIZE`) is set to **2000** lines for all users.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Environment variables), Operate running systems.
  
  Overall explanation

**Correct Answer:**

1. **Configure** `**/etc/profile**` **(or** `**/etc/bashrc**`**):**
    
    1. vim /etc/profile.d/custom_env.sh
    
    - Add content:*
        
        1. export VAR="RHCSA"
        2. export HISTFILESIZE=2000
        
2. **Verify:**
    
    1. source /etc/profile.d/custom_env.sh
    2. echo $VAR
    3. echo $HISTFILESIZE
    

**Detailed Explanation for Learners:**

- `**/etc/profile.d/**`**:** It is cleaner to create a new file (must end in `.sh`) in this directory than to edit the main configuration files.
    
- `**HISTFILESIZE**`**:** Controls how many lines are saved to `~/.bash_history` when you log out. `HISTSIZE` controls how many are remembered in the current RAM session.
  
  
  **Question 29**

**Task:** Configure an FTP server with SELinux integration on ServerB.

- Install and start the **vsftpd** service.
    
- Configure the firewall to allow **FTP** traffic.
    
- **SELinux:** Configure the boolean `ftpd_full_access` to allow the FTP daemon to read/write files.
    
- Ensure the boolean setting persists across reboots.
    

**Aspects/Domains Covered:** Manage security (Use boolean settings to modify system SELinux settings, Configure firewall settings), Deploy, configure, and maintain systems (Start services).


Overall explanation

Correct Answer

1. Install and Start the FTP Server

2. dnf install -y vsftpd
3. systemctl enable --now vsftpd

4. Configure the Firewall

5. firewall-cmd --permanent --add-service=ftp
6. firewall-cmd --reload

7. Configure the SELinux Boolean

8. setsebool -P ftpd_full_access on

(Using `1` instead of `on` is equally valid.)

4. Verify

5. systemctl status vsftpd

6. firewall-cmd --list-services

7. getsebool ftpd_full_access

Expected output:

1. ftpd_full_access --> on

Detailed Explanation for Learners

Why Install vsftpd?

**vsftpd** (Very Secure FTP Daemon) is the default FTP server shipped with RHEL.

After installation:

1. systemctl enable --now vsftpd

does two things:

- **enable** → starts automatically after every reboot.
    
- **--now** → starts immediately.
    

Firewall Configuration

FTP uses:

- TCP **21** (control connection)
    

Adding the predefined service is preferable to opening ports manually:

1. firewall-cmd --permanent --add-service=ftp
2. firewall-cmd --reload

Using the service automatically opens the required control port and follows the distribution's service definition.

Verify:

1. firewall-cmd --list-services

You should see:

1. ftp

SELinux and FTP

Even if:

- Linux permissions are correct
    
- The firewall is open
    
- vsftpd is running
    

SELinux may still deny access.

This is because the FTP daemon runs in the **ftpd_t** SELinux domain, which is intentionally restricted.

What a Boolean Actually Is

SELinux policy is compiled and cannot normally be modified while the system is running.

Booleans are predefined switches built into that policy.

Changing:

1. setsebool -P ftpd_full_access on

does **not** create new policy.

Instead, it enables an existing rule already included in the SELinux policy.

This is why booleans are the preferred solution instead of disabling SELinux.

Why `ftpd_full_access` Exists

By default, FTP is heavily confined because it has historically been a high-risk service.

Without this boolean, the FTP daemon can access only limited content (such as files labeled `public_content_t`) and is prevented from writing to most locations.

Enabling:

1. ftpd_full_access

allows the FTP daemon broad filesystem read/write access.

This is useful in lab environments and RHCSA exam scenarios.

For production systems, narrower booleans such as:

- `ftpd_anon_write`
    
- `ftpd_use_nfs`
    
- `ftpd_use_cifs`
    

are generally preferred when they satisfy the requirement.

Why `-P` Is Mandatory

Without `-P`:

1. setsebool ftpd_full_access on

changes only the **running** SELinux policy.

After a reboot:

1. off

returns automatically.

Using:

1. setsebool -P ftpd_full_access on

writes the change into the SELinux policy store, making it persistent.

The command may take several seconds because SELinux rebuilds the policy database.

Verification

Check the current value:

1. getsebool ftpd_full_access

List all FTP-related booleans:

1. getsebool -a | grep ftp

View both the current and persistent values:

1. semanage boolean -l | grep ftpd_full_access

Typical output:

1. ftpd_full_access    (on , on)

The two values mean:

- First → current runtime state
    
- Second → persistent boot-time state
    

If you see:

1. (on , off)

you forgot the `-P` option.

Service Verification

Confirm the daemon is running:

1. systemctl status vsftpd

or

1. systemctl is-enabled vsftpd
2. systemctl is-active vsftpd

Expected results:

1. enabled
2. active

Common Mistakes

- Forgetting `--permanent` when opening the firewall.
    
- Forgetting `firewall-cmd --reload`.
    
- Using `setsebool` without `-P`.
    
- Assuming Linux file permissions alone are sufficient.
    
- Restarting vsftpd unnecessarily after changing only a SELinux boolean (the boolean takes effect immediately).
    

Exam Tip

Before moving on, verify **service**, **firewall**, **SELinux**, and **persistence**.

Run:

1. systemctl is-enabled vsftpd
2. systemctl is-active vsftpd
3. firewall-cmd --list-services
4. getsebool ftpd_full_access
5. semanage boolean -l | grep ftpd_full_access

The ideal verification is:

- `vsftpd` is **enabled** and **active**
    
- `ftp` appears in the firewall services
    
- `ftpd_full_access` is **on**
    
- `semanage boolean -l` shows **(on, on)**, confirming the setting will survive a reboot.
  
  
  **Question 30**

**Task:** Manage the Kernel and Bootloader on **ServerB**.

1. **List:** Identify the index numbers of all installed kernels.
    
2. **Set Default:** Set the default boot kernel to the entry at **Index 1** (the previous kernel).
    
3. **Modify Args:** Remove the `quiet` argument from the kernel boot parameters for **all** installed kernels.
    

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).
  
  Overall explanation

Correct Answer

1. List Installed Kernel Entries

2. grubby --info=ALL | grep index

3. Set the Default Kernel to Index 1

4. grubby --set-default-index=1

5. Remove the `quiet` Boot Argument from All Kernels

6. grubby --update-kernel=ALL --remove-args="quiet"

7. Verify

8. grubby --info=DEFAULT

Detailed Explanation for Learners

Why Use `grubby`?

`grubby` is the standard RHEL utility for managing kernel boot entries safely.

It can:

- List installed kernels
    
- Change the default boot kernel
    
- Add or remove kernel parameters
    
- Modify one kernel or every installed kernel
    

Unlike manually editing GRUB files, `grubby` updates the correct bootloader metadata automatically.

Understanding Kernel Indexes

Display all kernel entries:

1. grubby --info=ALL

Typical output:

1. index=0
2. kernel=/boot/vmlinuz-5.14.0-570.el10.x86_64

3. index=1
4. kernel=/boot/vmlinuz-5.14.0-503.el10.x86_64

5. index=2
6. kernel=/boot/vmlinuz-5.14.0-427.el10.x86_64

Normally:

IndexMeaning0Newest kernel1Previous kernel2Older kernel

The numbering is **dynamic**.

Installing a new kernel changes every index.

For scripts, selecting by kernel path is often safer than selecting by index.

Setting the Default Kernel

This task asks specifically for **Index 1**.

1. grubby --set-default-index=1

You can verify:

1. grubby --default-kernel

Alternatively, specify the kernel directly:

1. grubby --set-default /boot/vmlinuz-<version>

Selecting by path avoids problems if kernel indexes later change.

Removing Kernel Arguments

Kernel parameters appear on the GRUB command line.

Example:

1. ro crashkernel=auto quiet rhgb

This task removes only:

1. quiet

using:

1. grubby --update-kernel=ALL --remove-args="quiet"

Notice:

- `ALL` modifies every installed kernel.
    
- `DEFAULT` modifies only the default kernel.
    
- A kernel path modifies only one kernel.
    

Using `ALL` prevents future boots from unexpectedly restoring the removed argument.

What Does `quiet` Do?

The `quiet` parameter suppresses most boot messages.

With it:

1. Boot...
2. Starting...

Without it:

1. Loading kernel...
2. Initializing devices...
3. Starting systemd...
4. Mounting filesystems...

Removing `quiet` is useful when:

- Troubleshooting boot problems
    
- Debugging hardware initialization
    
- Watching service startup
    

`grubby` vs `grub2-mkconfig`

Many administrators confuse these tools.

**grubby**

- Modifies kernel entries directly.
    
- Preserves existing bootloader configuration.
    
- No need to regenerate `grub.cfg`.
    

**grub2-mkconfig**

- Rebuilds the entire GRUB configuration.
    
- Reads `/etc/default/grub`.
    
- Can overwrite manual changes if they aren't reflected in the GRUB defaults.
    

For RHCSA bootloader tasks involving kernel arguments or default kernels, **grubby** is the preferred tool.

Why Roll Back to an Older Kernel?

RHEL installs new kernels **alongside** older ones instead of replacing them.

This provides a recovery path if:

- a new kernel has a driver regression,
    
- a third-party kernel module fails,
    
- the system becomes unstable after an update.
    

Selecting Index 1 simulates rolling back to the previously known-good kernel.

Verification

Check the default kernel:

1. grubby --default-kernel

Display its full configuration:

1. grubby --info=DEFAULT

Look for the **args=** line and confirm:

- `quiet` is absent.
    
- The correct kernel is selected.
    

After reboot:

1. uname -r

confirms which kernel is running.

Check the running kernel command line:

1. cat /proc/cmdline

The `quiet` argument should no longer appear.

Common Mistakes

- Assuming Index 1 is always the previous kernel without checking.
    
- Using `--update-kernel=DEFAULT` instead of `ALL`.
    
- Forgetting to verify the `args=` line.
    
- Editing `/boot/grub2/grub.cfg` manually.
    
- Forgetting to reboot before verifying the running kernel.
    

Exam Tip

Before moving on, verify both the **bootloader configuration** and the **running kernel**.

Run:

1. grubby --default-kernel
2. grubby --info=DEFAULT

Then reboot and verify:

1. uname -r
2. cat /proc/cmdline

The default kernel should now be **Index 1**, and the running kernel command line should **not** contain the `quiet` parameter.