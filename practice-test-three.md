**Question 1**

**Task:** You have forgotten the root password for **ServerB**.

1. Reset the root password to `passmypass` to regain access to the system.
    
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

**Task:** Configure a software repository on **ServerB** using the provided HTTP server.

1. Configure a DNF repository to install packages from the URL http://192.168.1.12/rhel10/BaseOS.
    
2. Configure a second repository for the URL http://192.168.1.12/rhel10/AppStream.
    
3. Ensure GPG checking is disabled for both repositories.
    
4. Verify that the repositories are functional.
    

- **Aspects/Domains Covered:** Manage software (Configure access to RPM repositories).

Overall explanation

**Correct Answer**

1. Create the Repository File

Create:

1. /etc/yum.repos.d/http.repo

2. [BaseOS_HTTP]
3. name=BaseOS via HTTP
4. baseurl=http://192.168.1.12/rhel10/BaseOS
5. enabled=1
6. gpgcheck=0

7. [AppStream_HTTP]
8. name=AppStream via HTTP
9. baseurl=http://192.168.1.12/rhel10/AppStream
10. enabled=1
11. gpgcheck=0

12. Verify

13. dnf clean all
14. dnf repolist

**Detailed Explanation**

- **Repo Configuration**  
    RHEL supports local file paths (`file://`), HTTP servers (`http://`), and FTP servers (`ftp://`) for repositories. In enterprise environments, you often pull updates from a central Satellite server or a local mirror via HTTP.
    
- `**dnf clean all**`  
    This forces DNF to forget old metadata and download fresh lists from your new URL, ensuring the connection works.
    
- **Why HTTP Repositories Are Common in Enterprise Environments**  
    One web server can serve hundreds of hosts, so packages are staged and patched in a single place instead of on every machine. HTTP works through firewalls and proxies that block NFS or FTP, needs no client credentials or mounts, and the same URL can front a mirror, a Satellite server, or a plain `httpd` directory. That is why the exam gives you a URL rather than an ISO for this task.
    
- **Metadata Is Cached, So Refresh It**  
    DNF keeps repository metadata under `/var/cache/dnf` and will happily serve a stale copy after you edit a `.repo` file. `dnf clean all` discards that cache and forces a fresh download from the new URL — which is why it appears before `dnf repolist` in the answer above. Skip it and a repository that is configured perfectly can still look broken.
    
- **Verifying Repository Availability**
    
    1. dnf repolist
    
    2. dnf repolist --all
    
    3. dnf repoinfo BaseOS_HTTP
    
    `dnf repolist` lists the enabled repository IDs and their package counts — a repository showing **0 packages** is reachable but empty. `--all` also shows disabled ones, which is how you spot an `enabled=0` you did not intend. `dnf repoinfo <id>` prints the full detail for one repository: the base URL actually in use, the `gpgcheck` setting, and the metadata timestamp — the fastest way to prove the file you edited is the file DNF is reading.
    
- **Common Troubleshooting**
    
    - **Incorrect BaseOS/AppStream path** — the base URL must point at the directory that contains `repodata`, not at its parent. `http://192.168.1.12/rhel10/BaseOS` is correct; `http://192.168.1.12/rhel10` is not. Browse the URL with `curl` to check.
        
    - **Missing** `**repodata**` — if:
        
        1. curl http://192.168.1.12/rhel10/BaseOS/repodata/repomd.xml
        
        returns **404**, the metadata was never generated or the ISO was copied without it. On the server side that is `createrepo_c`, but on the exam it usually means the wrong path.
        
    - **Firewall** — the server must allow HTTP. A repository that times out rather than **404s** is almost always:
        
        1. firewall-cmd --permanent --add-service=http
        
        missing on the server, not a client problem.
        
    - **HTTP service unavailable** — check:
        
        1. systemctl is-active httpd
        
        on the server and confirm SELinux allows it to read the content directory. A **403** points at SELinux labelling or file permissions; a **connection refused** points at the service being down.
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For a repository, that means:
    
    1. dnf repolist
    
    shows a non-zero package count and:
    
    1. `dnf install <package>`
    
    actually resolves. The `.repo` file is already persistent, but confirm it still works after a reboot in case the network profile does not autoconnect.


**Question 3**

**Task:** On **ServerB**, modify the active network connection to use the following static settings:

- **IPv4:** 192.168.1.4/24, Gateway: 192.168.1.1, DNS: 8.8.8.8.
    
- **IPv6:** fd01::103/64, Gateway: fd01::100, DNS: fd01::111.
    
- **Secondary IPs:** Add the secondary IPv4 address 10.0.0.4/24 to the same interface.
    
- Ensure these settings are persistent and applied immediately.
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4 and IPv6 addresses).


Overall explanation

**Correct Answer**

1. Identify the Connection Name

2. nmcli con show

Assume the connection is named `**enp0s3**` or `**Wired connection 1**`.

2. Apply the Primary Settings

3. nmcli con mod "enp0s3" \
4. ipv4.method manual ipv4.addresses 192.168.1.4/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 \
5. ipv6.method manual ipv6.addresses fd01::103/64 ipv6.gateway fd01::100 ipv6.dns fd01::111

6. Add the Secondary IPv4 Address

7. nmcli con mod "enp0s3" +ipv4.addresses 10.0.0.4/24

8. Activate the Connection

9. nmcli con up "enp0s3"

**Detailed Explanation**

- **Merging Tasks**  
    This covers the requirements of old **Q3**, **Q4**, and **Q5**.
    
- **Syntax**  
    `ipv4.method manual` turns off DHCP.
    
- **The** `**+**` **Sign**  
    Using `+ipv4.addresses` appends the IP. If you omit the `+`, it overwrites the IP you set in step 2.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For networking:
    
    1. nmcli con show --active
    
    and
    
    2. ip addr show
    
    confirm it works now, while:
    
    3. nmcli con show "enp0s3" | grep autoconnect
    
    returning:
    
    4. yes
    
    is what makes it survive the reboot.

**Question 4**

**Task:** Configure kernel runtime parameters on **ServerB** to enable packet forwarding.

1. Enable **IPv4** packet forwarding (`net.ipv4.ip_forward`).
    
2. Enable **IPv6** packet forwarding (`net.ipv6.conf.all.forwarding`).
    
3. Ensure both settings persist across reboots.
    

- **Aspects/Domains Covered:** Operate running systems (Modify system kernel parameters / Tune systems).

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

**Question 5 (New Topic: Systemd Timers)**

**Task:** On ServerB, create a scheduled task using Systemd Timer Units.

1. Create a script /usr/local/bin/break-time.sh that prints "Break Time!" to the current user's terminal (or logs it to a file /tmp/break.log for simpler verification). Make it executable.
    
2. Create a service unit break-time.service to execute this script.
    
3. Create a timer unit break-time.timer that runs this service every **2 hours**.
    
4. Ensure the timer is active and enabled.
    

**Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using systemd timer units)


Overall explanation

**Correct Answer**

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/break-time.sh
3. echo 'echo "Break Time!" >> /tmp/break.log' >> /usr/local/bin/break-time.sh
4. chmod +x /usr/local/bin/break-time.sh

