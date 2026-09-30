**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `mypass` to regain access to the system.
    
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

**Task:** Configure a local DNF repository on **ServerB** using the provided ISO image `/RHEL10.iso`.

1. Create the directory `/mnt/disc`.
    
2. Mount the ISO to `/mnt/disc` persistently (automatically at boot).
    
3. Configure a repository file to install packages from **BaseOS** and **AppStream** within the ISO.
    
4. Enable GPG checking using the key at `/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories), Configure local storage (Mount file systems at boot).
  
  Overall explanation

Correct Answer

1. Create the Mount Point

2. mkdir -p /mnt/disc

3. Configure Persistent Mounting

Add the following entry to `**/etc/fstab**`:

1. /RHEL10.iso  /mnt/disc  iso9660  defaults,loop  0 0

Mount it immediately:

1. mount -a

2. Configure the Repository File

Create:

1. /etc/yum.repos.d/local.repo

with the following content:

1. [BaseOS_Local]
2. name=BaseOS Local
3. baseurl=file:///mnt/disc/BaseOS
4. enabled=1
5. gpgcheck=1
6. gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

7. [AppStream_Local]
8. name=AppStream Local
9. baseurl=file:///mnt/disc/AppStream
10. enabled=1
11. gpgcheck=1
12. gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

Detailed Explanation for Learners

- **Loop Mounts**
    
    The `**loop**` option is essential because:
    
    1. /RHEL10.iso
    
    is a regular file rather than a block device.
    
    The kernel uses a **loop device** to present the ISO file as if it were a physical DVD.
    
    Although modern versions of `mount` can often detect this automatically, specifying:
    
    2. defaults,loop
    
    explicitly makes the configuration reliable during boot and matches RHCSA best practices.
    
- **Why the Mount Must Be Persistent**
    
    Mounting the ISO manually works only until the next reboot.
    
    Without the `/etc/fstab` entry:
    
    - `/mnt/disc` becomes empty after reboot.
        
    - Both DNF repositories point to nonexistent content.
        
    - Package installation fails.
        
    
    Always test the `/etc/fstab` entry using:
    
    1. mount -a
    
    before rebooting. A malformed `fstab` entry can place the system into emergency mode during startup.
    
- **Why BaseOS and AppStream Are Separate**
    
    Beginning with RHEL 8, installation media contains two independent repositories:
    
    - **BaseOS**
        
        - Kernel
            
        - systemd
            
        - glibc
            
        - Core operating system packages
            
    - **AppStream**
        
        - Languages
            
        - Databases
            
        - Development tools
            
        - Applications
            
    
    Each repository has its own:
    
    1. repodata
    
    directory.
    
    Therefore, DNF cannot use:
    
    2. file:///mnt/disc
    
    as a single repository because no metadata exists at that level.
    
    Separate repository definitions are required:
    
    3. file:///mnt/disc/BaseOS
    
    and
    
    4. file:///mnt/disc/AppStream
    
- **How GPG Verification Works**
    
    Setting:
    
    1. gpgcheck=1
    
    instructs DNF to verify the digital signature of every RPM package.
    
    The line:
    
    2. gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    
    specifies the trusted public key used for verification.
    
    During the first installation from a new repository, DNF may prompt to import this key.
    
    Display imported GPG keys:
    
    3. rpm -qa gpg-pubkey*
    
- **Useful Verification Commands**
    
    List enabled repositories:
    
    1. dnf repolist
    
    Show enabled and disabled repositories:
    
    2. dnf repolist --all
    
    Display repository details:
    
    3. dnf repoinfo BaseOS_Local
    
    `dnf repolist` should display both repositories with non-zero package counts.
    
    `dnf repoinfo` confirms:
    
    - the repository path,
        
    - GPG settings,
        
    - metadata status.
        
- **Common Troubleshooting**
    
    **Missing** `**loop**` **option**
    
    Symptoms:
    
    - "is not a block device"
        
    - mount failures during boot
        
    
    Verify active loop devices:
    
    1. losetup -a
    
    **Incorrect mount point**
    
    The `/etc/fstab` mount point and repository `baseurl` must match exactly.
    
    Verify:
    
    2. findmnt /mnt/disc
    
    **Repository disabled**
    
    Ensure:
    
    3. enabled=1
    
    appears in each repository definition.
    
    Display all repositories:
    
    4. dnf repolist --all
    
    Enable one if necessary:
    
    5. dnf config-manager --set-enabled <repository-id>
    
    **GPG Key Problems**
    
    Errors such as:
    
    6. public key is not installed
    
    or
    
    7. GPG check FAILED
    
    usually indicate an incorrect key path.
    
    Verify the key exists:
    
    8. ls /etc/pki/rpm-gpg/
    
    Import it manually if necessary:
    
    9. rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm that:
    
    1. dnf repolist
    
    displays both repositories with valid package counts, and perform a test package resolution using `dnf install`. Finally, reboot the system and repeat the verification, because it is usually the persistent ISO mount in `/etc/fstab`, not the repository file itself, that determines whether this task passes after a restart.
    
    **Question 3**

**Task:** On **ServerB**, configure the network interface `enp0s3` with the following static settings:

- **Profile Name:** `myprofile5`.
    
- **IPv4:** `192.168.1.6/24`, Gateway: `192.168.1.1`, DNS: `8.8.4.4`.
    
- **IPv6:** `fd01::105/64`, Gateway: `fd01::100`, DNS: `fd01::111`.
    
- **Secondary IPs:** Add `10.0.0.6/24` (IPv4) and `fd01::125/64` (IPv6).
    
- **Search Domain:** `google.com`.
    
- Ensure the connection starts automatically at boot.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).
  
  Overall explanation

Correct Answer

1. Create the NetworkManager Profile

2. nmcli con add con-name myprofile5 ifname enp0s3 type ethernet \
3. ipv4.method manual ipv4.addresses 192.168.1.6/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.4.4 \
4. ipv6.method manual ipv6.addresses fd01::105/64 ipv6.gateway fd01::100 ipv6.dns fd01::111 \
5. ipv4.dns-search google.com

6. Add the Secondary IP Addresses

7. nmcli con mod myprofile5 +ipv4.addresses 10.0.0.6/24

8. nmcli con mod myprofile5 +ipv6.addresses fd01::125/64

9. Ensure the Profile Starts Automatically

10. nmcli con mod myprofile5 connection.autoconnect yes

11. Activate the Profile

12. nmcli con up myprofile5

Detailed Explanation

- **NetworkManager Profiles**
    
    NetworkManager stores configuration as **connection profiles** under:
    
    1. /etc/NetworkManager/system-connections/
    

A profile contains all networking settings:

- IP addresses
    
- Gateways
    
- DNS servers
    
- Search domains
    
- Autoconnect behavior
    

Creating a profile makes the configuration **persistent across reboots**.

- **Creating Everything in One Command**
    
    `nmcli con add` allows nearly all required settings to be configured in a single command:
    
- IPv4
    
- IPv6
    
- Gateway
    
- DNS
    
- Search domain
    

This is the fastest method during the RHCSA exam.

- **Adding Secondary Addresses**
    

Notice the commands use:

1. +ipv4.addresses

and

1. +ipv6.addresses

The `**+**` appends an additional address.

Without the plus sign:

1. ipv4.addresses

the primary address would be replaced, causing you to lose:

1. 192.168.1.6/24

The same rule applies to IPv6.

- **DNS Search Domains**
    

This command:

1. ipv4.dns-search google.com

adds the following search domain to the resolver configuration:

1. google.com

For example, typing:

1. server1

allows the resolver to automatically try:

1. server1.google.com

This property is independent from the DNS server itself.

- **DNS Server**
    
    1. 8.8.4.4
    
- **Search Domain**
    
    1. google.com
    

The exam may ask for one, the other, or both.

Multiple search domains can be specified as a comma-separated list.

- **Autoconnect**
    

Profiles created with:

1. nmcli con add

normally default to:

1. connection.autoconnect yes

However, explicitly configuring it is considered best practice:

1. nmcli con mod myprofile5 connection.autoconnect yes

Without autoconnect, networking works immediately but disappears after reboot.

- **Useful Verification Commands**
    

Display the active device configuration:

1. nmcli device show enp0s3

Display the kernel's addresses:

1. ip addr show enp0s3

Verify autoconnect:

1. nmcli -f connection.autoconnect con show myprofile5

Verify IPv4 routing:

1. ip route

Verify IPv6 routing:

1. ip -6 route

`nmcli device show` is particularly useful because it displays:

- IPv4 addresses
    
- IPv6 addresses
    
- DNS servers
    
- Search domains
    
- Default gateways
    

in a single output.

Comparing it with `ip addr` helps determine whether the profile has been applied successfully.

Common Mistakes

- Forgetting the `**+**` when adding secondary addresses, which overwrites the primary address.
    
- Activating the wrong connection profile.
    
- Forgetting to activate the profile with:
    
    1. nmcli con up myprofile5
    
- Omitting the search domain.
    
- Assuming autoconnect is enabled without verifying it.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm that:

1. nmcli con show --active

lists `**myprofile5**`, `ip addr show enp0s3` displays both primary and secondary IPv4 and IPv6 addresses, `nmcli device show enp0s3` shows the DNS servers, search domain, and gateways, and:

1. nmcli -f connection.autoconnect con show myprofile5

returns `**yes**`. Finally, reboot the system and verify the profile reconnects automatically with all settings intact.


**Question 4**

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

- **Best Practice:** Creating a dedicated file in `/etc/sysctl.d/` is preferred over editing the global `/etc/sysctl.conf` because it survives system updates better and is easier to manage via automation (Ansible/Puppet).
  
  
  **Question 5**

**Task:** Configure system time and synchronization on **ServerB**.

1. Set the timezone to **America/Los_Angeles**.
    
2. Configure NTP synchronization using `chrony`.
    
3. Ensure the service is enabled and time is synchronized.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Configure time service clients).
  
  Overall explanation

**Correct Answer:**

1. **Set Timezone:**
    
    1. timedatectl set-timezone America/Los_Angeles
    
2. **Enable Chrony:**
    
    1. dnf install chrony -y
    2. systemctl enable --now chronyd
    
3. **Enable Sync:**
    
    1. timedatectl set-ntp true
    
4. **Verify:**
    
    1. timedatectl
    2. # Check for "NTP synchronized: yes"
    

**Detailed Explanation:**

- **Merged:** Covers original Q8 and Q9.
    
- `**timedatectl**`**:** The central command for time management in systemd-based distributions like RHEL 10. It handles the timezone symlink and the NTP toggle.
  
  
  **Question 6**

**Task:** Update the kernel on **ServerB**.

1. Install the latest kernel version available from the configured repositories.
    
2. Ensure that the new kernel is set as the **default** boot option.
    
3. Ensure the **original** kernel remains installed and available as a fallback.
    
4. Reboot the system to verify the new kernel is active.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install/update software, Modify bootloader).
  
  
  
  Overall explanation

Correct Answer

1. Install the Latest Kernel

2. dnf update kernel -y

Alternatively, updating the entire system is also acceptable:

1. dnf upgrade -y

if the task allows updating all packages.

2. Verify the Default Boot Kernel

3. grubby --default-kernel

The output should point to the newly installed kernel, for example:

1. /boot/vmlinuz-6.x.x-xx.el10.x86_64

2. Verify the Old Kernel Is Still Installed

3. rpm -q kernel

Example:

1. kernel-6.12.0-15.el10.x86_64
2. kernel-6.12.0-18.el10.x86_64

The previous kernel should still be listed.

4. Reboot

5. reboot

6. Verify the Running Kernel

7. uname -r

The version reported by `uname -r` should match the kernel shown by `grubby --default-kernel` before the reboot.

Detailed Explanation

- **Install-Only Packages**
    

Unlike most RPM packages, the Linux kernel is an **install-only package**.

When you run:

1. dnf update kernel

DNF installs a new kernel **alongside** the existing one rather than replacing it.

This behavior is controlled by the **installonly** mechanism.

- **Why Previous Kernels Are Kept**
    

Keeping previous kernels provides a recovery option.

If a newly installed kernel:

- fails to boot,
    
- has a driver regression,
    
- causes hardware incompatibility,
    
- or introduces another issue,
    

you can simply select the previous kernel from the GRUB menu and recover the system.

Removing all previous kernels is considered poor practice.

- **installonly_limit**
    

The number of kernels retained is controlled by:

1. /etc/dnf/dnf.conf

Example:

1. installonly_limit=3

When the limit is exceeded, DNF automatically removes only the oldest kernel.

This mechanism ensures that multiple working kernels remain available without consuming unlimited disk space.

- **GRUB Updates Automatically**
    

Installing a new kernel automatically:

- creates a new GRUB menu entry,
    
- regenerates the boot configuration,
    
- makes the newest kernel the default.
    

Normally no manual GRUB configuration is required.

- **Using grubby**
    

`grubby` is the supported tool for managing kernel boot entries.

Check the default kernel:

1. grubby --default-kernel

List all kernels:

1. grubby --info=ALL

Select a different default kernel if necessary:

1. grubby --set-default /boot/vmlinuz-<version>

Using `grubby` is safer than editing GRUB configuration files manually.

- **Verification Commands**
    

Check the default kernel that will boot next:

1. grubby --default-kernel

Check the currently running kernel:

1. uname -r

List every installed kernel:

1. rpm -q kernel

View the default GRUB entry:

1. grubby --default-index

These commands answer different questions:

- `grubby --default-kernel` → What **will** boot.
    
- `uname -r` → What **is currently running**.
    
- `rpm -q kernel` → Which kernels are installed.
    

Common Mistakes

- Removing the old kernel after installing the new one.
    
- Forgetting to reboot.
    
- Assuming the running kernel changed immediately after installation.
    
- Confusing the default boot kernel with the currently running kernel.
    
- Editing `grub.cfg` manually instead of using `grubby` when changing the default kernel.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Run:

1. grubby --default-kernel

before rebooting to confirm the next boot will use the new kernel. After rebooting, verify:

1. uname -r

matches the expected version, and confirm the previous kernel is still available with:

1. rpm -q kernel

A successful RHCSA solution requires **all three conditions**: the new kernel is installed, it becomes the default boot entry, and the previous kernel remains available as a recovery option.


**Question 7**

**Task:** Configure **ServerB** to boot into the **Multi-User Target** by default.

1. Ensure the system boots into a non-graphical, command-line interface.
    
2. Verify the setting.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually).
  
  Overall explanation

**Correct Answer:**

1. **Set Target:**
    
    1. systemctl set-default multi-user.target
    
2. **Verify:**
    
    1. systemctl get-default
    2. # Output: multi-user.target
    

**Detailed Explanation for Learners:**

- `**multi-user.target**`**:** This is the standard for servers. It starts networking, SSH, and multiple user logins, but _not_ the window manager (GNOME/X11). This saves significant RAM and CPU resources.
  
  
  **Question 8**

**Task:** Create a restricted user on **ServerB**.

1. Create a user named `harry`.
    
2. Assign the specific **UID** `5000`.
    
3. Ensure `harry` **cannot** access an interactive shell (he should not be able to log in to a terminal).
    

- **Aspects/Domains Covered:** Manage users and groups (Create/modify local user accounts).
  
  
  Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd -u 5000 -s /sbin/nologin harry
    
2. **Verify:**
    
    1. grep harry /etc/passwd
    2. # Output should end with: :/sbin/nologin
    3. su - harry
    4. # Output: This account is currently not available.
    

**Detailed Explanation for Learners:**

- **Service Accounts:** This configuration is typical for "Service Accounts." For example, an application running as `harry` might need to own files (hence the UID), but no human should ever log in as `harry` to run commands.
    
- `**/sbin/nologin**`**:** This is a polite program that prints a rejection message and closes the connection.
  
  
  **Question 9**

**Task:** Optimize **ServerB** for a virtualized environment.

1. Install and enable the `tuned` service.
    
2. Set the active tuning profile to `virtual-guest`.
    
3. Verify the profile is active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).
  
  
  Overall explanation

**Correct Answer:**

1. **Enable Tuned:**
    
    1. dnf install tuned -y
    2. systemctl enable --now tuned
    
2. **Set Profile:**
    
    1. tuned-adm profile virtual-guest
    
3. **Verify:**
    
    1. tuned-adm active
    

**Detailed Explanation for Learners:**

- `**virtual-guest**`**:** This profile optimizes Linux to realize it is running inside a hypervisor (like KVM or VMware). It adjusts disk I/O scheduling and reduces the frequency of system timer interrupts to lower the overhead on the host machine.
  
  **Question 10 (New Topic: Flatpak)**

**Task:** Manage software using **Flatpak** on **ServerB**.

1. Configure the system to use the **Flathub** remote repository (`https://dl.flathub.org/repo/flathub.flatpakrepo`).
    