5. Create the Service Unit

Create the file:

1. /etc/systemd/system/break-time.service

2. [Unit]
3. Description=Break Time Service

4. [Service]
5. Type=oneshot
6. ExecStart=/usr/local/bin/break-time.sh

7. Create the Timer Unit

Create the file:

1. /etc/systemd/system/break-time.timer

2. [Unit]
3. Description=Run Break Time every 2 hours

4. [Timer]
5. # Kickstart: Runs 1 minute after boot to start the cycle
6. OnBootSec=1m

7. # Loop: Runs 2 hours after the service last finished
8. OnUnitActiveSec=2h

9. Unit=break-time.service

10. [Install]
11. WantedBy=timers.target

12. Activate

13. systemctl daemon-reload
14. systemctl enable --now break-time.timer

**Detailed Explanation for Learners**

- **The "Chicken and Egg" Fix**  
    We added `OnBootSec=1m`.
    
- **Why** `**OnBootSec=1m**`**?**  
    If you only use `OnUnitActiveSec`, the timer waits for the service to finish before starting the countdown. If the service has never run (which is true for a new install), the timer stays in `n/a` forever.
    
- **How It Works**  
    `OnBootSec` triggers the first run shortly after startup. Once that first run finishes, `OnUnitActiveSec` takes over to schedule the subsequent runs every **2 hours**.
    
- **Why Systemd Timers?**  
    They are preferred over Cron in RHEL 10 because they handle missed runs (if configured with `Persistent=true`) and log output directly to the system journal.
    
- **Service and Timer Units Are a Pair**  
    The timer carries only the schedule; the work lives in `break-time.service`. That is why this answer creates two unit files. `Unit=break-time.service` names the unit to activate — systemd would pair the two automatically because the base names match, but stating it is good practice and becomes mandatory the moment the names differ.
    
- `**OnBootSec**` **and** `**OnUnitActiveSec**` **Are Relative (Monotonic) Timers**
    
    - `OnBootSec=1m` fires once, one minute after boot.
        
    - `OnUnitActiveSec=2h` fires two hours after the associated service was last activated, and keeps repeating on that cadence.
        
    
    Used together they give you:
    
    "Start soon after boot, then every two hours."
    
    — which is exactly what this task asks for.
    
- **Why** `**OnBootSec**` **Prevents a Newly Created Timer from Remaining Inactive**  
    `OnUnitActiveSec` measures from the service's last activation. On a freshly created timer the service has never run, so there is no "last activation" to count from and the timer sits there with no scheduled elapse — `systemctl list-timers` shows a **NEXT** of `n/a`. `OnBootSec` supplies that first trigger; once the service has run once, `OnUnitActiveSec` has a reference point and takes over the cycle.
    
- `**Persistent=true**` **Does Not Apply Here**  
    It is a calendar-timer option that makes systemd catch up a run missed while the machine was off, using the last-run state under `/var/lib/systemd/timers/`. It works with `OnCalendar=`, not with the monotonic `OnBootSec` and `OnUnitActiveSec` used above — monotonic timers restart their count from boot anyway, so there is nothing to catch up. Reach for `Persistent=true` when a task says **"daily at 02:00"** and the machine may be off at that hour.
    
- **Why** `**daemon-reload**` **Is Required**  
    systemd keeps unit files cached in memory. Until you run `systemctl daemon-reload`, a newly created unit does not exist as far as systemd is concerned and an edited one still runs its previous version. Run it after every change under `/etc/systemd/system/`. Note that you enable and start the **timer**, never the **service** — enabling the service would run the script once at boot and lose the schedule.
    
- **Verifying the Timer and Reading Its Logs**
    
    1. systemctl list-timers
    
    2. systemctl list-timers --all
    
    3. systemctl status break-time.timer
    
    4. journalctl -u break-time.service
    
    `list-timers` shows **NEXT**, **LEFT**, **LAST**, and **PASSED** for active timers — add `--all` to include inactive ones, which is how you catch a timer that loaded but never scheduled. `status` confirms the unit is loaded, active, and enabled. `journalctl -u break-time.service` is the only one that proves the script actually ran;
    
    5. cat /tmp/break.log
    
    confirms the output the task asked for.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Confirm:
    
    1. systemctl is-enabled break-time.timer
    
    returns `enabled`, then reboot and check:
    
    2. systemctl list-timers
    
    still shows a future run.
**Question 6**

**Task:** Configure local storage on **ServerB** using the disk /dev/sdb (Standard Partitioning, not LVM).

1. Create a **512MiB** partition on /dev/sdb.
    
2. Format the partition with the **ext4** file system.
    
3. Ensure the partition is automatically mounted at boot under the directory /mnt/data.
    
4. Use the partition's **UUID** in the configuration file to ensure persistence.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Configure systems to mount file systems at boot).

Overall explanation

**Correct Answer**

1. Create the Partition

2. fdisk /dev/sdb

Type `n` (new), **Enter**, **Enter**, `+512M`, `w` (write).

1. partprobe /dev/sdb

2. Format the Partition

3. mkfs.ext4 /dev/sdb1

_(Assuming_ `_sdb1_` _is the new partition.)_

3. Create the Mount Point

4. mkdir -p /mnt/data

5. Configure Persistent Mounting

Get the UUID

1. lsblk -f /dev/sdb1

Edit `/etc/fstab`

1. vim /etc/fstab

Add the Following Line

1. `UUID=<your-uuid-here>`  /mnt/data  ext4  defaults  0 0

2. Verify

3. mount -a

4. df -h /mnt/data

**Detailed Explanation for Learners**

- `**partprobe**`  
    When you create a partition on a disk that is already in use, the kernel might not see it immediately. `partprobe` forces the kernel to re-read the partition table without a reboot.
    
- **Standard vs. LVM**  
    This task specifically asks for a **standard partition**. Do **not** create Physical Volumes (PV) or Volume Groups (VG) here. Just format the partition directly (`mkfs`).
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For storage, run:
    
    1. mount -a
    
    before you reboot — a bad `/etc/fstab` entry drops the system into emergency mode — then confirm with:
    
    2. lsblk -f
    
    and
    
    3. df -h /mnt/data
    
    Using `UUID=` rather than a device name is what keeps the mount correct if disks are re-detected in a different order.


**Question 7**

**Task:** Manage user accounts on **ServerB**.

1. **Modify User:** Change the user `sam`'s default login shell to `/bin/bash`.
    
2. **Create User:** Create a new user named `john`.
    
    - Assign the specific **UID** `1250`.
        
    - Set the account to **expire** on **December 21, 2029**.
        

- **Aspects/Domains Covered:** Manage users and groups (Create/modify local user accounts).
Overall explanation

**Correct Answer:**

1. **Modify Sam:**
    
    1. usermod -s /bin/bash sam
    
2. **Create John:**
    
    1. useradd -u 1250 -e 2029-12-21 john
    
3. **Verify:**
    
    1. grep sam /etc/passwd
    2. chage -l john
    

**Detailed Explanation for Learners:**

- `**usermod -s**`**:** Updates the shell field in `/etc/passwd`. If a user is stuck in `/bin/sh` or `/sbin/nologin`, they cannot use the standard Bash terminal features.
    
- `**useradd -e**`**:** Sets the expiration date (YYYY-MM-DD). This is useful for temporary contract workers. After this date, the user cannot log in, even if they have the correct password.



**Question 8**

**Task:** Configure granular file permissions (ACLs) on **ServerB**.

1. Copy the file `/etc/hosts` to `/var/nhosts`.
    
2. Configure Access Control Lists (ACLs) on `/var/nhosts` with the following requirements:
    
    - User `sam` must have **Read, Write, and Execute** permissions.
        
    - User `john` must have **Read-only** permission.
        
    - Ensure the file's standard owner and group permissions are not negatively affected.
        

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - utilizing ACLs).

Overall explanation

**Correct Answer:**

1. **Prepare File:**
    
    1. cp /etc/hosts /var/nhosts
    
2. **Set ACL for Sam:**
    
    1. setfacl -m u:sam:rwx /var/nhosts
    
3. **Set ACL for John:**
    
    1. setfacl -m u:john:r /var/nhosts
    
4. **Verify:**
    
    1. getfacl /var/nhosts
    

**Detailed Explanation for Learners:**

- `**setfacl**`**:** This tool allows you to add permissions for specific users _on top of_ the standard owner/group permissions.
    
- `**-m**`**:** Modify mode.
    
- `**u:username:perm**`**:** The syntax is strict. `u` for user, followed by the username, followed by the permission shorthand (`r`, `w`, `x`, or `-`).

**Question 9 (New Topic: Flatpak)**

**Task:** Manage applications on **ServerB** using **Flatpak**.

1. Add the remote repository named `flathub` using the URL `https://dl.flathub.org/repo/flathub.flatpakrepo`.
    
2. Install the application `org.gnome.Calculator` from the `flathub` remote.
    

- **Aspects/Domains Covered:** Manage software (Configure access to Flatpak repositories, Install Flatpak software).

Overall explanation

**Correct Answer:**

1. **Add Remote:**
    
    1. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
2. **Install Application:**
    
    1. flatpak install flathub org.gnome.Calculator -y
    

**Detailed Explanation for Learners:**

- **New RHEL 10 Standard:** Managing desktop applications via RPM is becoming less common. Flatpak isolates the app from the OS.
    
- `**remote-add**`**:** Conceptually identical to adding a repo in DNF.
    
- `**install**`**:** Downloads the application image and its runtime environment.

**Question 10**

**Task:** Configure **LVM (Logical Volume Manager)** storage on **ServerB**.

1. Create a volume group named vgroup using the disk partition /dev/sdb2 (Create the partition first if needed, size 4GiB).
    
2. Create a logical volume named lvol with a size of **1GiB**.
    
3. Format lvol with **ext4** and mount it persistently at /lvol.
    
4. **Extend** the logical volume by **100MiB** and ensure the filesystem recognizes the new space.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Extend existing logical volumes).


Overall explanation

**Correct Answer**

1. Prepare the Partition (If Not Present)

2. fdisk /dev/sdb

Create **partition 2**, size `+4G`, type `8e` (Linux LVM).

1. pvcreate /dev/sdb2

2. Create the Volume Group and Logical Volume

3. vgcreate vgroup /dev/sdb2

4. lvcreate -n lvol -L 1G vgroup

5. Format and Mount

6. mkfs.ext4 /dev/vgroup/lvol
7. mkdir /lvol
8. echo "/dev/vgroup/lvol /lvol ext4 defaults 0 0" >> /etc/fstab
9. mount -a

10. Extend the Logical Volume

11. lvextend -r -L +100M /dev/vgroup/lvol

**Detailed Explanation for Learners**

- **Type** `**8e**`  
    When using `fdisk`, setting the partition type to **8e (Linux LVM)** is a best practice to label the disk correctly, though `pvcreate` will work without it.
    
- `**lvextend -r**`  
    This command does two jobs: it expands the Logical Volume (the container) and then runs `resize2fs` (for ext4) to expand the filesystem (the contents) to fill the new space.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For LVM:
    
    1. pvs
    
    2. vgs
    
    3. lvs
    
    should each show the names and sizes the task asked for, and:
    
    4. df -h /lvol
    
    should show the filesystem at its extended size — `lvextend` without `-r` grows the volume but leaves the filesystem unchanged.

**Question 11**

**Task:** Optimize **ServerB** performance using **Tuned**.

1. Install and enable the `tuned` service.
    
2. Configure the system to use **two** profiles simultaneously: `virtual-guest` and `powersave`.
    
3. Ensure the settings persist.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).
Overall explanation

**Correct Answer:**

1. **Install and Enable:**
    
    1. dnf install tuned -y
    2. systemctl enable --now tuned
    
2. **Apply Combined Profiles:**
    
    1. tuned-adm profile virtual-guest powersave
    
3. **Verify:**
    
    1. tuned-adm active
    2. # Output: Current active profile: virtual-guest powersave
    

**Detailed Explanation for Learners:**

- **Combining Profiles:** RHEL allows you to stack profiles. The syntax is `tuned-adm profile <profile1> <profile2>`.
    
- **Priority:** If both profiles try to change the same setting, the _last_ profile specified in the command takes precedence. In this case, `powersave` settings would override conflicting `virtual-guest` settings.
    
- **Use Case:** This is common for VMs running in cloud environments where you want the VM optimizations (`virtual-guest`) but also want to save money/energy when the VM is idle (`powersave`).

**Question 12**

**Task:** Create a shell script named /usr/local/bin/sum.sh on **ServerB**.

1. The script should interactively prompt the user to "Enter the first number".
    
2. Then prompt the user to "Enter the second number".
    
3. Calculate the sum of the two numbers.
    
4. Print the result in the format: "The result of addition=[sum]".
    
5. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Processing output, simple math).

Overall explanation

**Correct Answer**

1. Create the Script

2. vim /usr/local/bin/sum.sh

3. Add the Following Content

4. #!/bin/bash
5. echo "Enter the first number"
6. read num1
7. echo "Enter the second number"
8. read num2
9. sum=$((num1 + num2))
10. echo "The result of addition=$sum"

11. Make the Script Executable

12. chmod +x /usr/local/bin/sum.sh

13. Verify

14. /usr/local/bin/sum.sh

Enter **5**, then **5**.  
Result should be:

1. The result of addition=10

**Detailed Explanation for Learners**

- `**read variable**`  
    Pauses the script and waits for the user to type something. It stores the input in `$variable`.
    
- `**$(( ... ))**`  
    This is the standard Bash syntax for **Arithmetic Expansion**. It performs math on integers.
    
- **Interactive vs. Arguments**  
    This script is interactive (prompts you while running). Other exam scripts might use arguments (`$1`, `$2`), which are typed on the command line before running. Read the exam question carefully to know which one they want!
    
- **Always Start with the Shebang**  
    `#!/bin/bash` on line 1 tells the kernel which interpreter to use. Without it the script may be run by whatever shell happens to invoke it, and `$(( ))` or `read` can behave differently. Every RHCSA scripting task expects it.
    