2. Install the **Firefox** web browser using Flatpak.
    
3. Verify the installation.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).
  
  
  Overall explanation

Correct Answer

1. Add the Flathub Remote Repository

2. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

3. Install Firefox

4. flatpak install flathub org.mozilla.firefox -y

5. Verify the Installation

6. flatpak list --app

or

1. flatpak list

Detailed Explanation

- **Flatpak**
    
    Flatpak is a universal package management system for desktop applications.
    

Unlike RPM packages, Flatpak applications:

- run inside a sandbox,
    
- include most of their own dependencies,
    
- can be updated independently of the operating system.
    

This allows RHEL to remain stable while applications such as Firefox receive frequent updates.

- **The Flathub Remote**
    

A **remote** is Flatpak's equivalent of a DNF repository.

This command:

1. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

registers the Flathub repository.

The option:

1. --if-not-exists

makes the command idempotent—it succeeds whether or not the repository has already been configured.

The `.flatpakrepo` file contains both the repository location and its signing key.

- **Application IDs**
    

Flatpak applications are installed using their **Application ID**, not their display name.

Firefox's Application ID is:

1. org.mozilla.firefox

If you don't know an application's ID, search for it:

1. flatpak search firefox

Using `flatpak search` is often faster than trying to remember the exact identifier during the RHCSA exam.