- **Executable Permissions**  
    A script is not a program until `chmod +x` is applied — otherwise you get **"Permission denied"** even as root. Check with:
    
    1. ls -l /usr/local/bin/sum.sh
    
    and look for the `x` bits. Because `/usr/local/bin` is already on `PATH`, `sum.sh` then works from any directory; a script elsewhere needs `./sum.sh`.
    
- **Quote Your Variables**  
    Write:
    
    1. echo "The result of addition=$sum"
    
    not:
    
    2. echo The result of addition=$sum
    
    Unquoted values are split on spaces and expanded as filename patterns, so a variable holding `my file` or `*` produces surprising output. Quoting costs nothing and prevents a whole class of exam mistakes — the one place you deliberately leave quotes off is inside `$(( ))`, which does its own arithmetic parsing.
    
- **Readability Earns Marks Indirectly**  
    One command per line, two spaces of indentation inside blocks, and lower-case names for your own variables (reserving `UPPER_CASE` for exported environment variables) make a script quick to re-read when a grader's output does not match. A script you can scan is a script you can fix in the minute you have left.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For a script, run it exactly as the task names it:
    
    1. /usr/local/bin/sum.sh
    
    not:
    
    2. bash sum.sh
    
    because that is what the grader does, and it is the only way to catch a missing `chmod +x` or shebang.

**Question 13**

**Task:** Configure a web server on **ServerB**.

1. Install the Apache HTTP Server (httpd).
    
2. Create a custom index file at /var/www/html/index.html containing the text: "Welcome to the RHCSA Practice Exam!".
    
3. Configure the **Firewall** to allow HTTP and HTTPS traffic permanently.
    
4. Ensure the service starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Install software, Start services), Manage security (Configure firewall settings).

Overall explanation

**Correct Answer**

1. Install

2. dnf install httpd -y

3. Configure the Content

4. echo "Welcome to the RHCSA Practice Exam!" > /var/www/html/index.html

5. Configure the Firewall

6. firewall-cmd --permanent --add-service=http
7. firewall-cmd --permanent --add-service=https
8. firewall-cmd --reload

9. Start and Enable the Service

10. systemctl enable --now httpd

11. Verify

12. curl http://localhost

**Detailed Explanation for Learners**

- **Order of Operations**  
    You can configure the content and firewall before or after installing the package, but you cannot start the service until it is installed.
    
- `**firewall-cmd --reload**`  
    Always run this after making `--permanent` changes, or they won't take effect until the next reboot.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For a service:
    
    1. systemctl is-active httpd
    
    and
    
    2. systemctl is-enabled httpd
    
    must both succeed — **running** is not the same as **enabled** — and:
    
    3. firewall-cmd --list-all --permanent
    
    must match the runtime output.

**Question 14**

**Task:** Perform a file search on **ServerB**.

1. Find all files in `/etc` (and its subdirectories) that are **larger than 5MiB**.
    
2. Copy these files to the directory `/find/5mfiles`.
    
3. Create the destination directory if it does not exist.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create directories, Copy files, Use find).


Overall explanation

**Create Directory:**

1. mkdir -p /find/5mfiles

**Find and Copy:**

1. find /etc -type f -size +5M -exec cp {} /find/5mfiles/ \;

**Detailed Explanation for Learners:**

- `**-type f**`: Ensures that the search strictly looks for files, ignoring directories or other special file types. This is a crucial best practice when managing systems.
    
- `**-size +5M**`: Matches files strictly greater than 5 Megabytes. (Use `-5M` for smaller than, `5M` for exactly).
    
- `**-exec cp {} target \;**`: This is an efficient way to copy find results directly.
    
    - `{}` = The filename currently found.
        
    - `\;` = The terminator that tells `find` where the command ends.

**Question 15**

**Task:** Configure user environment policies on **ServerB**.

1. **Skeleton:** Configure the system so that a file named `Welcome` is automatically created in the home directory of every **new** user.
    
2. **Password Aging:** Ensure that passwords for new users expire after **60 days**.
    
3. **Complexity:** Ensure that new passwords must be at least **9 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging/complexity).
Overall explanation

**Correct Answer:**

1. **Skeleton File:**
    
    1. touch /etc/skel/Welcome
    
2. **Password Aging:**
    
    - Edit `/etc/login.defs`:
        
        1. vim /etc/login.defs
        
    - Set:
        
        1. PASS_MAX_DAYS 60
        
3. **Password Length:**
    
    - Edit `/etc/security/pwquality.conf`:
        
        1. vim /etc/security/pwquality.conf
        
    - Set:
        
        1. minlen = 9
        

**Detailed Explanation for Learners:**

- `**/etc/skel**`**:** A simple directory. If you put a folder structure here (e.g., `public_html`, `.ssh`), that structure is replicated for every new user.
    
- `**login.defs**` **vs** `**pwquality**`**:**
    
    - `**login.defs**`**:** Controls _time_ (how long the password lasts).
        
    - `**pwquality.conf**`**:** Controls _content_ (how complex the password is).
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

Overall explanation

**Correct Answer**

**1. Create Groups & Users:**

1. groupadd accounting
2. groupadd finance
3. useradd -G accounting alex
4. useradd -G accounting peter
5. useradd -G finance carl
6. useradd -G finance dan

**2. Create Directories:**

1. mkdir -p /groups/accounting /groups/finance

**3. Set Ownership & Base Permissions:**

1. chgrp accounting /groups/accounting
2. chgrp finance /groups/finance
3. chmod 770 /groups/accounting /groups/finance

**4. Set SGID (Group Inheritance):**

1. chmod g+s /groups/accounting /groups/finance

**5. Set ACL (Cross-Access):** You must set **two** ACLs: one for the directory itself, and one "Default" ACL for future files.

1. # 1. Allow finance to read/execute the current directory
2. setfacl -m g:finance:rx /groups/accounting

3. # 2. Ensure NEW files created inside inherit this permission (Default ACL)
4. setfacl -m d:g:finance:rx /groups/accounting

**Detailed Explanation for Learners**

- **The Logic:** This is a classic real-world scenario. You have two teams (Accounting and Finance). Each needs a private workspace, but Finance needs to audit (read) Accounting's work.
    
- `**chmod g+s**` **(SGID):** Without this, if `alex` creates a file, it is owned by `alex:alex`. Other accountants couldn't edit it. With `g+s`, the file becomes `alex:accounting`, allowing the team to share it.
    
- `**setfacl -m d:**` **(Default ACL):** This is the critical step often missed.
    
    - Standard ACL (`-m g:finance:rx`) only affects the folder _right now_.
        
    - Default ACL (`-m d:g:finance:rx`) acts as a template. It ensures that when `alex` creates a **new** file tomorrow, Linux automatically applies the Read/Execute permission for `finance` to that new file. Without this "Default" rule, Finance would see the folder but get "Permission Denied" on the actual files inside.
**Question 17**

**Task:** Configure SSH security on ServerB.

1. **Root Login:** Edit the SSH configuration to permit root login explicitly.
    
2. **Key-Based Auth:** Configure passwordless SSH login for the root user from **ServerA**.
    
    - Generate a key pair on the source.
        
    - Copy the public key to ServerB's root account.
        
3. **Verify:** Ensure you can log in as root without a password.
    

**Aspects/Domains Covered:** Manage security (Configure key-based authentication for SSH).

Overall explanation

**Correct Answer**

1. Configure the SSH Daemon (On ServerB)

Edit:

1. vim /etc/ssh/sshd_config

Ensure the following line is set:

1. PermitRootLogin yes

Restart the service:

1. systemctl restart sshd

2. Generate and Copy the Keys (Run on Source/Client)

**Note:** In Question 3, we changed ServerB's IP to `192.168.1.4`. We use the IP here to avoid DNS/Host issues.

1. ssh-keygen -t rsa

Press **Enter** for all prompts to accept the defaults.

1. ssh-copy-id root@192.168.1.4

Enter the **root** password once when prompted.

3. Verify

4. ssh root@192.168.1.4

You should log in immediately without a password prompt.

**Detailed Explanation for Learners**

- **IP vs. Hostname**  
    Since Question 3 changed the server's IP address, the hostname **ServerB** might still point to the old IP in `/etc/hosts`. Using the IP address directly (`192.168.1.4`) is a safer exam strategy to avoid connection errors.
    
- **Context**  
    While disabling root login is a security best practice, the exam may ask you to enable it to prove you understand the configuration file, or to set up keys for automation scripts (like Ansible) that run as root.
    
- `**ssh-copy-id**`  
    This command appends your public key (`id_rsa.pub`) to the target user's `~/.ssh/authorized_keys` file and fixes the file permissions automatically (which are very strict).
    
- **Prefer** `**ed25519**` **Keys**  
    `ssh-keygen -t ed25519` is the modern default — a short fixed-size key, fast verification, and no key-size decision to get wrong. Use `ssh-keygen -t rsa` only where you must interoperate with older clients or appliances, and ask for at least **3072 bits** (`ssh-keygen -t rsa -b 3072`) when you do. The RSA command in the answer above is correct and satisfies this task; `ed25519` is the better default for anything you build yourself.
    
- **What** `**authorized_keys**` **Actually Is**  
    A plain-text file at `~/.ssh/authorized_keys` in the target account, holding one public key per line. At login the server checks whether the client can prove it holds the matching private key. Access is granted by adding a line and revoked by deleting one — `ssh-copy-id` simply appends your `.pub` file for you and fixes the permissions.
    
- **File Permissions Are Enforced, Not Advisory**  
    `sshd` refuses keys whose files are group- or world-writable. `~/.ssh` must be `700` and `~/.ssh/authorized_keys` must be `600`, both owned by the account logging in, and the home directory itself must not be group-writable. This is the single most common reason a correctly copied key is ignored.
    
- **Verifying, and Diagnosing a Failure**
    
    1. ssh -v root@192.168.1.4
    
    Read the verbose output for **Offering public key** followed by **Authentication succeeded (publickey)**. If you instead see **Authentications that can continue: password**, the server never accepted the key. On the server:
    
    2. journalctl -u sshd
    
    names the reason — **"Authentication refused: bad ownership or modes"** is the permissions problem above.
    
- **Why SSH Key Authentication May Fail**
    
    - Wrong permissions on `~/.ssh` or `authorized_keys`.
        
    - A hand-made `~/.ssh` that never got its SELinux label, fixed with:
        
        1. restorecon -Rv ~/.ssh
        
    - Copying the private key instead of the `.pub`.
        
    - Editing `sshd_config` without:
        
        1. systemctl restart sshd
        
    - Connecting as the wrong user, since keys are per-account and a key installed for `root` does nothing for anyone else.
        
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Keep your current session open and test the key login from a second terminal. Confirm:
    
    1. systemctl is-enabled sshd
    
    then reboot and test again — a key that works now but not after a restart usually means SELinux labelling on the home directory.

**Question 18**

**Task:** Configure SELinux on **ServerB**.

1. Check the current SELinux status.
    
2. Configure the system to run in **Enforcing** mode.
    
3. Ensure this setting persists after a reboot.
    

- **Aspects/Domains Covered:** Manage security (Set enforcing and permissive modes for SELinux).

Overall explanation

**Correct Answer**

1. Check the Current SELinux Status

2. getenforce

or

1. sestatus

2. Set the Immediate Mode

3. setenforce 1

4. Set the Persistent Mode

Edit:

1. vim /etc/selinux/config

Update the line:

1. SELINUX=enforcing

**Detailed Explanation for Learners**

- **Immediate vs. Persistent**  
    `setenforce` changes the running kernel. Editing the configuration file changes the next boot. You must do both to be fully correct in an exam scenario.
    
- **Troubleshooting**  
    If the system was previously **disabled** (not **permissive**), you must reboot for SELinux to initialize and label the filesystem.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For SELinux:
    
    1. getenforce
    
    reports the running mode, and:
    
    2. sestatus
    
    also shows the **"Mode from config file"** line — checking both is how you prove the immediate change and the persistent one were done.


**Question 19**

**Task:** Perform text processing on **ServerB**.

1. You have a file named `letter` (create it with dummy text containing the word "sam" multiple times).
    
2. Use the `sed` command to replace **every** occurrence of the string "sam" with "Sam".
    
3. Save the result to a new file named `newletter`.
    
4. Ensure the original file `letter` remains unchanged.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Create and edit text files, Use grep/regex/sed).

Overall explanation

**Correct Answer:**

1. **Create Dummy File (if needed):**
    
    1. echo "sam is here. hello sam." > letter
    
2. **Execute Sed:**
    
    1. sed 's/sam/Sam/g' letter > newletter
    
3. **Verify:**
    
    1. cat newletter
    2. # Output: Sam is here. hello Sam.
    

**Detailed Explanation for Learners:**

- `**s/old/new/g**`**:**
    
    - `s`: Substitute.
        
    - `old`: The pattern to find.
        
    - `new`: The replacement.
        
    - `g`: **Global**. Without this, `sed` only replaces the _first_ "sam" on each line and ignores the rest.
        
- **Redirection (**`**>**`**):** `sed` outputs to the screen by default. The `>` captures that output into the file.
    

**Hint:** Use global flag (`**g**`) and check `**man sed**` for examples. This reinforces exam doc-use skills without altering core content.

Question 20:

**Question 20**

**Task:** Perform command output redirection on **ServerB**.

1. Execute the command `echo "Hello There!"`.
    
2. Overwrite the contents of the file `sample.txt` with this output.
    
3. Ensure that if `sample.txt` existed previously, its old content is completely replaced.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use input-output redirection).

Overall explanation

**Correct Answer:**

1. **Execute:**
    
    1. echo "Hello There!" > sample.txt
    

**Detailed Explanation for Learners:**

- `**>**` **(Overwrite):** The single arrow is destructive. It wipes the target file clean before writing.
    
- `**>>**` **(Append):** The double arrow adds to the bottom.
    
- `**2>**` **(Error Redirect):** Redirects error messages (Standard Error) instead of normal output.

**Question 21**

**Task:** Configure a periodic task using **Cron** on **ServerB**.