- **System vs. User Installation**
    

A Flatpak application can be installed in two scopes.

System-wide installation (used in this task):

1. flatpak install flathub org.mozilla.firefox

Location:

1. /var/lib/flatpak

Available to every user.

User installation:

1. flatpak install --user flathub org.mozilla.firefox

Location:

1. ~/.local/share/flatpak

Available only to the current user.

Likewise, remotes can also be configured per-user using:

1. flatpak remote-add --user ...

Since this task asks you to configure **ServerB**, the correct solution is the **system-wide installation**.

- **Useful Verification Commands**
    

List configured remotes:

1. flatpak remotes

List installed applications:

1. flatpak list --app

List everything (applications and runtimes):

1. flatpak list

Show installation scope:

1. flatpak list --app --columns=application,installation

The **installation** column indicates whether an application is installed for:

- system
    
- user
    

- **Updating and Removing Applications**
    

Update installed Flatpak applications:

1. flatpak update

Remove Firefox:

1. flatpak uninstall org.mozilla.firefox

Remove unused runtimes:

1. flatpak uninstall --unused

Unused runtimes can consume significant disk space, so cleaning them periodically is good practice.

Common Mistakes

- Forgetting to add the Flathub remote before installing.
    
- Using the display name **Firefox** instead of the Application ID `org.mozilla.firefox`.
    
- Installing with `--user` when the task requires a system-wide installation.
    
- Verifying with `flatpak list` but overlooking that runtimes are also displayed.
    
- Misspelling the Application ID (it is case-sensitive).
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Run:

1. flatpak remotes

to confirm **Flathub** is configured, then verify Firefox is installed with:

1. flatpak list --app

or

1. flatpak list --app --columns=application,installation

which confirms both the application and its installation scope. Since Flatpak applications and remotes are persistent, no additional configuration is required after installation.


**Question 11**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server (`httpd`).
    
2. Configure the default web page (`index.html`) to display the text: "Hello Guys!".
    
3. Configure the **Firewall** to allow HTTP and HTTPS traffic permanently.
    
4. Ensure the service starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Configure firewall settings).
  
  Overall explanation

**Correct Answer:**

1. **Install:**
    
    1. dnf install httpd -y
    
2. **Configure Content:**
    
    1. echo "Hello Guys!" > /var/www/html/index.html
    
3. **Firewall:**
    
    1. firewall-cmd --permanent --add-service=http
    2. firewall-cmd --permanent --add-service=https
    3. firewall-cmd --reload
    
4. **Start and Enable:**
    
    1. systemctl enable --now httpd
    
5. **Verify:**
    
    1. curl http://localhost
    

**Detailed Explanation for Learners:**

- **Default Document Root:** Apache looks in `/var/www/html/` for content.
    
- **Firewall Persistence:** The `--permanent` flag writes the rule to the XML configuration files in `/etc/firewalld/`, ensuring the rule survives a reboot. `systemctl enable` creates the symlink to start the service daemon on boot.
  
  
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
  
  
  Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /find/recent_configs
    
2. **Find and Copy:**
    
    1. find /etc -type f -size +5M -mtime -30 -name "*.conf" -exec cp {} /find/recent_configs/ \;
    
3. **Secure Permissions:**
    
    1. chmod 600 /find/recent_configs/*
    

**Detailed Explanation for Learners:**

- `**-mtime -30**`**:** The minus sign means "Less than 30 days ago" (Recent). A plus sign (`+30`) would mean "More than 30 days ago" (Old).
    
- `**chmod 600**`**:** `rw- --- ---`. This removes all access for Group and Others, securing the backup files.
  
  **Question 13**

**Task:** Create a shell script named `/sum.sh` (or `/usr/local/bin/sum.sh`) on **ServerB**.

1. The script should accept an unlimited number of integer arguments (e.g., `./sum.sh 10 20 -5 30`).
    
2. It should calculate the sum of all arguments that are **greater than 0**. (Ignore negative numbers or zero).
    
3. Print the result in the format: "The sum is [total]".
    
4. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, Loops, Conditional logic).
  
  Overall explanation

**Correct Answer:**

1. **Create Script:**
    
    1. vim /sum.sh
    
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
    
3. **Make Executable:**
    
    1. chmod +x /sum.sh
    
4. **Verify:**
    
    1. ./sum.sh 10 20 -5
    2. # Output should be 30 (10+20).
    

**Detailed Explanation for Learners:**

- `**"$@"**`**:** This variable represents "All arguments passed to the script" as a list.
    
- `**-gt 0**`**:** Greater Than Zero.
    
- `**$(( ... ))**`**:** Arithmetic expansion. It performs the math inside the double parentheses.
  
  
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
  
  Overall explanation

**Correct Answer:**

1. **Create Groups & Users:**
    
    1. groupadd Innovation
    2. groupadd Solution
    3. useradd -G Innovation James
    4. useradd -G Innovation Ethan
    5. useradd -G Solution Lucas
    6. useradd -G Solution Oliver
    
2. **Create Directories:** `mkdir -p /groups/Innovation /groups/Solution`
    
3. **Ownership & Base Permissions:**
    
    1. chown :Innovation /groups/Innovation
    2. chown :Solution /groups/Solution
    3. chmod 2770 /groups/Innovation /groups/Solution
    
    _(Note:_ `_2770_` _is a shortcut for_ `_chmod g+s,u+rwx,g+rwx,o-rwx_`_)._
    
4. **Set ACL (Cross-Access):**
    
    - **Access ACL (Entry Ticket):** `setfacl -m g:Solution:rx /groups/Innovation`
        
    - **Default ACL (Inheritance):** `setfacl -m d:g:Solution:rx /groups/Innovation`
        

**Detailed Explanation for Learners:**

- **SGID (**`**chmod g+s**` **or** `**2xxx**`**):** Critical for internal team collaboration. It ensures files created by James are owned by the group `Innovation`, not `James`, so Ethan can edit them.
    
- **ACL (**`**setfacl**`**):**
    
    - The **Access ACL** (`-m`) opens the door, allowing the Solution group to enter the directory right now.
        
    - The **Default ACL** (`-m d:`) acts as a template, ensuring any _new_ files created inside automatically grant Read/Execute permissions to the Solution group. You need both for a complete setup.
      
      
      **Question 15**

**Task:** Configure LVM with specific physical extents on **ServerB**.

1. Using disk `/dev/sdb` (create a partition if needed), create a Volume Group named `myvg`.
    
2. **Crucial:** Configure the Volume Group to use a **Physical Extent (PE) size of 16MiB**.
    
3. Create a Logical Volume named `mylv` inside this group.
    
4. The LV must contain exactly **50 Extents**.
    
5. Format with **xfs** and mount persistently at `/mnt/mylv`.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Assign physical volumes to volume groups).
  
  
  Overall explanation

Correct Answer

1. Prepare the Disk

Create an LVM partition on **/dev/sdb**.

1. fdisk /dev/sdb

Create a new partition (for example, `/dev/sdb1`) and set its type to **Linux LVM**.

Reload the partition table:

1. partprobe /dev/sdb

Initialize the partition as a Physical Volume:

1. pvcreate /dev/sdb1

2. Create the Volume Group with a 16 MiB Physical Extent Size

3. vgcreate -s 16M myvg /dev/sdb1

4. Create the Logical Volume Using Exactly 50 Extents

5. lvcreate -l 50 -n mylv myvg

6. Format and Mount

Create the XFS filesystem:

1. mkfs.xfs /dev/myvg/mylv

Create the mount point:

1. mkdir -p /mnt/mylv

Configure persistent mounting:

1. echo "/dev/myvg/mylv /mnt/mylv xfs defaults 0 0" >> /etc/fstab

Mount the filesystem:

1. mount -a

2. Verify