1. Configure a cron job specifically for the user `root`.
    
2. The job should run **daily at 12:45 AM**.
    
3. The command should find and delete all **empty files** in the `/tmp` directory.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at and cron).
Overall explanation

**Correct Answer:**

1. **Edit Crontab:**
    
    1. crontab -e -u root
    
2. **Add Line:**
    
    1. 45 0 * * * find /tmp -type f -empty -delete
    
3. **Verify:**
    
    1. crontab -l -u root
    

**Detailed Explanation for Learners:**

- **Syntax:** `Minute (0-59) Hour (0-23) Day Month Week`.
    
    - `45 0` = 12:45 AM (0 is midnight).
        
- **User Specific:** The `-u root` flag ensures you are editing root's crontab. If you are already logged in as root, `crontab -e` is sufficient, but being explicit is safer.
    
- **Command:** `find /tmp -type f -empty -delete` is a powerful one-liner to clean up garbage files.
**Question 22**

**Task:** Configure default file permissions (Umask) on **ServerB**.

1. Create a user named `harry`.
    
2. Modify `harry`'s user configuration so that **every time he logs in**, his umask is set to `027`.
    
    - This ensures new **files** created by harry have permissions `640` (`rw-r-----`).
        
    - This ensures new **directories** created by harry have permissions `750` (`rwxr-x---`).
        

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).

Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd harry
    
2. **Edit Profile:**
    
    1. vim /home/harry/.bashrc
    
3. **Add Umask:**
    
    - Add the following line to the bottom of the file:
        
        1. umask 027
        
4. **Verify:**
    
    1. su - harry
    2. umask
    3. # Output: 0027
    4. touch testfile
    5. ls -l testfile
    6. # Output: -rw-r-----
    

**Detailed Explanation for Learners:**

- **Understanding Umask:** The system starts with a "perfect" permission set (777 for folders, 666 for files) and _subtracts_ the umask.
    
    - Files: `666 - 027` = `640` (rw- r-- ---).
        
    - Folders: `777 - 027` = `750` (rwx r-x ---).
        
- **Persistence:** Putting it in `.bashrc` ensures it applies to every new shell session harry opens.Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd harry
    
2. **Edit Profile:**
    
    1. vim /home/harry/.bashrc
    
3. **Add Umask:**
    
    - Add the following line to the bottom of the file:
        
        1. umask 027
        
4. **Verify:**
    
    1. su - harry
    2. umask
    3. # Output: 0027
    4. touch testfile
    5. ls -l testfile
    6. # Output: -rw-r-----
    

**Detailed Explanation for Learners:**

- **Understanding Umask:** The system starts with a "perfect" permission set (777 for folders, 666 for files) and _subtracts_ the umask.
    
    - Files: `666 - 027` = `640` (rw- r-- ---).
        
    - Folders: `777 - 027` = `750` (rwx r-x ---).
        
- **Persistence:** Putting it in `.bashrc` ensures it applies to every new shell session harry opens.

**Question 23**

**Task:** Configure a shared directory with special permissions on **ServerB**.

1. Create a directory `/data/shared`.
    
2. Set permissions so that **everyone** (User, Group, Others) has Read, Write, and Execute access (`777`).
    
3. Set the **Sticky Bit** on this directory to ensure that users can only delete files that _they_ own (preventing users from deleting each other's work).
    

- **Aspects/Domains Covered:** Create and configure file systems (Create and configure set-GID/Sticky directories).
Overall explanation

**Correct Answer:**

1. **Create Directory:**
    
    1. mkdir -p /data/shared
    
2. **Set Permissions (Numeric Method):**
    
    1. chmod 1777 /data/shared
    
    _OR (Symbolic Method):_
    
    2. chmod a+rwx,o+t /data/shared
    
3. **Verify:**
    
    1. ls -ld /data/shared
    2. # Output: drwxrwxrwt (The 't' indicates the Sticky Bit)
    

**Detailed Explanation for Learners:**

- **The Problem:** In a shared folder like `/tmp` or `/data/shared`, if you give `777` permissions, User A can delete User B's files.
    
- **The Solution (Sticky Bit):** Represented by the number `1` in the thousands place (e.g., `1777`) or `+t`. It enforces a rule: "You can only rename or delete a file if you are the **owner** of that file, the **owner** of the directory, or **root**."
**Question 24**

**Task:** Manage shell variables on **ServerB**.

1. Create a variable named EXAM_TYPE with the value RHCSA in your current shell.
    
2. Ensure this variable is **exported**, making it visible to any child processes or subshells started from your current session.
    
3. Store the output of the command date +%F into a variable named TODAY.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs, environment variables).

Overall explanation

**Correct Answer**

1. Set and Export the Variable

2. export EXAM_TYPE="RHCSA"

3. Command Substitution

4. TODAY=$(date +%F)

5. Verify

6. bash

7. echo $EXAM_TYPE

Should print:

1. RHCSA

2. exit

3. echo $TODAY

Should print the date (e.g., `2025-11-20`).

**Detailed Explanation for Learners**

- `**export**`  
    Without `export`, a variable is local. If you run a script, that script runs in a new process (subshell) and won't see your local variables. Exporting makes them global to children.
    
- `**$()**`  
    This is modern syntax for:
    
    "Run this command and paste the result here."
    
    (The older backtick `` `date` `` syntax also works but is harder to read.)
    
- **Command Substitution**  
    `$(command)` runs the command in a subshell and replaces the whole expression with its output, so:
    
    1. TODAY=$(date +%F)
    
    stores the date string rather than the command. Prefer `$( )` over the older backticks: it nests cleanly and is far easier to read. Note the value is captured once, at the moment the assignment runs — `$TODAY` will not change tomorrow.
    
- **Quote Substitutions When You Use Them**  
    `echo "$TODAY"` and `echo "$(date)"` protect the value from word-splitting. This matters most when the output contains spaces, which `date` without `+%F` certainly does. In an assignment such as `TODAY=$(date +%F)` the quotes are optional, but adding them is never wrong.
    
- **No Spaces Around** `**=**`  
    `EXAM_TYPE="RHCSA"` is an assignment; `EXAM_TYPE = "RHCSA"` is Bash trying to run a command called `EXAM_TYPE`. This is the most common beginner error in shell scripting, and the error message (**"command not found"**) does not obviously point at the cause.
    
- **Where an Exported Variable Actually Survives**  
    `export` makes a variable visible to child processes of this shell only. It is gone at logout. If a task asks for a variable that persists, it belongs in `~/.bashrc` for one user or a file under `/etc/profile.d/` for everyone — that distinction is the persistence half of the objective.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Verify a variable the way a grader would:
    
    1. bash -lc "echo $EXAM_TYPE"
    
    starts a fresh login shell, so it proves the value survives outside your current session rather than only in it.

**Question 25**

**Task:** Manage process priorities on **ServerB**.

1. Start the command `sleep 1000` in the background.
    
2. Assign it a specific **Nice** level of `15` _when you start it_.
    
3. Verify the nice level of the running process.
    
4. Change the nice level of this running process to `10` (Higher priority/Less nice).
    