Verify the Volume Group:

1. vgdisplay myvg

Verify the Logical Volume:

1. lvdisplay /dev/myvg/mylv

Detailed Explanation

- **Physical Extents (PE)**
    

LVM does not allocate storage byte-by-byte.

Instead, each Volume Group is divided into equally sized blocks called **Physical Extents (PEs)**.

Every allocation inside the Volume Group occurs in whole extents.

The extent size is determined **only when the Volume Group is created**.

The default is usually:

1. 4.00 MiB

This task explicitly requires:

1. 16.00 MiB

which is why the Volume Group is created using:

1. vgcreate -s 16M myvg /dev/sdb1

The long-form equivalent is:

1. vgcreate --physicalextentsize 16M myvg /dev/sdb1

- **Logical Extents (LE)**
    

Logical Volumes are allocated using **Logical Extents (LEs)**.

In a standard linear Logical Volume:

- 1 LE maps directly to 1 PE.
    

Therefore:

- PE size = 16 MiB
    
- LV uses 50 extents
    

Resulting size:

1. 50 × 16 MiB = 800 MiB

Notice that the task never asks for **800 MiB**.

It asks for **50 extents**, therefore the correct command is:

1. lvcreate -l 50 -n mylv myvg

The lowercase `**-l**` specifies an **extent count**.

- **-l vs -L**
    

These options are commonly confused.

Use:

1. -l

for:

- number of extents
    
- percentage of free space
    
- percentage of the VG
    

Examples:

1. lvcreate -l 50 ...

2. lvcreate -l 100%FREE ...

3. lvcreate -l 50%VG ...

Use:

1. -L

for an actual size:

1. lvcreate -L 2G ...

This task specifically requires `**-l 50**`.

- **Why PE Size Matters**
    

The Physical Extent size determines:

- allocation granularity,
    
- maximum number of extents,
    
- metadata size,
    
- sizing flexibility.
    

Small PE sizes:

- finer allocation,
    
- more metadata.
    

Large PE sizes:

- less metadata,
    
- better suited for very large storage pools.
    

In production, the default is usually appropriate.

The RHCSA exam asks you to customize it simply to verify that you understand it is a **Volume Group property**, not a Logical Volume property.

- **Verification Commands**
    

Display the Volume Group:

1. vgdisplay myvg

Look for:

1. PE Size               16.00 MiB

Display the Logical Volume:

1. lvdisplay /dev/myvg/mylv

Look for:

1. Current LE            50

Additional verification:

1. vgs -o vg_name,vg_extent_size,vg_extent_count myvg

2. lvs -o lv_name,lv_size,seg_count

Verify the mount:

1. df -h /mnt/mylv

These commands confirm both the storage configuration and the mounted filesystem.

- **GPT vs. MBR Partition Tables**
    

Modern RHEL installations commonly use **GPT (GUID Partition Table)**.

If creating a new GPT disk with `fdisk`, use:

1. g

to create a GPT partition table before creating the partition.

For GPT disks, the Linux LVM partition type is **31** (alias for Linux LVM).

Alternatively, `parted` provides a fast non-interactive method:

1. parted /dev/sdb mklabel gpt

2. parted /dev/sdb mkpart primary 1MiB 100%

3. parted /dev/sdb set 1 lvm on

Although the RHCSA exam accepts either MBR or GPT unless specified, becoming comfortable with GPT is good practice because it is the standard on modern enterprise systems.

Common Mistakes

- Using `-L 800M` instead of `-l 50`.
    
- Forgetting to specify the PE size when creating the Volume Group.
    
- Assuming the PE size can be changed later.
    
- Forgetting to reload the partition table with `partprobe`.
    
- Forgetting to configure `/etc/fstab` for persistent mounting.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm:

- `vgdisplay myvg` reports **PE Size = 16.00 MiB**,
    
- `lvdisplay /dev/myvg/mylv` reports **Current LE = 50**,
    
- `df -h /mnt/mylv` shows the mounted filesystem,
    
- and `mount -a` completes without errors before rebooting.
    

These are the key checks that demonstrate the Volume Group, Logical Volume, filesystem, and persistent mount have all been configured correctly.


**Question 16 (New Topic: Systemd Timers)**

**Task:** On **ServerB**, schedule a recurring maintenance task using **Systemd Timer Units** (not Cron).

1. Create a script `/usr/local/bin/clean_tmp.sh` that deletes all **empty files** (not directories) inside `/tmp`. Make it executable.
    
2. Create a service unit named `clean-tmp.service` to run this script.
    
3. Create a timer unit named `clean-tmp.timer` that runs this service **daily at 16:15** (4:15 PM).
    
4. Ensure the timer is active and enabled.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units).
  
  
  Overall explanation

Correct Answer

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/clean_tmp.sh
3. echo 'find /tmp -type f -empty -delete' >> /usr/local/bin/clean_tmp.sh
4. chmod +x /usr/local/bin/clean_tmp.sh

5. Create the Service Unit

Create:

1. /etc/systemd/system/clean-tmp.service

Contents:

1. [Unit]
2. Description=Clean Empty Files in /tmp

3. [Service]
4. Type=oneshot
5. ExecStart=/usr/local/bin/clean_tmp.sh

6. Create the Timer Unit

Create:

1. /etc/systemd/system/clean-tmp.timer

Contents:

1. [Unit]
2. Description=Run Clean Tmp Daily at 16:15

3. [Timer]
4. OnCalendar=*-*-* 16:15:00
5. Unit=clean-tmp.service

6. [Install]
7. WantedBy=timers.target

8. Reload Systemd

9. systemctl daemon-reload

10. Enable and Start the Timer

11. systemctl enable --now clean-tmp.timer

Detailed Explanation

- **Systemd Timers**
    

Systemd timers are the modern replacement for many Cron jobs.

A timer consists of two units:

- a **service**, which performs the work,
    
- a **timer**, which specifies when the service runs.
    

The timer never executes commands directly.

Instead, it activates the associated service.

- **The Script**
    

This command:

1. find /tmp -type f -empty -delete

searches `/tmp` for:

- regular files (`-type f`)
    
- that are empty (`-empty`)
    

and deletes them.

Directories are ignored because of:

1. -type f

- **Service Unit**
    

The service is a simple **oneshot** service.

1. Type=oneshot

means:

- run the script,
    
- wait until it finishes,
    
- exit.
    

This is ideal for maintenance jobs.

- **OnCalendar Syntax**
    

The timer uses:

1. OnCalendar=*-*-* 16:15:00

The format is:

1. DayOfWeek Year-Month-Day Hour:Minute:Second

where `*` means "every".

Therefore:

1. *-*-* 16:15:00

means:

Every day at **16:15:00**.

Useful examples:

ScheduleOnCalendarEvery day at midnight`daily`Every day at 07:30`*-*-* 07:30:00`Every Monday`Mon *-*-* 00:00:00`Every hour`hourly`

- **Validate the Calendar Expression**
    

Rather than guessing the syntax, verify it:

1. systemd-analyze calendar "*-*-* 16:15:00"

The command reports:

- the normalized expression,
    
- the next execution time,
    
- whether the syntax is valid.
    

This is one of the fastest ways to catch mistakes during the RHCSA exam.

- **Why daemon-reload Is Required**
    

Systemd caches unit files.

Whenever you create or modify units under:

1. /etc/systemd/system/

you must reload the manager:

1. systemctl daemon-reload

Without it, the new timer and service are unknown to systemd.

- **Enable the Timer, Not the Service**
    

Always enable:

1. systemctl enable --now clean-tmp.timer

**Not:**

1. systemctl enable clean-tmp.service

Enabling the service would only start it during boot.

It would **not** create a recurring schedule.

- **Useful Verification Commands**
    

List active timers:

1. systemctl list-timers

List all timers:

1. systemctl list-timers --all

Check timer status:

1. systemctl status clean-tmp.timer

Check service logs:

1. journalctl -u clean-tmp.service

These commands verify different aspects:

- `list-timers` → next execution time.
    
- `status` → enabled and active.
    
- `journalctl` → confirms the service actually executed.
    

- **Testing Without Waiting Until 16:15**
    

Rather than waiting for the scheduled time, manually trigger the service:

1. systemctl start clean-tmp.service

Then verify that empty files in `/tmp` have been removed.

This tests the script independently of the timer.

Common Mistakes

- Forgetting `systemctl daemon-reload`.
    
- Enabling the service instead of the timer.
    
- Misspelling the timer or service names.
    
- Using `OnBootSec` instead of `OnCalendar` for a fixed daily schedule.
    
- Forgetting to make the script executable.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm:

1. systemctl is-enabled clean-tmp.timer

returns **enabled**, use:

1. systemctl list-timers

to verify the next run is scheduled for **16:15**, and check:

1. journalctl -u clean-tmp.service

after a manual test with:

1. systemctl start clean-tmp.service

Finally, reboot the system and ensure `systemctl list-timers` still shows `clean-tmp.timer` with its next scheduled execution.


**Question 17**

**Task:** Perform file archiving with exclusions on **ServerB**.

1. Create a directory `/Backup`.
    
2. Create a **gzip** compressed tar archive named `/Backup/myhome.tgz`.
    
3. The archive should contain the contents of `/home`.
    
4. **Exclude** all files with the extension `.pdf` from the archive.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive files using tar, gzip).
  
  
  Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /Backup
    
2. **Create Archive:**
    
    1. tar -czf /Backup/myhome.tgz --exclude='*.pdf' /home
    
3. **Verify:**
    
    1. tar -tf /Backup/myhome.tgz | grep ".pdf"
    2. # Should return no output.
    

**Detailed Explanation for Learners:**

- **Placement of** `**--exclude**`**:** It is best practice to place the exclude flag _before_ the source directory argument.
    
- **Quoting:** Put `'*.pdf'` in quotes to prevent the shell from expanding the wildcard before the `tar` command sees it.
  
  
  **Question 18**

**Task:** Add swap space to **ServerB**.

1. Create a new partition of **1GiB** on `/dev/sdb`.
    
2. Format the partition as swap space.
    
3. Activate the swap space immediately.
    
4. Ensure the swap space persists after a reboot by using its **UUID**.
    

- **Aspects/Domains Covered:** Configure local storage (Add swap to a system non-destructively).
  
  Overall explanation

**Correct Answer:**

1. **Create Partition:**
    
    1. fdisk /dev/sdb
    2. # 'n', Enter, Enter, '+1G', 't', '82' (Linux Swap), 'w'.
    3. partprobe /dev/sdb
    
2. **Format:**
    
    1. mkswap /dev/sdbX  # Replace X with partition number, e.g., sdb2
    
3. **Persist:**
    
    - Get UUID:
        
        1. blkid /dev/sdbX
        
    - Edit `/etc/fstab`:
        
        1. UUID=<your-uuid>  none  swap  defaults  0 0
        
4. **Activate:**
    
    1. swapon -a
    2. free -h
    

**Detailed Explanation for Learners:**

- `**swapon -a**`**:** This activates all swap devices listed in `/etc/fstab`. If you made a typo in fstab, this command will likely show an error, saving you from a failed boot later.
  
  
  **Question 19**

**Task:** Secure SSH access on **ServerB**.

1. **User Setup:** Create a user `john`.
    
2. **Key-Based Auth:** Configure passwordless SSH login for `john` from **ServerA** (or localhost). Generate keys and copy them correctly.
    
3. **Harden SSH:** Configure the SSH daemon to **disable** password authentication globally.
    
4. **Restart:** Apply the changes.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication, Configure SSH).
  
  
  Overall explanation

Correct Answer

1. Create the User

2. useradd john

Set a temporary password (required for the initial `ssh-copy-id`):

1. passwd john

2. Generate and Install the SSH Key

Log in as **john**:

1. su - john

Generate an SSH key pair:

1. ssh-keygen -t ed25519

Press **Enter** to accept the default file location and press **Enter** twice for an empty passphrase.

_(RSA is also acceptable for the exam:_ `_ssh-keygen -t rsa -b 3072_`_.)_

Copy the public key to the target system (or localhost):

1. ssh-copy-id john@localhost

Enter **john's password** when prompted.

Verify passwordless login:

1. ssh john@localhost

Exit back to the root shell:

1. exit

2. Configure SSH to Disable Password Authentication

Edit:

1. /etc/ssh/sshd_config

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

5. Restart SSH

6. systemctl restart sshd

Detailed Explanation

- **Key-Based Authentication**
    

SSH key authentication replaces passwords with a cryptographic key pair.

The client stores:

- the **private key** (never shared),
    

while the server stores:

- the **public key** inside:
    

1. ~/.ssh/authorized_keys

During login, the client proves ownership of the private key without sending it across the network.

- **Why a Temporary Password Is Needed**
    

Although the final goal is passwordless login, `ssh-copy-id` must first authenticate to the remote account to install the public key.

That is why a temporary password is set for **john** before running:

1. ssh-copy-id john@localhost

Once the key is installed and verified, password authentication can safely be disabled.

- **Choosing a Key Type**
    

The modern recommendation is:

1. ssh-keygen -t ed25519

Benefits include:

- smaller keys,
    
- faster authentication,
    
- strong security,
    
- no key-size selection required.
    

RSA remains fully acceptable for RHCSA:

1. ssh-keygen -t rsa -b 3072

Either satisfies the exam objective.

- **Disabling Password Authentication**
    

The directive:

1. PasswordAuthentication no

prevents SSH from accepting passwords for **all users**.

Only public-key authentication remains available.

This significantly reduces the risk of brute-force password attacks.

- **Validate Before Restarting**
    

Always verify the configuration before restarting `sshd`.

Display the effective configuration:

1. sshd -T | grep -i passwordauthentication

Check the configuration syntax:

1. sshd -t

`sshd -T` processes:

- `/etc/ssh/sshd_config`
    
- all included files under:
    

1. /etc/ssh/sshd_config.d/

making it more reliable than simply inspecting the configuration file.

- **Why Validation Matters**
    

A syntax error prevents `sshd` from restarting.

If you're connected remotely and restart a broken SSH daemon, you may lose access to the server.

A safer workflow is:

1. Keep your current SSH session open.
    
2. Validate the configuration.
    
3. Restart `sshd`.
    
4. Test a new SSH session.
    
5. Close the original session only after the new one succeeds.
    

- **Permissions Matter**
    

SSH refuses to use insecure key files.

Correct permissions are:

1. ~/.ssh                 700
2. ~/.ssh/authorized_keys 600

Both must be owned by **john**.

If SELinux labels are incorrect after manually creating `.ssh`, restore them:

1. restorecon -Rv /home/john/.ssh

- **Useful Verification Commands**
    

Verify passwordless login:

1. ssh john@localhost

Display the effective SSH settings:

1. sshd -T | grep -Ei "pubkeyauthentication|passwordauthentication"

Check the SSH service:

1. systemctl status sshd

Verify the service is enabled:

1. systemctl is-enabled sshd

If authentication fails, use verbose SSH output:

1. ssh -v john@localhost

Look for:

1. Authentication succeeded (publickey)

which confirms that the server accepted the key.

Common Mistakes

- Disabling password authentication before confirming key-based login works.
    
- Forgetting to restart `sshd` after editing the configuration.
    
- Incorrect permissions on `~/.ssh` or `authorized_keys`.
    
- Editing `sshd_config` but overlooking conflicting settings in `sshd_config.d/`.
    
- Copying the private key instead of the public key.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Keep your current session open, open a second terminal, and confirm:

1. ssh john@localhost

logs in **without a password**. Then verify:

1. sshd -T | grep -i passwordauthentication

shows `**passwordauthentication no**`, confirm:

1. systemctl is-enabled sshd

returns **enabled**, and finally reboot the system and repeat the SSH login test to ensure the configuration persists.


**Question 20**

**Task:** Configure network identity and local resolution on **ServerB**.

1. Set the hostname to `rhel.server.com` persistently.
    
2. Configure the `/etc/hosts` file to resolve the name `rhel.server.com` to:
    
    - The loopback address `127.0.0.1`.
        
    - The network address `192.168.1.6`.
        

- **Aspects/Domains Covered:** Manage Basic Networking (Configure hostname resolution).
  
  
  Overall explanation

**Correct Answer:**

1. **Set Hostname:**
    
    1. hostnamectl set-hostname rhel.server.com
    
2. **Edit Hosts File:**
    
    - Edit `/etc/hosts`:
        
        1. vim /etc/hosts
        
    - Ensure these lines exist:
        
        1. 127.0.0.1   localhost localhost.localdomain rhel.server.com
        2. 192.168.1.6 rhel.server.com
        

**Detailed Explanation for Learners:**

- **Why map to 127.0.0.1?** Some applications try to connect to the hostname of the server itself. If the network card is down, mapping the hostname to loopback ensures internal services can still communicate.
    
- **Order of Resolution:** Linux checks `/etc/hosts` before asking a DNS server (by default).
  
  
  **Question 21**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux mode.
    
2. Set the system to run in **Enforcing** mode.
    
3. Ensure this setting is persistent across reboots.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).
  
  
  Overall explanation

Correct Answer

1. Check the Current SELinux Mode

2. getenforce

Or display detailed status:

1. sestatus

2. Set SELinux to Enforcing Immediately

3. setenforce 1

4. Make the Change Persistent

Edit the SELinux configuration file:

1. /etc/selinux/config

Set:

1. SELINUX=enforcing

2. Verify

Check the running mode:

1. getenforce

Expected output:

1. Enforcing

Verify both the running mode and the persistent configuration:

1. sestatus | grep -E 'Current mode|Mode from config'

Expected output:

1. Current mode:                   enforcing
2. Mode from config file:          enforcing

Confirm the configuration file:

1. grep ^SELINUX= /etc/selinux/config

Expected output:

1. SELINUX=enforcing

Detailed Explanation

- **Immediate vs. Persistent Changes**
    

Setting SELinux to **Enforcing** requires **two independent actions**.

The first changes the running kernel:

1. setenforce 1

This takes effect immediately but lasts only until the next reboot.

The second updates the permanent configuration:

1. SELINUX=enforcing

in:

1. /etc/selinux/config

This determines the SELinux mode for every future boot.

Both actions are required to satisfy the exam objective.

- **Runtime vs. Configuration**
    

Think of the two commands as affecting different locations:

CommandChangesTakes Effect`setenforce 1`Running kernel (RAM)Immediately`SELINUX=enforcing`Configuration file (Disk)Next boot

Changing only one of them leaves the system only partially configured.

- **What** `**getenforce**` **Tells You**
    

1. getenforce

reports only the **current running mode**:

- Enforcing
    
- Permissive
    
- Disabled
    

It does **not** indicate what will happen after a reboot.

- **Why** `**sestatus**` **Is Better**
    

1. sestatus

shows both:

- Current mode
    
- Mode from the configuration file
    

For example:

1. Current mode:                   enforcing
2. Mode from config file:          enforcing

This single command verifies both the immediate and persistent requirements.

- **If SELinux Is Disabled**
    

`setenforce` cannot enable SELinux if the system was booted with:

1. SELINUX=disabled

because the SELinux kernel subsystem never loaded.

In that situation:

1. Edit:
    

2. /etc/selinux/config

to:

1. SELINUX=enforcing

2. Reboot the system.
    

The first boot may perform a full filesystem relabel, which can take several minutes depending on the system.

- **Emergency Recovery**
    

If a newly enforced system cannot boot because of incorrect SELinux labels or policy issues, temporarily boot with the kernel parameter:

1. enforcing=0

This starts the system in **Permissive** mode, allowing troubleshooting without disabling SELinux permanently.

- **Useful Verification Commands**
    

Display the current mode:

1. getenforce

Display detailed SELinux status:

1. sestatus

Check the persistent configuration:

1. grep ^SELINUX= /etc/selinux/config

Verify both runtime and configuration together:

1. sestatus | grep -E 'Current mode|Mode from config'

Common Mistakes

- Running only `setenforce 1` without updating `/etc/selinux/config`.
    
- Editing the configuration file without changing the running mode.
    
- Assuming `getenforce` verifies persistence.
    
- Expecting `setenforce` to enable SELinux after booting with `SELINUX=disabled`.
    
- Forgetting that enabling SELinux from the disabled state requires a reboot.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it. Use:

1. sestatus

to confirm both the **Current mode** and **Mode from config file** are **enforcing**, then reboot the system and verify again with:

1. getenforce

A correct RHCSA solution always satisfies **both the immediate runtime requirement and the persistent configuration requirement**.





**Question 22**

**Task:** Manage software packages on ServerB.

- Search for the package group named **"Development Tools"**.
    
- Display detailed information about this group to see which packages it includes.
    
- **Install** the "Development Tools" group.
    
- Verify the installation.
    

**Aspects/Domains Covered:** Manage software (Install and update software packages, Use package groups).


Overall explanation

**Correct Answer:**

1. **Search/List Groups:** `dnf group list` or `dnf group list hidden`
    
2. **Display Info:** `dnf group info "Development Tools"`
    
3. **Install Group:** `dnf group install "Development Tools" -y`
    
4. **Verify:** `dnf group list installed` _(Or check for a specific tool like_ `_gcc --version_`_)_
    

**Detailed Explanation for Learners:**

- **Package Groups:** Instead of installing 50 separate packages (gcc, make, autoconf, etc.), RHEL bundles them into "Groups".
    
- **Quotes:** Use quotes `"Development Tools"` because the name contains a space.
    
- **Deprecation Note:** In previous RHEL versions, we used `dnf module` to manage versions. In RHEL 10, this is deprecated. We now rely on standard repositories and groups.
  
  
  **Question 23**

**Task:** Perform file compression on **ServerB**.

1. Create a **bzip2** compressed tar archive named `/home/bin.tar.bz2`.
    
2. The archive should contain the contents of the `/usr/bin` directory.
    
3. Ensure the tool used is `tar`.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack files using tar, bzip2).
  
  
  Overall explanation

**Correct Answer:**

1. **Create Archive:**
    
    1. tar -cjf /home/bin.tar.bz2 /usr/bin
    
2. **Verify:**
    
    1. file /home/bin.tar.bz2
    2. # Output should mention "bzip2 compressed data"
    

**Detailed Explanation for Learners:**

- `**-j**` **Flag:** This tells `tar` to use the `bzip2` algorithm.
    
- `**-z**` **Flag:** Uses `gzip`.
    
- `**-J**` **(Capital):** Uses `xz`.
    
- **Memory Aid:** **j** corresponds to b**z**ip2 (the letter 'j' isn't in the word, but think of it as the alternative to 'z').
  
  
  **Question 24**

**Task:** Configure a global environment variable on **ServerB**.

1. Create a variable named `VAR` with the value `RHCSA Prac Five`.
    
2. Ensure this variable is available to **all users**, on both local logins and remote SSH sessions.
    
3. Verify the variable is set.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Environment variables).
  
  
  Overall explanation

**Correct Answer:**

1. **Edit Global Config:**
    
    - Open `/etc/environment` (This is the specific file for global variables without shell scripting syntax):
        
        1. vim /etc/environment
        
    - Add the line:
        
        1. VAR="RHCSA Prac Five"
        
2. **Verify:**
    
    - Log out and back in, or simulate a login:
        
        1. su -
        2. echo $VAR
        

**Detailed Explanation for Learners:**

- `**/etc/environment**`**:** This file is read by the PAM (Pluggable Authentication Modules) system during login. It is _not_ a script file, so you do **not** use `export`. You just use `KEY="VALUE"`.
    
- `**/etc/profile**`**:** This is a script file. If you put it here, you _must_ use `export KEY="VALUE"`. Both are valid for "all users," but `/etc/environment` is simpler for static variables.
  
  **Question 25**

**Task:** Configure system log persistence on **ServerB**.

1. Configure `systemd-journald` to store logs persistently on disk.
    
2. Configure a size limit: The journal logs should not exceed **100MiB** of disk space.
    
3. Restart the service to apply changes.
    

- **Aspects/Domains Covered:** Operate running systems (Preserve system journals).
  
  
  Overall explanation

Correct Answer

1. Configure journald

Edit the configuration file:

1. /etc/systemd/journald.conf

Uncomment or add the following settings:

1. [Journal]
2. Storage=persistent
3. SystemMaxUse=100M

4. Restart the Service

5. systemctl restart systemd-journald

6. Verify

Confirm the persistent journal directory exists:

1. ls -ld /var/log/journal

Verify the configured storage usage:

1. journalctl --disk-usage

Verify multiple boots are retained (after reboot):

1. journalctl --list-boots

Detailed Explanation

- **Storage=persistent**
    

By default, RHEL uses:

1. Storage=auto

which stores journals in memory under:

1. /run/log/journal

unless `/var/log/journal` already exists.

Setting

1. Storage=persistent

forces **systemd-journald** to write logs to:

1. /var/log/journal

making them survive system reboots.

- **SystemMaxUse**
    

1. SystemMaxUse=100M

limits the **total disk space** occupied by persistent journals.

Once the journal reaches approximately **100 MiB**, journald automatically removes the oldest archived journal files before writing new ones.

This built-in rotation prevents the journal from filling the filesystem.

- **journald vs. rsyslog**
    

These services perform different roles.

**systemd-journald**

- Collects logs from the kernel and systemd services
    
- Stores structured binary journals
    
- Queried with:
    

1. journalctl

**rsyslog**

- Reads messages from journald
    
- Writes traditional text logs such as:
    

1. /var/log/messages

- Can forward logs to remote servers
    

Modern RHEL systems commonly run **both** services together.

- **Storage Modes**
    

systemd-journald supports four storage modes.

SettingBehavior`persistent`Always store logs on disk`auto`Store on disk only if `/var/log/journal` exists (default)`volatile`Store logs only in memory`none`Discard all journal data