- **Aspects/Domains Covered:** Operate running systems (Adjust process scheduling).
Overall explanation

**Correct Answer:**

1. **Start with Nice:**
    
    1. nice -n 15 sleep 1000 &
    
2. **Verify:**
    
    1. ps -eo pid,ni,comm | grep sleep
    2. # Output should show '15' in the NI column.
    
3. **Renice:**
    
    1. # Get PID from previous step, e.g., 1234
    2. renice -n 10 -p 1234
    

**Detailed Explanation for Learners:**

- **Nice (**`**nice**`**):** Used when _starting_ a command.
    
- **Renice (**`**renice**`**):** Used for _existing_ processes.
    
- **Values:** Range is `-20` (Highest Priority) to `19` (Lowest Priority). Default is `0`.
    
- **Privilege:** Anyone can make their processes _nicer_ (higher number). Only root can make processes _meaner_ (lower number/higher priority).
**Question 26**

**Task:** Create a shell script named /usr/local/bin/user-list.sh on **ServerB**.

1. The script must use a **loop** (for/while) to iterate through the following list of usernames: root, bin, and daemon.
    
2. For each user, the script should print: "Processing user: [username]".
    
3. Ensure the script is executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs).Overall explanation

**Correct Answer**

1. Create the Script

2. vim /usr/local/bin/user-list.sh

3. Add the Following Content

4. #!/bin/bash
5. for USER in root bin daemon
6. do
7.   echo "Processing user: $USER"
8. done

9. Make the Script Executable

10. chmod +x /usr/local/bin/user-list.sh

11. Verify

12. /usr/local/bin/user-list.sh

**Detailed Explanation for Learners**

- **The** `**for**` **Loop**  
    This structure allows you to execute a block of code repeatedly.
    
- `**for VARIABLE in LIST**`  
    Assigns the next item in the list to `$VARIABLE`.
    
- `**do ... done**`  
    The block of code to execute for each item.
    
- **Real-World Use**  
    SysAdmins use loops to perform batch actions, like:
    
    "For every server in this list, copy this update file."
    
- **Quote the Loop Variable**  
    Write:
    
    1. echo "Processing user: $USER"
    
    Unquoted, a list item containing spaces would be split into two iterations' worth of output. It costs nothing here and saves you when the list comes from a file or a command.
    
- **Building the List with Command Substitution**  
    The list after `in` can be generated rather than typed:
    
    1. for user in $(cut -d: -f1 /etc/passwd)
    
    loops over every account on the system. That is the pattern behind most real administrative loops, and it is why command substitution and loops are usually examined together.
    
- **A Note on the Variable Name**  
    `USER` is an existing environment variable holding your login name, and the loop overwrites it for the rest of the session. The script above works and satisfies the task, but naming your own loop variable in lower case:
    
    1. for user in root bin daemon
    
    avoids clobbering environment variables and is the habit worth building.
    
- **Readability and Executable Permissions**  
    Indent the loop body by two spaces so `do` and `done` line up, keep one command per line, and remember:
    
    1. chmod +x
    
    Without the executable bit the script fails with **"Permission denied"** no matter how correct the loop is.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. Run the script by its full path exactly as the task names it and check the output line by line — a loop that prints three lines when the task expects three is the whole grading criterion here.
    

**Question 27**

**Task:** Configure **LVM Thin Provisioning** on **ServerB**.

1. Create a new partition on /dev/sdb (e.g., /dev/sdb3) of size **1GiB** and create a Volume Group named thin_vg on it.
    
2. Create a **Thin Pool** named my_thin_pool with a size of **500MiB** inside thin_vg.
    
3. Create a **Thin Volume** named thin_vol inside this pool. Set its virtual size to **2GiB**.
    
4. Format thin_vol with **xfs** and mount it persistently at /mnt/thin.
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes - specifically Thin Provisioning).
Overall explanation

**Correct Answer**

1. Prepare the Physical Volume and Volume Group

2. fdisk /dev/sdb

Create **partition 3**, size `+1G`, type `8e` (Linux LVM).

1. pvcreate /dev/sdb3

2. vgcreate thin_vg /dev/sdb3

3. Create the Thin Pool

4. lvcreate -L 500M -T thin_vg/my_thin_pool

5. Create the Thin Volume

6. lvcreate -V 2G -T thin_vg/my_thin_pool -n thin_vol

7. Format and Mount

8. mkfs.xfs /dev/thin_vg/thin_vol
9. mkdir /mnt/thin
10. echo "/dev/thin_vg/thin_vol /mnt/thin xfs defaults 0 0" >> /etc/fstab
11. mount -a

**Detailed Explanation for Learners**

**Thick vs. Thin**

- **Thick (Standard)**  
    If you create a **2GB** volume, it reserves **2GB** of disk space immediately.
    
- **Thin**  
    You create a **Pool** (**500MB**). Then you create a **Volume** (**2GB**). The volume thinks it is **2GB**, but it only takes up space in the pool as you write data.
    
- **Over-Provisioning**  
    Thin provisioning allows you to promise more storage (**2GB**) than you actually have (**500MB**), assuming users won't fill it up all at once.
    
- **Thin Pool**  
    `lvcreate -L 500M -T thin_vg/my_thin_pool` creates a special logical volume that owns real extents from the volume group — **500 MiB** of actual disk here — plus a small metadata volume that tracks which blocks have been handed out. The pool is the only thing in this setup that consumes physical space.
    
- **Thin Volume**  
    `lvcreate -V 2G -T thin_vg/my_thin_pool -n thin_vol` creates a volume inside the pool. `-V` sets its virtual size, which is what the filesystem and `df` believe the device to be. At creation it occupies almost nothing.
    
- **Virtual Size Versus Physical Allocation**  
    The virtual size is a promise; the physical allocation is what has actually been written. A thin volume claims blocks from the pool only as data is written to it, so a freshly formatted **2 GiB** thin volume might hold a few megabytes of real extents. This is why thin volumes appear larger than their physical storage — the **2 GiB** is an address space the volume is allowed to grow into, not space reserved up front.
    
- **Over-Provisioning and Its Risk**  
    Because the promise exceeds the pool, you can create several **2 GiB** volumes over a **500 MiB** pool. That is efficient while the volumes stay mostly empty, but if writes fill the pool the volumes go read-only and data can be lost — the filesystem believed it had space that the pool could not supply. Production systems either extend the pool in time or set `thin_pool_autoextend_threshold` in `/etc/lvm/lvm.conf`.
    
- **Monitoring Usage**
    
    1. lvs
    
    2. lvs -o+seg_monitor thin_vg
    
    3. vgs
    
    `lvs` is the command that matters here. The pool row shows **Data%** and **Meta%** — how full the pool actually is — while the thin volume row shows its virtual **LSize** with the pool named in the **Pool** column and its own **Data%** relative to that virtual size. Watch the pool's **Data%**, not the volume's: the pool reaching **100%** is what causes an outage. `vgs` shows the volume group level — **VFree** tells you whether there are spare extents left to extend the pool with:
    
    4. lvextend -L +200M thin_vg/my_thin_pool
    
    if it fills up.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. For thin provisioning:
    
    1. lvs
    
    must show the volume inside the pool with the virtual size the task asked for, and:
    
    2. df -h /mnt/thin
    
    must show the mount. Run:
    
    3. mount -a
    
    before rebooting — a bad `/etc/fstab` entry drops the system into emergency mode — then reboot and confirm the mount returns on its own.
    