For this task, **persistent** is the correct choice.

- **Journal Rotation**
    

Unlike text logs managed by **logrotate**, journal files are managed entirely by **systemd-journald**.

Useful related options include:

1. SystemMaxUse=100M
2. SystemKeepFree=
3. RuntimeMaxUse=
4. MaxRetentionSec=

`SystemMaxUse` limits total disk usage.

`SystemKeepFree` reserves free filesystem space.

`RuntimeMaxUse` limits the in-memory journal stored under `/run`.

`MaxRetentionSec` limits logs by age instead of size.

- **Verification Commands**
    

Check journal storage usage:

1. journalctl --disk-usage

Example:

1. Archived and active journals take up 42.3M on disk.

List all recorded boots:

1. journalctl --list-boots

Display the previous boot:

1. journalctl -b -1

Verify journal integrity:

1. journalctl --verify

- **Persistence Verification**
    

The real proof that persistent logging is working is **after a reboot**.

A persistent journal should show multiple boot entries:

1. journalctl --list-boots

If only the current boot appears, journald is still operating in volatile mode.

Common Mistakes

- Setting `Storage=persistent` but forgetting to restart `systemd-journald`.
    
- Editing the wrong configuration file.
    
- Confusing `SystemMaxUse` with logrotate settings.
    
- Verifying only that `/var/log/journal` exists without checking journal persistence.
    
- Forgetting that `Storage=auto` requires `/var/log/journal` to exist before journald will use persistent storage.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Use:

1. journalctl --disk-usage

to confirm the journal is using disk storage and respecting the configured size limit, then reboot and verify persistence with:

1. journalctl --list-boots
2. journalctl -b -1

A complete RHCSA solution proves both that **persistent storage is enabled** and that **journal retention survives a reboot**.


**Question 26**

**Task:** Configure **ServerB** to serve web content stored on an NFS share.

1. Install the Apache Web Server (`httpd`).
    
2. Configure **SELinux Booleans** to allow the Apache process to read files located on NFS file systems (`httpd_use_nfs`).
    
3. Ensure this boolean setting persists across reboots.
    
4. (Optional/Implied) Ensure the firewall allows web traffic.
    

- **Aspects/Domains Covered:** Manage security (Use boolean settings to modify system SELinux settings).
  
  
  Overall explanation

Correct Answer

1. Install and Start Apache

2. dnf install httpd -y

Enable and start the service:

1. systemctl enable --now httpd

2. Configure the Firewall

Allow HTTP permanently:

1. firewall-cmd --permanent --add-service=http

Reload the firewall:

1. firewall-cmd --reload

2. Enable the SELinux Boolean

Enable Apache access to NFS and make it persistent:

1. setsebool -P httpd_use_nfs on

(`1` may be used instead of `on`.)

4. Verify

Verify the boolean:

1. getsebool httpd_use_nfs

Expected output:

1. httpd_use_nfs --> on

Verify both the current and persistent values:

1. semanage boolean -l | grep httpd_use_nfs

Expected output:

1. httpd_use_nfs    (on , on)

Detailed Explanation

- **Why Apache Cannot Read NFS by Default**
    

Even if an NFS share is mounted correctly and UNIX permissions allow access, SELinux still blocks Apache.

The Apache process runs in the **httpd_t** domain, while files on an NFS mount receive the generic SELinux type **nfs_t** because NFS does not support SELinux labels in the same way as local filesystems.

Without changing the policy, Apache receives AVC denials when attempting to read content from the NFS share.

- **SELinux Booleans**
    

SELinux booleans are predefined policy switches that enable or disable specific permissions without modifying the SELinux policy itself.

For this task, the required boolean is:

1. httpd_use_nfs

Enabling it allows processes running in the **httpd_t** domain to access files on NFS-mounted filesystems while leaving the rest of the SELinux policy unchanged.

- **Why Use** `**-P**`
    

1. setsebool -P httpd_use_nfs on

The `-P` option writes the change into the SELinux policy store, making it survive future reboots.

Without `-P`:

1. setsebool httpd_use_nfs on

the change affects only the running system and returns to the default value after reboot.

The `-P` operation takes slightly longer because SELinux rebuilds and stores the updated policy configuration.

- **Finding Available Booleans**
    

If you cannot remember the exact boolean name, list all NFS-related booleans:

1. getsebool -a | grep nfs

Or display descriptions:

1. semanage boolean -l | grep nfs

`semanage boolean -l` is especially useful because it includes a description of what each boolean controls.

- **Related SELinux Booleans**
    

Other storage-related booleans include:

- `httpd_use_cifs` — allow Apache to access CIFS/SMB shares.
    
- `httpd_use_fusefs` — allow Apache to access FUSE filesystems.
    

Choose the boolean that matches the filesystem type specified in the task.

- **Verification**
    

Check the current state:

1. getsebool httpd_use_nfs

Check all NFS-related booleans:

1. getsebool -a | grep nfs

Verify both the current and persistent values:

1. semanage boolean -l | grep httpd_use_nfs

A correct persistent configuration appears as:

1. (on , on)

If you instead see:

1. (on , off)

the boolean is enabled only for the current runtime session, indicating that `-P` was omitted.

- **Firewall**
    

If the server will provide web content, HTTP must be allowed through the firewall:

1. firewall-cmd --permanent --add-service=http
2. firewall-cmd --reload

Verify:

1. firewall-cmd --list-services

Common Mistakes

- Using `setenforce 0` instead of enabling the appropriate SELinux boolean.
    
- Forgetting the `-P` option, causing the setting to revert after reboot.
    
- Assuming UNIX permissions alone allow Apache to read NFS content.
    
- Forgetting to start and enable the `httpd` service.
    
- Forgetting to open the HTTP service in the firewall.
    

Exam Tip

Before moving on, verify both functionality and persistence whenever the objective requires it.

Use:

1. getsebool httpd_use_nfs

to verify the runtime state, and:

1. semanage boolean -l | grep httpd_use_nfs

to confirm both the **current** and **persistent** values are **on**. If Apache is serving content from an NFS share, also verify that `httpd` is running and that the firewall permits HTTP traffic.



**Question 27**

**Task:** Manage SELinux File Contexts on **ServerB**.

1. Create a directory `/backup`.
    
2. Configure SELinux so that `/backup` (and all its contents) uses the same security context as the `/home` directory (`home_root_t`).
    
3. Ensure this rule is stored in the policy database so it survives a filesystem relabel.
    
4. Apply the context to the directory immediately.
    

- **Aspects/Domains Covered:** Manage security (Manage SELinux file context).
  
  
  Overall explanation

Correct Answer

1. Create the Directory

2. mkdir /backup

3. Verify the Target Context

Check the SELinux context used by `/home`:

1. ls -Zd /home

Example:

1. system_u:object_r:home_root_t:s0 /home

2. Create a Persistent SELinux Rule

3. semanage fcontext -a -t home_root_t "/backup(/.*)?"

4. Apply the New Context

5. restorecon -Rv /backup

6. Verify

Verify the directory label:

1. ls -Zd /backup

Expected output:

1. system_u:object_r:home_root_t:s0 /backup

Verify the policy rule:

1. semanage fcontext -l | grep /backup

Detailed Explanation

- **Why File Contexts Matter**
    

SELinux decisions are based primarily on **security contexts**, not traditional UNIX permissions.

A process is allowed access only if the SELinux policy permits interaction between the process type and the file type.

Simply changing ownership or permissions does **not** change the SELinux label.

- **The SELinux Policy Database**
    

1. semanage fcontext -a -t home_root_t "/backup(/.*)?"

adds a persistent rule to the local SELinux policy database.

The rule is stored in:

1. /etc/selinux/targeted/contexts/files/file_contexts.local

Because it is stored in the policy database, it survives:

- reboots
    
- filesystem relabels
    
- `restorecon`
    
- package updates
    

This satisfies the persistence requirement of the task.

- **Why** `**restorecon**` **Is Required**
    

`semanage` changes only the policy.

It does **not** relabel existing files.

To apply the policy to the filesystem, run:

1. restorecon -Rv /backup

`restorecon` reads the SELinux policy database and updates the labels stored on disk.

Without this step, `/backup` keeps its old label until it is relabeled later.

- **Why Not Use** `**chcon**`**?**
    

Many learners mistakenly use:

1. chcon -t home_root_t /backup

This changes the label immediately but **does not update the SELinux policy database**.

The label disappears after:

- `restorecon`
    
- filesystem relabel
    
- some package operations
    

Therefore **chcon alone is not a correct solution** for RHCSA tasks requiring persistent labeling.