**Pro Tip: Single-Command Thin Provisioning (Exam Time-Saver)**

Once you have completed the **PV (Physical Volume)** and **VG (Volume Group)** setup, you can create both the thin pool and the thin volume simultaneously. This "one-liner" is a great way to handle **LVM (Logical Volume Manager)** tasks quickly.

The Command

1. lvcreate --type thin --name thin_vol \
2.   --thinpool my_thin_pool --size 500m \
3.   --virtualsize 2G thin_vg

**Verify the Configuration**

Run:

1. lvs thin_vg

You should see:

- **VSize:** `2.00g`
    
- **Origin:** `my_thin_pool`
    

This confirms over-provisioning is active (the virtual size is larger than the physical pool).

**Why This Is Effective for the Exam**

- **Efficiency:** Saves valuable time compared to running two separate `lvcreate` commands.
    
- **Accuracy:** You can find this exact syntax in the man (Manual) pages (`man lvcreate`), which helps prevent typos under pressure.
    
- **Compliance:** It achieves the exact same result as the multi-step method and passes all grading scripts.
    

**Crucial Final Step**

Don't forget to format the volume with:

1. mkfs.xfs /dev/thin_vg/thin_vol

and configure your persistent mount in `/etc/fstab` to ensure it survives a reboot.

**Question 28**

**Task:** Create a security audit script on **ServerB**.

1. Create a script named `/root/find_suid.sh`.
    
2. The script should search the `/usr/bin` directory.
    
3. It should locate all files owned by **root** that have the **SUID** (Set User ID) permission bit set.
    
4. The script should print the filenames found.
    

- **Aspects/Domains Covered:** Manage security (Manage default file permissions), Create simple shell scripts.

Overall explanation

**Correct Answer:**

1. **Create Script:**
    
    1. vim /root/find_suid.sh
    
2. **Add Content:**
    
    1. #!/bin/bash
    2. find /usr/bin -user root -perm -4000
    
3. **Make Executable:**
    
    1. chmod +x /root/find_suid.sh
    

**Detailed Explanation for Learners:**

- `**-perm -4000**`**:**
    
    - `4` = SUID bit (Numeric representation).
        
    - `-` = "At least." It means "Look for files that have the SUID bit set, regardless of what the other permissions (rwx) are."
        
- **Why Audit SUID?** SUID files execute with the permissions of the _owner_ (root), not the user running them. If a hacker finds a buggy SUID file, they can use it to become root.
**Question 29**

**Task:** Modify the bootloader configuration on **ServerB**.

1. Change the GRUB boot menu timeout to **10 seconds** (the default is often 5).
    
2. Ensure this change applies to the current configuration immediately.
    

- **Aspects/Domains Covered:** Operate running systems (Modify the system bootloader).

Overall explanation

**Correct Answer**

1. Modify the Configuration

Edit:

1. vim /etc/default/grub

Change the line:

1. GRUB_TIMEOUT=10

2. Regenerate the Configuration

3. grub2-mkconfig -o /boot/grub2/grub.cfg

**Detailed Explanation for Learners**

- `**/etc/default/grub**`  
    This is the human-readable configuration file. You rarely edit the actual bootloader script (`grub.cfg`) directly.
    
- `**grub2-mkconfig**`  
    This command reads your simple settings in `/etc/default/grub` and compiles them into the complex code required for the bootloader to function.
    
- `**/etc/default/grub**` **Versus** `**grub.cfg**`  
    `/etc/default/grub` is the short, human-edited settings file — a handful of `KEY=value` lines such as `GRUB_TIMEOUT` and `GRUB_CMDLINE_LINUX`. `/boot/grub2/grub.cfg` is the generated boot script: hundreds of lines of shell-like GRUB code containing one menu entry per installed kernel. You edit the first; the second is built for you.
    
- **Why** `**grub.cfg**` **Should Never Be Edited Directly**  
    It is regenerated automatically — by `grub2-mkconfig`, and by `dnf` every time a kernel is installed or removed — so any hand edit is silently overwritten at the next kernel update. Its header says as much. A syntax error there is also far more dangerous than one in `/etc/default/grub`, because it can leave the machine unbootable with no menu to fall back on. Edit `/etc/default/grub` and regenerate, or use `grubby` for kernel arguments.
    
- **Where the Generated File Lives**  
    On a **BIOS** system it is:
    
    1. /boot/grub2/grub.cfg
    
    On a **UEFI** system it is:
    
    2. /boot/efi/EFI/redhat/grub.cfg
    
    Check with:
    
    3. ls /sys/firmware/efi
    
    If that directory exists, you booted in **UEFI** mode. Writing the output to the wrong path leaves the real configuration untouched and the change appears to do nothing.
    
- **Verifying the Configured Timeout**
    
    1. grep GRUB_TIMEOUT /etc/default/grub
    
    2. grep -m1 "set timeout" /boot/grub2/grub.cfg
    
    The first confirms your edit; the second confirms it was actually compiled into the generated file — if they disagree, `grub2-mkconfig` was never run or was written to the wrong path. The real proof is the reboot: the menu should sit for **10 seconds** before booting automatically, and `systemd-analyze` afterwards will show the extra time in the firmware/loader phase.
    
- **Exam Tip**  
    Before moving on, verify both functionality and persistence whenever the objective requires it. A bootloader change is one of the few tasks where the reboot is the verification. Watch the menu count down from **10** rather than trusting the file alone.
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

Overall explanation

**Correct Answer**

**1. Setup (Simulate the problem):**

1. touch /home/secret_data
2. chmod 000 /home/secret_data
3. # Ensure admins group exists
4. groupadd admins
5. usermod -aG admins sam

**2. Fix Ownership:** Link the file to the correct group:

1. chown :admins /home/secret_data

**3. Fix Permissions:** Set Owner to Read/Write (6) and Group to Read-Only (4).

1. chmod 640 /home/secret_data
2. # OR
3. chmod u+rw,g+r,o-rwx /home/secret_data

**4. Verify:**

1. ls -l /home/secret_data
2. # Output: -rw-r-----

**Detailed Explanation for Learners**

- **Diagnosis:** `ls -l` reveals the file has `---------` permissions. Even if Sam is in the right group, the group has 0 permissions.
    
- **The Fix:**
    
    - **Connection:** Use `chown :admins` to associate the file with Sam's group.
        
    - **Access:** Use `chmod` to grant the specific rights.
        
- **Security Note:** We use `640` (rw-r-----) rather than `050` or `777`.
    
    - **Owner (6):** Root must maintain control (Read/Write).
        
    - **Group (4):** Admins need to read the data, but they should not be able to edit it (Write) or run it as a program (Execute).
        
    - **Execute (x):** Never grant execute permissions to a standard data file. The execute bit is strictly for scripts and programs.