- **Understanding the Regular Expression**
    

1. /backup(/.*)?

This expression matches:

- `/backup`
    
- `/backup/file`
    
- `/backup/dir`
    
- `/backup/dir/file`
    
- every object beneath `/backup`
    

The expression must be quoted so the shell does not interpret the parentheses or wildcard.

Always use an **absolute path** with `semanage`.

- **Verification**
    

Display the directory context:

1. ls -Zd /backup

Display contexts for files beneath it:

1. ls -ZR /backup

Display the policy rule:

1. semanage fcontext -l | grep /backup

Dry-run a relabel:

1. restorecon -Rvn /backup

If `restorecon -n` produces no output, the labels already match the SELinux policy.

- **Typical Use Cases**
    

Persistent custom file contexts are commonly used for:

- relocating home directories
    
- custom Apache document roots
    
- FTP data directories
    
- Samba shares
    
- application storage outside standard locations
    

The procedure is always the same:

1. `semanage fcontext`
    
2. `restorecon`
    

Common Mistakes

- Using `chcon` instead of `semanage fcontext`.
    
- Running `semanage` but forgetting `restorecon`.
    
- Forgetting the recursive regular expression `(/.*)?`.
    
- Using a relative path instead of an absolute path.
    
- Verifying only the on-disk label without confirming the policy rule.
    

Exam Tip

Before moving on, verify both the **current label** and the **persistent policy**.

Check the on-disk label:

1. ls -Zd /backup

Check the stored SELinux rule:

1. semanage fcontext -l | grep /backup

A correct RHCSA solution always includes **both** `semanage fcontext` and `restorecon`. A directory labeled correctly with `chcon` alone will lose its label the next time the system performs a relabel.


**Question 28**

**Task:** Configure complex firewall rules on **ServerB**.

1. Allow **HTTP** traffic (Port 80) **only** from the source network `192.168.1.0/24`.
    
2. **Reject** HTTP traffic from all other sources.
    
3. Use **Firewall Rich Rules** to accomplish this.
    
4. Ensure the configuration is permanent.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewalld).
  
  
  Overall explanation

**Correct Answer:**

1. **Add Rich Rule:**
    
    1. firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="http" accept'
    
2. **Ensure Default is not "Allow All":**
    
    - _Note:_ You typically do not need to explicitly "Reject" others if you haven't added the generic `http` service. Just adding the rich rule is enough if the generic service isn't enabled. However, if the question asks to explicitly reject:
        
        1. firewall-cmd --permanent --add-rich-rule='rule family="ipv4" service name="http" reject'
        
3. **Reload:**
    
    1. firewall-cmd --reload
    
4. **Verify:**
    
    1. firewall-cmd --list-rich-rules
    

**Detailed Explanation for Learners:**

- **Rich Rules:** Standard rules (`--add-service=http`) open the port to the whole world. Rich Rules allow logic: "Allow Service X _IF_ Source is Y."
    
- **Syntax:** It is strict. Use single quotes `'...'` around the whole rule string to prevent the shell from misinterpreting spaces.
  
  
  **Question 29**

**Task:** Create a system audit script on ServerB.

- Create a script `/usr/local/bin/audit_suid.sh`.
    
- The script should find all files in `/usr` that have the **SUID** (Set User ID) bit set.
    
- It should only list files smaller than **5MiB**.
    
- Save the list of found files to `/root/suid_files.txt`.
    
- Make the script executable.
    

**Aspects/Domains Covered:** Create simple shell scripts, Understand and use essential tools (Use find), Manage security (Manage default file permissions).


Overall explanation

**Correct Answer:**

1. **Create Script:** `vim /usr/local/bin/audit_suid.sh`
    
2. **Add Content:**
    
    1. #!/bin/bash
    2. find /usr -type f -perm /4000 -size -5M > /root/suid_files.txt
    
3. **Make Executable:** `chmod +x /usr/local/bin/audit_suid.sh`
    

**Detailed Explanation for Learners:**

- **-perm /4000:**
    
    - **4** in the thousands place represents **SUID** (Set User ID).
        
    - **/** means "At least this bit" (inclusive search).
        
- **Why Audit SUID?** Files with the SUID bit run with the permissions of the file owner (usually root), not the user running them. Sysadmins frequently audit these files to ensure no unauthorized binaries allow users to gain root access. This is a vital security skill, distinct from the deprecated "SGID for collaboration" topic.
  
  
  **Question 30**

**Task:** Configure system logging on **ServerB**.

1. Configure **Rsyslog** to send all messages with the priority **debug** (from any facility) to a specific file: `/var/log/debug_messages.log`.
    
2. Restart the `rsyslog` service to apply the change.
    
3. Generate a test debug message using the `logger` command to verify.
    

- **Aspects/Domains Covered:** Operate running systems (Locate and interpret system log files).
  
  
  Overall explanation

Correct Answer

1. Create an Rsyslog Configuration File

Create:

1. /etc/rsyslog.d/debug.conf

Add the following line:

1. *.debug    /var/log/debug_messages.log

2. Restart Rsyslog

3. systemctl restart rsyslog

4. Verify

Generate a test message:

1. logger -p user.debug "This is a test debug message"

Display the log:

1. cat /var/log/debug_messages.log

The file should contain:

1. This is a test debug message

Detailed Explanation

- **How Rsyslog Selectors Work**
    

Every rsyslog rule has the form:

1. facility.priority    destination

In this task:

1. *.debug

means:

- `*` → every facility
    
- `debug` → debug priority and all higher priorities
    

Therefore, every message generated at **debug** or a more severe level is written to the destination file.

- **Facilities**
    

A facility identifies the subsystem generating the message.

Common facilities include:

- `auth`
    
- `authpriv`
    
- `cron`
    
- `daemon`
    
- `kern`
    
- `mail`
    
- `user`
    
- `local0`–`local7`
    

The command:

1. logger

uses the **user** facility by default unless another facility is specified.

- **Priority Levels**
    

From least severe to most severe:

PriorityMeaningdebugDiagnostic informationinfoInformational messagesnoticeNormal but significant eventswarningWarning conditionserrError conditionscritCritical conditionsalertImmediate action requiredemergSystem unusable

A selector such as:

1. *.debug

matches **debug and everything above it**.

If you wanted **only** debug messages, use:

1. *.=debug

- **journald vs. rsyslog**
    

On modern RHEL systems:

**systemd-journald**

- Collects logs from the kernel and services
    
- Stores structured journal files
    
- Accessed using:
    

1. journalctl

**rsyslog**

- Receives messages from journald
    
- Routes messages according to configured rules
    
- Writes traditional text log files
    
- Can forward logs to remote log servers
    

The two services work together rather than replacing one another.

- **Why Use** `**/etc/rsyslog.d/**`
    

Instead of editing:

1. /etc/rsyslog.conf

create a separate configuration file under:

1. /etc/rsyslog.d/

This keeps custom configuration separate from package-managed files and is the recommended RHEL practice.

- **Testing with** `**logger**`
    

Generate a debug message:

1. logger -p user.debug "This is a test debug message"

The options mean:

- `user` → facility
    
- `debug` → priority
    

You can also specify a tag:

1. logger -t RHCSA -p user.debug "Debug test"

The tag helps identify the message in logs.

- **Verification**
    

Generate the message:

1. logger -p user.debug "This is a test debug message"

View the new log:

1. tail /var/log/debug_messages.log

Verify the message also exists in the journal:

1. journalctl -t root -n 5

or, if a custom tag was used:

1. journalctl -t RHCSA

If the message appears in the journal but **not** in the file, the problem is usually:

- incorrect rsyslog rule
    
- configuration syntax error
    
- forgetting to restart rsyslog
    

- **Log Rotation**
    

Unlike **systemd-journald**, rsyslog does not automatically manage the size of its log files.

Files written by rsyslog are typically rotated by **logrotate**.

Preview log rotation without making changes:

1. logrotate -d /etc/logrotate.conf

Common Mistakes

- Editing `/etc/rsyslog.conf` instead of creating a file in `/etc/rsyslog.d/`.
    
- Forgetting to restart `rsyslog`.
    
- Using the wrong selector (such as `*.info` instead of `*.debug`).
    
- Assuming `journalctl` verifies rsyslog configuration.
    
- Forgetting to generate a test message after making the configuration change.
    

Exam Tip

Before moving on, verify the complete logging pipeline.

Generate a message:

1. logger -p user.debug "RHCSA test"

Then immediately verify it appears in:

1. tail /var/log/debug_messages.log

A complete RHCSA solution demonstrates that **Rsyslog successfully receives, filters, and writes the message** after the service restart, and that the configuration file under `/etc/rsyslog.d/` persists across future reboots.


