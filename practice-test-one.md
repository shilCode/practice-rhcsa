

**Question 1**

**Task:** You have forgotten the root password for **ServerA**. Securely reset the root password to `password` to regain access to the system.

- **Aspects/Domains Covered:** Operate running systems (Interrupt the boot process in order to gain access to a system).
    

  



**Important — Action Required Before Continuing**

The Overview Guide and Lab Setup PDF (Portable Document Format) are mandatory resources for this RHCSA (Red Hat Certified System Administrator) 10 (EX200) exam. These documents contain essential environment details and technical requirements needed to complete the tasks correctly.

**Download the Required Files**

If you are already in Exam Mode and have not downloaded these files yet, please use the links below:

- **RHCSA 10 (EX200) Mastery Guide** — _https://drive.google.com/file/d/177rS0o5YbCw_VqZ6AVVuNZs9bbzf_dBD/view?usp=sharing_
    
- **RHCSA10_Exam_1_Requirements** — _https://drive.google.com/file/d/13UOrT0XtgRmOm2SQ4gEIkd1F7mBKeZiZ/view?usp=sharing_
    
      
    

**How to Access the Official Test Description**

These are the same documents shown on the test description screen before you clicked "Start Exam." If you need to return to that screen to view them:

1. Stop or Exit the current exam session.
    
2. Navigate back to **Practice Test X: RHCSA 10 EX200 Practice Exam**.
    
3. On the Exam Mode description page, you will find the direct download links located under the "Instructions" header.

Answer:

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

**Task:** Configure a Local Yum/DNF Repository on **ServerA**.

- Mount the provided ISO image `RHEL-10.iso` to the `/mnt` directory.
    
- Configure the system to allow installing packages from the **BaseOS** and **AppStream** repositories located inside the ISO image.
    
- Ensure GPG signature checking is **disabled** for these repositories to avoid key errors.
    
- **Aspects/Domains Covered:** Manage Software (Configure access to RPM repositories).


Answer:

Overall explanation

**Correct Answer:**

1. **Mount the ISO Image:**
    
    1. mount -o loop RHEL-10.iso /mnt
    
2. **Create the Repository Configuration File:**
    
    - Create a new file in `/etc/yum.repos.d/`. The name doesn't matter as long as it ends in `.repo`.
        
        1. vim /etc/yum.repos.d/local.repo
        
3. **Add the Repository Details:**
    
    1. [BaseOS]
    2. name=RHEL 10 BaseOS
    3. baseurl=file:///mnt/BaseOS
    4. enabled=1
    5. gpgcheck=0
    
    6. [AppStream]
    7. name=RHEL 10 AppStream
    8. baseurl=file:///mnt/AppStream
    9. enabled=1
    10. gpgcheck=0
    
4. **Verify the Configuration:**
    
    1. dnf clean all
    2. dnf repolist
    
    _Success Indicator: The output should list "RHEL 10 BaseOS" and "RHEL 10 AppStream" with a number of packages available._
    

**Detailed Explanation for Learners:**

- **Loop Mounting:** The `-o loop` option allows the system to treat a single file (the ISO) as if it were a physical disk (like a DVD or USB drive) plugged into the machine.
    
- **Repo File Structure:**
    
    - `[]`: The Repository ID (must be unique, no spaces).
        
    - `baseurl`: Where the packages are found. `file://` tells DNF to look on the local disk rather than the internet (`http://`).
        
    - `gpgcheck=0`: In production, you verify cryptographic signatures (GPG keys) to ensure software hasn't been hacked. In an exam or local test environment with a trusted ISO, disabling this (`0`) saves time.
        
- **BaseOS vs. AppStream:** RHEL splits software into two repos. **BaseOS** contains the kernel and core tools. **AppStream** contains user applications (like Python, PostgreSQL, web servers). You almost always need both.
    

**Pro Tip: Mounting a File vs. a Device**

When completing this task in a virtual environment, the command you use depends on how the **ISO** (International Organization for Standardization) is attached to your system:

- **Scenario A: The ISO is a file inside your Linux filesystem** If you downloaded the file (e.g., `/root/RHEL-10.iso`), use the **loop** option: `mount -o loop /root/RHEL-10.iso /mnt`
    
- **Scenario B: The ISO is attached via your Virtual Machine settings** If you "inserted" the disk using your software's settings menu, Linux sees it as a hardware device (a virtual DVD drive). In this case, you must mount the device path: `mount /dev/sr0 /mnt`
    

**Note:** If your system attempts to restart the installation process every time you reboot, check your **BIOS** (Basic Input/Output System) or **VMM** boot order settings. Ensure the **HDD** (Hard Disk Drive) is set as the first boot priority, or "eject" the virtual disk after the initial installation is complete.





**Question 3**

**Task:** On **ServerA**, configure a NetworkManager connection profile named `lab-link` for the network interface `enp0s3` (or your default interface). The connection must persist after reboot and meet the following specifications:

- **Primary IPv4 Address:** `192.168.1.10/24`
    
- **IPv4 Gateway:** `192.168.1.1`
    
- **IPv4 DNS:** `8.8.8.8`
    
- **Primary IPv6 Address:** `fd00::10/64`
    
- **IPv6 Gateway:** `fd00::1`
    
- **Secondary IPv4 Address:** `10.0.0.5/24` (Ensure this does not overwrite the primary IP).
    
- **Aspects/Domains Covered:** Manage Basic Networking (Configure IPv4/IPv6 addresses, Persistence).


Answer:

Overall explanation

**Correct Answer:**

1. **Create the Connection with Primary IPs:**
    
    1. nmcli con add con-name lab-link ifname enp0s3 type ethernet \
    2. ipv4.method manual ipv4.addresses 192.168.1.10/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 \
    3. ipv6.method manual ipv6.addresses fd00::10/64 ipv6.gateway fd00::1 \
    4. connection.autoconnect yes
    
2. **Add the Secondary IP Address:**
    
    1. nmcli con mod lab-link +ipv4.addresses 10.0.0.5/24
    
3. **Activate the Connection:**
    
    1. nmcli con up lab-link
    
4. **Verify:**
    
    1. ip addr show enp0s3
    

**Detailed Explanation for Learners:**

- `**nmcli con add**`**:** This creates a _new_ configuration file.
    
- **Manual vs. Auto:** We use `ipv4.method manual` (Static IP) instead of `auto` (DHCP), which is the default.
    
- **The Critical** `**+**` **Symbol:** In step 2, we use `+ipv4.addresses`. If you run the command _without_ the `+` (e.g., `ipv4.addresses 10.0.0.5/24`), it will **replace** the `192.168.1.10` address you set in step 1. The `+` tells NetworkManager to "append" this IP to the existing list, allowing the server to have two IP addresses on one cable.
    
- **Persistence:** `nmcli` writes configurations to files in `/etc/NetworkManager/system-connections/` automatically, so this survives a reboot by default.





**Question 4**

**Task:** Configure time synchronization services on **ServerA** with the following requirements:

1. Set the system timezone to **America/New_York**.
    
2. Configure the **Chrony** service to synchronize time with the server `pool.ntp.org`.
    
3. Ensure the Chrony service is enabled and starts automatically at boot.
    

- **Aspects/Domains Covered:** Deploy, Configure, and Maintain Systems (Configure time service clients).


Overall explanation

**Correct Answer**

**1. Set the Timezone:**

1. timedatectl set-timezone America/New_York

**2. Configure the NTP Server:** Open the **Chrony** configuration file:

1. vim /etc/chrony.conf

Add or ensure the following line exists (using the `pool` directive for better redundancy):

1. pool pool.ntp.org iburst

_(Note: Comment out any existing_ `_pool_` _or_ `_server_` _lines if necessary to ensure this is the primary source.)_

**3. Enable and Restart the Service:**

1. systemctl enable --now chronyd

**4. Verify:**

1. timedatectl
2. chronyc sources

**Detailed Explanation for Learners**

- `**timedatectl**`**:** This is the modern command to manage the system clock and timezone. It is immediate and persistent.
    
- `**chronyd**`**:** This is the background service (daemon) that talks to **NTP** (Network Time Protocol) servers to keep your clock accurate.
    
- `**pool**` **directive:** Unlike the `server` directive which connects to a single **IP** (Internet Protocol) address, `pool` tells **Chrony** that the **DNS** (Domain Name System) name represents a cluster of servers. **Chrony** will resolve this to multiple addresses and maintain multiple associations, ensuring higher reliability if one server goes down.
    
- `**iburst**`**:** This stands for "Initial Burst." If your server boots up and the clock is wrong, `iburst` allows **Chrony** to send a rapid burst of requests to the time server to fix the time immediately, rather than waiting for a slow gradual sync.


**Question 5 (New Topic: Flatpak)**

**Task:** On **ServerA**, configure the **Flatpak** package management system to allow installing desktop applications.

1. Add a new remote repository named flathub using the official URL: `https://dl.flathub.org/repo/flathub.flatpakrepo`
    
2. Install the application org.gnome.TextEditor from this new remote.
    

- **Aspects/Domains Covered:** Manage Software (Configure access to Flatpak repositories, Install Flatpak software).


Overall explanation

**Correct Answer**

1. Add the Remote Repository

2. flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

3. Install the Application

4. flatpak install flathub org.gnome.TextEditor -y

5. Verify Installation

6. flatpak list

**Detailed Explanation for Learners**

- **What is Flatpak?**  
    Unlike RPM/DNF, which installs software deep into the system (often causing conflicts), Flatpak installs applications in "sandboxes." They contain all their own dependencies and don't touch the core operating system. This is now the standard way to install GUI apps (like LibreOffice, Gedit, Firefox) on RHEL 10.
    
- **remote-add**  
    This is similar to adding a `.repo` file for DNF. It tells Flatpak where to look for software. **flathub** is the most common public repository.
    
- **Application IDs**  
    Notice the name **org.gnome.TextEditor**. Flatpaks use "reverse DNS" naming styles to ensure every app has a unique ID globally.
    
- **System-Wide vs User Installations**  
    Flatpak has two independent scopes. A system installation — `flatpak install`, run with root privileges — stores the application under `/var/lib/flatpak` and makes it available to every account on ServerA. A user installation stores it under `~/.local/share/flatpak` and is visible only to the account that ran the command.
    
- **Installing for a Single User**
    
    1. flatpak install --user flathub org.gnome.TextEditor
    
    performs the same installation in the per-user namespace and needs no sudo. Remotes are scoped the same way, so a `--user` installation also needs the remote added with:
    
    2. flatpak remote-add --user
    
    otherwise the install fails because the remote is not visible in that scope.
    
- **When** `**--user**` **Is Appropriate**  
    Use it when a task names a specific account, when you must not alter a shared system installation, or when you do not have root access on the host.
    
- **Verifying Each Installation**
    
    `flatpak list` shows both scopes at once. Add the installation column to see which scope each application landed in, or use `--user` to list only your own:
    
    1. flatpak list --app --columns=application,installation
    
    2. flatpak list --user --app
    
    The installation column reports `system` or `user`. Updates and removals are scoped too:
    
    - `flatpak update` and `flatpak uninstall` act on the system installation.
        
    - `flatpak update --user` and `flatpak uninstall --user` act on yours.
        
    
    Removing one scope leaves the other untouched.
    
- **Why This Task Uses the System Method**  
    The task asks you to configure Flatpak on ServerA so that desktop applications can be installed, without naming a user. The application must therefore be available system-wide, which makes `flatpak remote-add` and `flatpak install` without `--user` the correct commands, and it is the system installation that is graded.
    
- **Exam Tip**  
    Read the scope wording before you type. A task that says **"for user student"** means becoming that user and running:
    
    1. flatpak install --user
    
    Anything else means the system installation used above. Installing into the wrong namespace scores zero even though the application launches perfectly.


**Question 6**

**Task:** On **ServerA**, configure local storage using `/dev/sdb`. Perform the following actions:

1. Create a partition on `/dev/sdb` and configure it as a physical volume.
    
2. Create a volume group named `myvg`.
    
3. Create a logical volume named `mylv` with a size of **500MiB**.
    
4. Format `mylv` with the **ext4** filesystem.
    
5. Persistently mount it at `/mylv`.
    
6. Finally, **extend** the logical volume and its filesystem by an additional **500MiB** (Total size approx 1GiB).
    

- **Aspects/Domains Covered:** Configure local storage (Create/delete logical volumes, Configure systems to mount file systems, Extend existing logical volumes).


Overall explanation

**Correct Answer:**

1. **Create Partition & PV:**
    
    1. fdisk /dev/sdb
    2. # Type 'n' (new), 'p' (primary), Enter, Enter, '+1G' (enough for the task), 'w' (write).
    3. pvcreate /dev/sdb1
    
2. **Create Volume Group:**
    
    1. vgcreate myvg /dev/sdb1
    
3. **Create Logical Volume:**
    
    1. lvcreate -n mylv -L 500M myvg
    
4. **Format and Mount:**
    
    1. mkfs.ext4 /dev/myvg/mylv
    2. mkdir /mylv
    3. # Add to /etc/fstab for persistence
    4. echo "/dev/myvg/mylv /mylv ext4 defaults 0 0" >> /etc/fstab
    5. mount -a
    
5. **Extend Volume and Filesystem:**
    
    1. lvextend -r -L +500M /dev/myvg/mylv
    
    _(Note:_ `_-r_` _automatically resizes the underlying filesystem, whether it is ext4 or xfs)._
    

**Detailed Explanation for Learners:**

- **LVM Hierarchy:** Think of it like Lego. **PV** (Physical Volume) is the plastic brick. **VG** (Volume Group) is a pile of bricks. **LV** (Logical Volume) is the structure you build from that pile.
    
- **Persistence:** The exam requires changes to survive a reboot. Editing `/etc/fstab` is mandatory.
    
- `**lvextend -r**`**:** This is a "power user" flag. Without `-r`, you would have to run `lvextend` first, and then run `resize2fs` (for ext4) or `xfs_growfs` (for xfs) separately. The `-r` flag detects the filesystem type and resizes it for you in one step.





**Question 7 (New Topic: Systemd Timers)**

**Task:** On **ServerA**, configure a scheduled task using **Systemd Timer Units** (not Cron).

1. Create a script at /usr/local/bin/system-check.sh that appends the current date to /var/log/system-check.log. Ensure it is executable.
    
2. Create a systemd service unit named system-check.service that executes this script.
    
3. Create a systemd timer unit named system-check.timer that runs the service **every 1 minute**.
    
4. Enable and start the timer.
    

- **Aspects/Domains Covered:** Deploy, configure, and maintain systems (Schedule tasks using at, cron, and systemd timer units).

Overall explanation

**Correct Answer**

1. Create the Script

2. echo '#!/bin/bash' > /usr/local/bin/system-check.sh
3. echo 'date >> /var/log/system-check.log' >> /usr/local/bin/system-check.sh
4. chmod +x /usr/local/bin/system-check.sh

5. Create the Service Unit

Create the file:

1. /etc/systemd/system/system-check.service

2. [Unit]
3. Description=System Check Service

4. [Service]
5. Type=oneshot
6. ExecStart=/usr/local/bin/system-check.sh

7. Create the Timer Unit

Create the file:

1. /etc/systemd/system/system-check.timer

2. [Unit]
3. Description=Run System Check every minute

4. [Timer]
5. OnCalendar=minutely
6. Unit=system-check.service

7. [Install]
8. WantedBy=timers.target

**Note:** `OnCalendar=minutely` is a shorthand for `*-*-* *:*:00`.

4. Activate

5. systemctl daemon-reload
6. systemctl enable --now system-check.timer

**Detailed Explanation for Learners**

- **OnCalendar=minutely**  
    This is the cleanest way to schedule a task "every minute" based on the wall clock.
    
- **AccuracySec**  
    By default, systemd allows timers to deviate (often by up to a minute) to group CPU wake-ups and save power. If you need strict precision (e.g., exactly at `:00` seconds every minute), you must explicitly set the accuracy:
    
    1. [Timer]
    2. AccuracySec=1s
    
    Without this, your logs might show execution times drifting (e.g., `10:01:45` instead of `10:01:00`), making it harder to verify your schedule.
    
- **Exam Tip**  
    Always stick to the requested log file path (e.g., `/var/log/system-check.log`) using redirection (`>>`), as exam grading scripts look for that specific file, not the journal.
    
- `**.service**` **and** `**.timer**` **Work as a Pair**  
    The timer never does the work. `system-check.timer` carries only the schedule; the work lives in `system-check.service`. That is why this answer creates two unit files — a timer on its own has nothing to activate.
    
- **The** `**Unit=**` **Directive**  
    systemd automatically pairs a timer with the service of the same base name, so `Unit=system-check.service` above states explicitly what would already happen. It becomes mandatory the moment the two names differ: without it the timer elapses exactly on schedule and activates nothing, which is a silent failure.
    
- **Why** `**systemctl daemon-reload**` **Is Required**  
    systemd keeps unit files cached in memory. Until you reload, a newly created unit does not exist as far as systemd is concerned, and an edited one still runs its previous version. Run it after every change under `/etc/systemd/system/`.
    
- **Enable the Timer, Not the Service**  
    `systemctl enable --now system-check.timer` is what makes the schedule return after a reboot. Enabling `system-check.service` instead would run the script once at boot and never again — the schedule would be lost entirely.
    
- **Common Timer Mistakes**
    
    - Skipping `daemon-reload`.
        
    - Enabling the service instead of the timer.
        
    - A `Unit=` pointing at a unit that does not exist.
        
    - Invalid `OnCalendar=` syntax — check it with:
        
        1. systemd-analyze calendar "minutely"
        
        which prints the next elapse or an error.
        
    - Stopping at "no errors" without confirming the service actually ran.
        
- **Additional Verification Commands**
    
    1. systemctl list-timers
    
    2. systemctl status system-check.timer
    
    3. journalctl -u system-check.service
    
    `list-timers` proves a schedule exists and shows the next and last elapse; `status` confirms the timer is loaded, active, and enabled; `journalctl -u` is the only one of the three that proves the script actually ran.
    
    Finish with:
    
    4. tail /var/log/system-check.log
    
    since that file is what the grading script reads.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. Reboot, then confirm:
    
    1. systemctl is-enabled system-check.timer
    
    returns `enabled` and that:
    
    2. systemctl list-timers
    
    still shows a future run.


**Question 8**

**Task:** Set up a basic web server on **ServerA**:

1. Install the Apache HTTP server (`httpd`).
    
2. Configure the server to display the text "Welcome to RHEL 10" when the site is accessed.
    
3. Ensure the service starts automatically at boot.
    
4. Configure the firewall to allow traffic for HTTP services permanently.
    

- **Aspects/Domains Covered:** Manage Basic Networking (Restrict network access using firewall-cmd), Deploy, configure, and maintain systems (Start and stop services).

Overall explanation

**Correct Answer:**

1. **Install and Enable:**
    
    1. dnf install httpd -y
    2. systemctl enable --now httpd
    
2. **Configure Content:**
    
    1. echo "Welcome to RHEL 10" > /var/www/html/index.html
    
3. **Configure Firewall:**
    
    1. firewall-cmd --permanent --add-service=http
    2. firewall-cmd --reload
    
4. **Verify:**
    
    1. curl http://localhost
    

**Detailed Explanation for Learners:**

- `**systemctl enable --now**`**:** This is a shortcut that performs two actions: `enable` (ensure it starts at next boot) and `start` (turn it on right now).
    
- `**/var/www/html/**`**:** This is the default "Document Root" for Apache. The file must be named `index.html` to be served automatically.
    
- **Firewall Persistence:** You must use `--permanent` so the rule survives a reboot, and then `--reload` to apply the rule immediately without restarting the server.



**Question 9**

**Task:** Locate all files in the `/etc` directory that are larger than **3MiB**. Copy these files to the directory `/find/largefiles`.

- Ensure the destination directory is created if it does not exist.
    
- Do not overwrite files if they already exist in the destination.
    
- **Aspects/Domains Covered:** Understand and use essential tools (Create, delete, copy, and move files; Use grep and regular expressions [conceptual overlap with find]).

Overall explanation

**Correct Answer**

1. **Create Directory:** `mkdir -p /find/largefiles`
    
2. **Find and Copy:** `find /etc -size +3M -exec cp -n '{}' /find/largefiles/ \;`
    

**Detailed Explanation for Learners:**

- `**find /etc**`: Look inside the `/etc` directory.
    
- `**-size +3M**`: Look for files larger than 3 Mebibytes (MiB).
    
    - _Note on Acronyms and Units:_ In the `find` command, `**M**` stands for **Mebibytes** (MiB, binary units of 1,048,576 bytes) rather than decimal Megabytes (MB). Similarly, `**G**` stands for **Gibibytes** (GiB, binary units of 1,073,741,824 bytes), and `**k**` represents Kibibytes (binary units of 1,024 bytes). Understanding this distinction is crucial for precise system administration.
        
- `**-exec ... \;**` **(Standard Method)**: This tells the `find` command to run the subsequent command separately for every single file found. It is simple to remember, but slower if there are thousands of files.
    
- `**'{}'**`: This is the placeholder for the file name found. It is best practice to wrap these braces in single quotes (`'{}'`) to handle special characters or spaces in filenames safely.
    
- `**cp -n**`: The `-n` flag stands for "no clobber" (preventing the overwriting of existing files). This ensures that if a file already exists in the destination directory, it is kept completely intact.
    

**Why** `**-n**` **vs.** `**-u**`**?**

- `**cp -n**` **(No Clobber):** Strictly refuses to overwrite any existing file, regardless of timestamps. (Best when the goal is purely "do not touch existing files").
    
- `**cp -u**` **(Update):** Will overwrite an existing file, but only if the source file contains more recent updates. (Best for synchronization or incremental backups).
    

**Advanced Optimization (Pro Tip):** For better performance, you can group files into a single command using the `+` terminator instead of `\;`: `find /etc -size +3M -exec cp -n --target-directory=/find/largefiles '{}' +`

- **Efficiency**: The `+` terminator passes a long list of filenames to a single `cp` (copy) command, rather than running the `cp` command dozens of times.
    
- **Target Directory**: Since `+` puts all the filenames at the end of the command execution, we must use the `--target-directory` option to specify the destination before the file list is appended.



**Question 10**

**Task:** Configure the bootloader on **ServerA** so that boot messages are visible during startup (disable the quiet graphical boot).

- Remove the rhgb and quiet parameters from the current kernel's boot options.
    
- Ensure this change persists for future kernel updates if possible, or at least applies to the current kernel permanently.
    
- **Aspects/Domains Covered:** Operate running systems (Boot, reboot, and shut down a system normally - specifically modifying boot parameters).

Overall explanation

**Correct Answer**

Method 1: Using Grubby (The RHEL Preferred Way)

1. grubby --update-kernel=ALL --remove-args="rhgb quiet"

Method 2: Editing Default Config (The Manual Way)

1. Edit the Configuration File

2. vim /etc/default/grub

Find the line:

1. GRUB_CMDLINE_LINUX

and delete:

1. rhgb quiet

2. Regenerate the Boot Configuration

3. grub2-mkconfig -o /boot/grub2/grub.cfg

**Detailed Explanation for Learners**

- `**rhgb**`  
    Red Hat Graphical Boot. This shows the spinning logo/progress bar instead of text.
    
- `**quiet**`  
    Suppresses most text messages.
    
- **Why Remove Them?**  
    SysAdmins need to see text messages to debug why a server might be hanging during startup.
    
- **Why** `**grubby**`**?**  
    `grubby` is a tool specifically designed to edit the bootloader configuration safely without risking syntax errors in the complex `grub.cfg` file. It updates the current kernel and future kernels automatically.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. Confirm the change with:
    
    1. grubby --info=ALL
    
    and, after rebooting:
    
    2. cat /proc/cmdline
    
    `rhgb quiet` must be gone from every kernel entry, not just the one currently booted.


**Question 11**

**Task:** Create a shell script named `/usr/local/bin/flipargs.sh` on **ServerA**.

- The script must accept exactly **two** arguments.
    
- When executed, it should output the second argument first, followed by a space, and then the first argument.
    
- Example: `./flipargs.sh red blue` should output `blue red`.
    
- Ensure the script is executable by all users.
    
- **Aspects/Domains Covered:** Create simple shell scripts (Process script inputs `$1`, `$2`).


Overall explanation

Correct Answer

**1. Create the Script:**

1. vim /usr/local/bin/flipargs.sh

**2. Add Script Content:** _(This is the fastest valid solution for the exam)_

1. #!/bin/bash
2. echo "$2 $1"

**3. Make Executable:**

1. chmod +x /usr/local/bin/flipargs.sh

**4. Verify:**

1. /usr/local/bin/flipargs.sh hello world
2. # Output should be: world hello

**Detailed Explanation for Learners**

- `**$1**` **and** `**$2**`**:** These are **Positional Parameters**. `$1` holds the first word you type after the script name, and `$2` holds the second.
    
- `**echo**`**:** This command prints text to the screen. By arranging the variables as `"$2 $1"`, we reverse their display order.
    
- `**chmod +x**`**:** Scripts are just text files until you give them the "Execute" permission. This tells **Linux** it is a program that can be run.
    

**Pro Tip: Robust Production Scripting**

While the one-line script above is perfect for passing the exam quickly, in a real production environment, you should validate your inputs. A robust version looks like this:

1. #!/bin/bash

2. # Check if the number of arguments ($#) is not equal (-ne) to 2
3. if [ "$#" -ne 2 ]; then
4.     echo "Error: Enter exactly two arguments."
5.     exit 1
6. fi

7. echo "$2 $1"

_Using this logic ensures your script doesn't behave unpredictably if a user provides too few or too many arguments._



**Question 12**

**Task:** Configure user environment and security policies on **ServerA**:

1. **Skeleton Directory:** Ensure that a file named `Welcome.txt` is automatically created in the home directory of every **newly created** user.
    
2. **Password Aging:** Configure the system so that password aging controls require users to change their password every **90 days**.
    
3. **Password Length:** Ensure that all new passwords must be at least **8 characters** long.
    

- **Aspects/Domains Covered:** Manage users and groups (Manage default file permissions), Manage security (Adjust password aging, Configure password quality).

Overall explanation

**Correct Answer:**

1. **Configure Skeleton Directory:**
    
    1. touch /etc/skel/Welcome.txt
    
2. **Configure Password Aging (Max Days):**
    
    - Edit `/etc/login.defs`:
        
        1. vim /etc/login.defs
        
    - Find `PASS_MAX_DAYS` and set it to 90:
        
        1. PASS_MAX_DAYS 90
        
3. **Configure Password Length:**
    
    - Edit `/etc/security/pwquality.conf`:
        
        1. vim /etc/security/pwquality.conf
        
    - Uncomment (remove `#`) or add the `minlen` line:
        
        1. minlen = 8
        

**Detailed Explanation for Learners:**

- `**/etc/skel**`**:** This directory is the "template" for new users. When you run `useradd`, the system copies everything inside `/etc/skel` into the new user's home folder.
    
- `**/etc/login.defs**`**:** This file controls the default settings for _newly created_ users, such as how long a password lasts before it expires (`PASS_MAX_DAYS`).
    
- `**/etc/security/pwquality.conf**`**:** RHEL uses a library called `libpwquality` to check if a password is "good enough." This file controls complexity rules, such as minimum length (`minlen`).




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
Overall explanation

**Correct Answer:**

1. **Create Group and Directory:**
    
    1. groupadd developers
    2. mkdir /opt/dev-data
    
2. **Set Ownership and Permissions:**
    
    1. chown :developers /opt/dev-data
    2. chmod 2770 /opt/dev-data
    
    _(Alternatively:_ `_chmod g+rwx,o-rwx,g+s /opt/dev-data_`_)_
    
3. **Verify:**
    
    1. ls -ld /opt/dev-data
    2. `# Output should look like: drwxrws--- root developers ...`
    

**Detailed Explanation for Learners**

- `**chown :developers**`: The colon `:` before the name tells the command to change the **Group** owner, leaving the User owner as is (usually root).
    
- `**chmod 2770**`: This single command applies three critical settings:
    
    - `**2**` **(Set-GID /** `**g+s**`**)**: This is the "magic" bit. It ensures that any **new file** created inside this directory automatically inherits the group `developers` instead of the creating user's primary group. This is essential for collaboration.
        
    - `**77**` **(User & Group)**: Gives the owner and the `developers` group full access (`rwx`).
        
    - `**0**` **(Others)**: Gives everyone else **no access** (`---`).
        

**Why is "Others = 0" so important?** You might notice that new files created inside still have read permissions for others (e.g., `-rw-r--r--`) due to the user's default `umask`. However, these files are still secure!

- **Directory-Level Security:** Even if a file shows `-rw-r--r--`, a user who is not in `developers` **still cannot open it** because they lack Execute (`x`) permission on the parent directory `/opt/dev-data`. If they cannot enter the room, they cannot read the papers on the desk.
    

**Pro Tip: Exam vs. Production**

- **For the Exam:** Use SGID (`chmod 2770`) for collaboration directories. It is the standard, expected method.
    
- **For Production:** If you need strict, automatic _file-level_ permission inheritance (e.g., ensuring new files are always `-rw-rw----`), you should add **Default ACLs** (e.g., `setfacl -m d:g:developers:rwx ...`).


**Question 14**

**Task:** Create a compressed archive on **ServerA**.

1. Create a **gzip** compressed tar archive named `/root/config_backup.tar.gz`.
    
2. The archive should contain the contents of the `/etc/ssh` directory.
    
3. Verify the contents of the archive after creation without extracting it.
    

- **Aspects/Domains Covered:** Understand and use essential tools (Archive, compress, unpack, and uncompress files using tar, gzip).
Overall explanation

**Correct Answer:**

1. **Create the Archive:**
    
    1. tar -czf /root/config_backup.tar.gz /etc/ssh
    
2. **Verify Contents:**
    
    1. tar -tf /root/config_backup.tar.gz
    

**Detailed Explanation for Learners:**

- `**tar**`**:** The standard tool for bundling files in Linux (Tape ARchive).
    
- **Flags:**
    
    - `-c`: **C**reate a new archive.
        
    - `-z`: Use **Gzip** compression (fast, standard).
        
    - `-f`: **F**ilename (this must be the last flag before the file name).
        
- **Verification:** `tar -t` (**T**able of contents) lists what is inside the file so you can confirm the backup worked.




**Question 15**

**Task:** Add swap space to **ServerA** non-destructively.

1. Create a new partition of **512MiB** on disk `/dev/sdb`.
    
2. Format and configure this partition as **swap** space.
    
3. Ensure the swap space is activated automatically at system boot.
    

- **Aspects/Domains Covered:** Configure local storage (List, create, delete partitions; Add swap to a system non-destructively).

Overall explanation

**Correct Answer:**

1. **Create Partition:**
    
    1. fdisk /dev/sdb
    2. `# Type 'n' (new), Enter (default number), Enter (default start), '+512M', 't' (type), '82' (Linux Swap), 'w' (write).`
    3. partprobe /dev/sdb
    
2. **Format as Swap:**
    
    1. mkswap /dev/sdb2
    2. # (Replace sdb2 with the actual partition number created)
    
3. **Activate and Persist:**
    
    - Add to `/etc/fstab`:
        
        1. lsblk -f  # Get the UUID of the new swap partition
        2. vim /etc/fstab
        3. # Add line: UUID="<your-uuid-here>" none swap defaults 0 0
        
    - Activate immediately:
        
        1. swapon -a
        
4. **Verify:**
    
    1. free -h
    

**Detailed Explanation for Learners:**

- **Partition Type 82:** In `fdisk`, setting the type to '82' (Linux Swap) helps the system identify the partition's purpose, though it technically works without it.
    
- `**mkswap**`**:** This initializes the partition headers so the kernel can use it for memory paging.
    
- `**swapon -a**`**:** This command reads the `/etc/fstab` file and activates any swap devices listed there that aren't currently running. It’s a great way to test your `fstab` entry without rebooting.


**Question 16**

**Task:** Configure SSH access and security on **ServerA**:

1. Generate an SSH key pair for the user root.
    
2. Copy the public key to **localhost** (simulating a remote server) so that root can log in to itself without a password.
    
3. Modify the SSH configuration (/etc/ssh/sshd_config) to **disable password authentication** entirely (forcing key-based auth only).
    
4. Restart the SSH service to apply changes.
    

- **Aspects/Domains Covered:** Manage security (Configure key-based authentication for SSH), Essential Tools (Access remote systems using SSH).

Overall explanation

**Correct Answer**

1. Generate Keys

2. ssh-keygen -t rsa

Press **Enter** for the file location and **Enter** twice for no passphrase.

2. Copy the Public Key

3. ssh-copy-id root@localhost

Enter the **root** password when prompted.

3. Edit the SSH Configuration

4. vim /etc/ssh/sshd_config

Find the line:

1. PasswordAuthentication

and change it to:

1. PasswordAuthentication no

2. Restart the SSH Service

3. systemctl restart sshd

4. Verify

5. ssh localhost

Should login immediately without asking for a password.

**Detailed Explanation for Learners**

- `**ssh-keygen**`  
    Creates a private key (your ID card) and a public key (the lock). You keep the private key; you give the public key to servers you want to access.
    
- `**ssh-copy-id**`  
    A script that safely copies your public key into the `~/.ssh/authorized_keys` file on the target server.
    
- `**PasswordAuthentication no**`  
    This is a security hardening step. It ensures that even if a hacker guesses a password, they cannot log in because the server stops listening for passwords entirely.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. Check that `sshd` is enabled with:
    
    1. systemctl is-enabled sshd
    
    and keep a second session open while you test — if `PasswordAuthentication no` takes effect before your key works, you will lock yourself out of the machine.

**Question 17**

**Task:** Optimize **ServerA** performance using the **Tuned** service.

1. Install and enable the tuned service if it is not already running.
    
2. Identify the currently active tuning profile.
    
3. Switch the active profile to **throughput-performance**.
    
4. Verify that the new profile is active.
    

- **Aspects/Domains Covered:** Operate running systems (Manage tuning profiles).

Overall explanation

**Correct Answer**

1. Install and Enable

2. dnf install tuned -y
3. systemctl enable --now tuned

4. Check Current Profile

5. tuned-adm active

6. Set the New Profile

7. tuned-adm profile throughput-performance

8. Verify

9. tuned-adm active

Expected output:

1. Current active profile: throughput-performance

**Detailed Explanation for Learners**

- **Tuned**  
    RHEL uses this daemon to monitor system use and adjust kernel settings on the fly.
    
- **Profiles**
    
    - `virtual-guest`: Optimized for running inside a VM.
        
    - `throughput-performance`: Optimized for servers handling heavy data loads (databases, file servers).
        
    - `balanced`: Good for desktops/laptops (saves power).
        
- `**tuned-adm**`  
    This is the command-line tool used to manage the daemon.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. A Tuned profile only persists while the `tuned` service is enabled. Confirm with:
    
    1. systemctl is-enabled tuned
    
    then re-check:
    
    2. tuned-adm active
    
    after a restart.

**Question 18**

**Task:** Configure **ServerA** to mount a remote directory using **Autofs**.

1. Install the necessary NFS and Autofs packages.
    
2. Configure Autofs to mount the remote directory 192.168.1.100:/shares/public (replace IP with your lab's NFS server IP) to the local directory /data/public.
    
3. The mount should only happen **on-demand** (when the directory is accessed).
    
4. Ensure Autofs starts automatically at boot.
    

- **Aspects/Domains Covered:** Create and configure file systems (Configure autofs, Mount network file systems using NFS).
    

**Prerequisite: Lab Environment Setup (Server Side)**

**Note:** In the real exam, the NFS server is pre-configured. You only need to perform these steps if you are practicing in a home lab and need to simulate the server.

On the machine acting as the **NFS Server** (e.g., `192.168.1.100`):

1. # 1. Install NFS packages
2. dnf install nfs-utils -y

3. # 2. Start the service
4. systemctl enable --now nfs-server

5. # 3. Create the share directory
6. mkdir -p /shares/public
7. chmod 777 /shares/public
8. echo "NFS Share Test File" > /shares/public/testfile.txt

9. # 4. Export the share (Allowing access from your client's subnet)

10. # Replace 192.168.1.0/24 with your actual network subnet
11. echo "/shares/public 192.168.1.0/24(rw,no_root_squash)" > /etc/exports
12. exportfs -r

13. # 5. Configure Firewall
14. firewall-cmd --permanent --add-service={nfs,mountd,rpc-bind}
15. firewall-cmd --reload

Overall explanation

**Correct Answer: Exam Solution (Client Side)**

Perform these steps on **ServerA** (the client).

1. Install Packages

2. dnf install nfs-utils autofs -y

3. Edit the Master Map (`/etc/auto.master`)

Add the following line:

1. /data    /etc/auto.data

2. Create the Map File (`/etc/auto.data`)

Create the file:

1. vim /etc/auto.data

Content:

1. public    -rw,sync    192.168.1.100:/shares/public

Ensure you use the correct server IP provided in the exam task.

4. Enable and Start Autofs

5. systemctl enable --now autofs

6. Verify

The directory is mounted **on-demand**, so you must access it to trigger the mount.

1. cd /data/public
2. ls

You should see `testfile.txt` or the content of the share.

**Detailed Explanation for Learners**

- **Why Autofs?**  
    Standard mounts (in `/etc/fstab`) keep the network connection open permanently. If the server goes down, your boot process might hang. Autofs only connects when a user actually types `cd /data/public`. If no one is using it, it disconnects, saving resources.
    
- **The Master Map**  
    Tells Linux:
    
    "For any folder inside `/data`, look at the file `/etc/auto.data` for instructions."
    
- **The Map File**  
    Tells Linux:
    
    "When someone asks for the subfolder `public`, mount the NFS share `...:/shares/public` right there."
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. `autofs` must be enabled — check:
    
    1. systemctl is-enabled autofs
    
    After rebooting:
    
    2. ls /data/public
    
    should still trigger the mount on demand.

**Question 19**

**Task:** Configure privileged access on **ServerA**.

1. Create a user named `alex`.
    
2. Configure **sudo** access for `alex` so that they can run the `dnf` command **without entering a password**.
    
3. Ensure `alex` cannot run any other commands with sudo.
    

- **Aspects/Domains Covered:** Manage users and groups (Configure privileged access).

Overall explanation

**Correct Answer:**

1. **Create User:**
    
    1. useradd alex
    
2. **Configure Sudo:**
    
    - Create a file in `/etc/sudoers.d/` (Best practice):
        
        1. vim /etc/sudoers.d/alex
        
    - Add the rule:
        
        1. alex  ALL=(ALL)  NOPASSWD: /usr/bin/dnf
        
3. **Verify:**
    
    - Switch to alex and test:
        
        1. su - alex
        2. sudo dnf repolist  # Should work without password
        3. sudo reboot        # Should fail (password prompt or denied)
        

**Detailed Explanation for Learners:**

**Syntax Breakdown:**

- `**alex**`: The user receiving the privileges.
    
- `**ALL=**`: The rule applies to all hosts (relevant if sharing the sudoers file across multiple servers).
    
      
    
- `**(ALL)**` **vs** `**(root)**`:
    
    - Using `(ALL)` allows the user to run the command as _any_ user on the system. This is a common, easy-to-remember template for the exam and will pass the grading script.
        
    - **Real-World Best Practice:** Using `(root)` instead is highly recommended in production environments. Since `dnf` requires root privileges, restricting execution specifically to the root user strictly enforces the principle of least privilege. Both are 100% correct for the EX200 exam!
        
- `**NOPASSWD:**`: Do not ask for the user's password when executing this specific command.
    
      
    
- `**/usr/bin/dnf**`: The exact path to the allowed command. Always use the absolute path (e.g., `/usr/bin/dnf` instead of just `/bin/dnf` or `dnf`) to prevent malicious PATH manipulation.

**Question 20 (Advanced LVM - VDO)**

**Task:** On ServerA, create a VDO (Virtual Data Optimizer) logical volume for efficient storage.

- Using the existing volume group myvg, create a VDO Logical Volume named vdo_lv.
    
- Set the physical size to **5GiB** (to accommodate VDO metadata), and the logical (virtual) size to **20GiB**.
    
- Format the volume with xfs and mount it persistently at /vdo_data.
    

**Aspects/Domains Covered:** Configure local storage (Create and delete logical volumes - specifically VDO/Thin Provisioning types).


Overall explanation

**Correct Answer**

1. Install VDO Tools

In RHEL 10, the VDO kernel module is integrated, so you only need **lvm2** and the **vdo** management tools.

1. dnf install lvm2 vdo -y

2. Create the VDO Volume

**Note:** In RHEL 10, VDO volumes require a minimum physical size of approximately **5GB** to store the UDS (Universal Deduplication Service) index and metadata.

1. lvcreate --type vdo --name vdo_lv --size 5G --virtualsize 20G myvg

2. Format the Volume

3. mkfs.xfs /dev/myvg/vdo_lv

4. Mount Persistently

5. mkdir /vdo_data
6. echo "/dev/myvg/vdo_lv /vdo_data xfs defaults 0 0" >> /etc/fstab
7. mount -a

8. Verify

9. vdostats --human-readable

or

1. lsblk

**Detailed Explanation for Learners**

RHEL 10 Changes

- **Packages**  
    Unlike older RHEL versions, you no longer need to install `kmod-kvdo`. The functionality is standard in the kernel.
    
- **Size Requirements**  
    VDO requires a significant amount of physical space just for its internal metadata (the UDS index). While RHEL 8/9 might have allowed smaller testing sizes, RHEL 10 enforces a minimum physical size of roughly **5GB**. If you try to create a VDO volume with only **1GB** of physical space, `lvcreate` will fail with an **"Out of space"** error.
    
- **What Is VDO?**  
    VDO compresses and deduplicates data inline.
    
- `**--size**`  
    The actual physical storage you are taking from your Volume Group (**5GB**).
    
- `**--virtualsize**`  
    The "fake" size you present to the OS (**20GB**).
    
- **Use Case**  
    This is ideal for storing backups, virtual machine images, or logs where duplicate data is common. VDO allows you to store more data than you physically have on the disk.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. Run:
    
    1. mount -a
    
    before you reboot: a bad `/etc/fstab` entry drops the system into emergency mode. After the reboot:
    
    2. df -h /vdo_data
    
    must show the volume back automatically.

**Question 21**

**Task:** Configure **ServerA** to preserve system journals across reboots.

1. Configure `systemd-journald` so that logs are written to persistent storage (disk) rather than just memory.
    
2. Restart the logging service to apply the change.
    
3. Locate all journal entries related to the `sshd` service that have occurred **since the last boot** and save them to `/var/log/ssh_boot.log`.
    

- **Aspects/Domains Covered:** Operate running systems (Locate and interpret system log files and journals, Preserve system journals).

Overall explanation

**Correct Answer**

**1. Configure Persistence:** Edit the main configuration file:

1. vim /etc/systemd/journald.conf

Uncomment (or add) the `Storage` line under the `[Journal]` section and set it to `persistent`:

1. [Journal]
2. Storage=persistent

**2. Restart and Flush:** Restart the service to apply the config, then flush current logs from memory to disk immediately.

1. systemctl restart systemd-journald
2. # Forces the system to write currently buffered logs to the new disk location
3. journalctl --flush

_(Optional Verification)_: Check that the directory was created automatically:

1. ls -ld /var/log/journal

**3. Search and Export Logs:** Filter for the `sshd` unit (`-u`) and the current boot (`-b`), then redirect (`>`) to the requested file.

1. journalctl -u sshd -b > /var/log/ssh_boot.log

**Detailed Explanation for Learners**

- **Volatile vs. Persistent:** By default, RHEL often uses `Storage=auto`, which writes logs to `/run/log/journal` (a RAM disk). When you reboot, these logs disappear. Setting `Storage=persistent` forces the system to store them on the hard drive (`/var/log/journal`) instead.
    
- **Why** `**journalctl --flush**`**?** Even after you change the config, some logs might still be sitting in memory. This command ensures everything is written to disk right now, so you can see the results immediately.
    
- **Why export to a text file?** In a real production environment, you would rarely dump logs to a flat text file because you lose the structured search capabilities of the journal. **However, for the exam, this is a standard grading mechanism.** The automated script checks this specific text file to verify that you successfully filtered the logs using the correct parameters (`-u` and `-b`).

**Question 22**

**Task:** Manage processes on **ServerA**.

1. Start a background process using the command `sleep 1000`.
    
2. Identify the **PID** (Process ID) of this process.
    
3. Adjust the priority (niceness) of this running process to **+5**.
    
4. Finally, kill the process using its PID.
    

- **Aspects/Domains Covered:** Operate running systems (Identify CPU/memory intensive processes and kill processes, Adjust process scheduling).

Overall explanation

**Correct Answer**

**1. Start Background Process:**

1. sleep 1000 &
2. # The shell will likely print the PID immediately, e.g., [1] 12345

**2. Identify PID:** If you missed the PID when starting the job:

1. jobs -l
2. # OR
3. ps aux | grep sleep

**3. Renice (Adjust Priority):** Change the priority to +5.

1. renice -n 5 -p 12345
2. # OR (Long-form syntax)
3. renice --priority 5 --pid 12345

**4. Verify (Optional but recommended):** Check the new Niceness (`NI`) value:

1. ps -o pid,ni,comm -p 12345
2. # Output should show NI as 5

**5. Kill Process:**

1. kill 12345

**Detailed Explanation for Learners**

- `**&**` **(Ampersand):** Puts the command in the background so you get your terminal prompt back immediately. If you forget this, the terminal will "hang" waiting for the sleep command to finish.
    
- **Niceness:** Linux uses "niceness" to determine CPU priority.
    
    - The scale goes from **-20** (Highest Priority, "not nice" to others).
        
    - To **+19** (Lowest Priority, "very nice" to others).
        
    - Default niceness is **0**.
        
- `**renice**` **vs** `**nice**`**:**
    
    - `nice`: Starts a _new_ process with a specific priority (e.g., `nice -n 5 sleep 1000`).
        
    - `renice`: Changes the priority of a process that is _already running_.
        
- `**ps -o**`**:** This format allows you to create a custom view.
    
    - `pid`: Process ID.
        
    - `ni`: The Nice value.
        
    - `comm`: The command name (e.g., `sleep`).
        
    - This is much cleaner than running `ps aux`, which prints dozens of columns you don't need.

**Question 23**

**Task:** Configure Access Control Lists (ACLs) on **ServerA**.

1. Copy the file `/etc/fstab` to `/var/tmp/fstab_copy`.
    
2. Configure permissions on `/var/tmp/fstab_copy` so that the user `alex` has **Read and Write** access.
    
3. Ensure that the group owner and other users retain their existing permissions.
    
4. Do **not** change the file's owner or group owner.
    

- **Aspects/Domains Covered:** Create and configure file systems (Diagnose and correct file permission problems - implicitly ACLs).

Overall explanation

**Correct Answer:**

1. **Copy File:**
    
    1. cp /etc/fstab /var/tmp/fstab_copy
    
2. **Set ACL:**
    
    1. setfacl -m u:alex:rw /var/tmp/fstab_copy
    
3. **Verify:**
    
    1. getfacl /var/tmp/fstab_copy
    2. # Output should list: user:alex:rw-
    

**Detailed Explanation for Learners:**

- **Why ACLs?** Standard permissions (chmod) only allow one owner and one group. What if `root` owns the file, the `admin` group has access, but you _also_ need to give `alex` access without adding him to the `admin` group? ACLs allow this specific, granular targeting.
    
- `**setfacl -m**`**:** **M**odify the Access Control List.
    
- `**u:alex:rw**`**:** Give **U**ser `alex` **R**ead/**W**rite access.
    
- `**+**` **Sign:** When you list the file with `ls -l`, you will see a `+` sign at the end of the permissions (e.g., `-rw-rw-r--+`), indicating an ACL is present.



**Question 24**

**Task:** Create a shell script named `/usr/local/bin/user_audit.sh`.

1. The script should use a **loop** to iterate through the usernames: `root`, `adm`, and `ftp`.
    
2. For each user, it should print the line: "User [username] has ID [uid]".
    
3. You must obtain the UID programmatically (e.g., using the `id` command) inside the loop.
    
4. Ensure the script is executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Use Looping constructs, Process output of shell commands within a script).

**Correct Answer**

**1. Create Script:**

1. vim /usr/local/bin/user_audit.sh

**2. Add Content:**

1. `#!/bin/bash`
2. for USER in root adm ftp
3. do
4.   USERID=$(id -u $USER)
5.   echo "User $USER has ID $USERID"
6. done

**3. Make Executable:**

1. chmod +x /usr/local/bin/user_audit.sh

**4. Verify:**

1. /usr/local/bin/user_audit.sh

**Detailed Explanation for Learners**

- **The** `**for**` **Loop:** This construct allows you to run the same code multiple times—once for each item in the list (`root`, `adm`, `ftp`).
    
- `**$()**` **(Command Substitution):** The code `$(id -u $USER)` runs the `id` command, captures the result (the number), and saves it into the variable `USERID`. This is essential for automating admin tasks.
    
- **Pro Tip:** `**$()**` **vs Backticks (**``**` `**``**):**
    
    - You might see older scripts use backticks (e.g., `` `id -u` ``).
        
    - **For the exam, always use** `**$()**`. It is the modern standard, it is easier to read, and it allows for "nesting" (putting one command inside another), which backticks struggle to handle cleanly.


**Question 25**

**Task:** On **ServerA**, perform a text search and extraction.

1. Search the file `/etc/ssh/sshd_config`.
    
2. Find all lines that **start with** the keyword `Host` (case-insensitive).
    
3. Save these lines to the file `/root/ssh_hosts.txt`.
    
4. Ensure the output file does not contain any commented-out lines (lines starting with `#`).
    

- **Aspects/Domains Covered:** Understand and use essential tools (Use grep and regular expressions to analyze text, Use input-output redirection).



Overall explanation

**Correct Answer**

**1. Execute Search:** Since we are anchoring the search to the start of the line (`^Host`), these lines automatically cannot be comments (which start with `#`). A single command is sufficient:

1. grep -i "^Host" /etc/ssh/sshd_config > /root/ssh_hosts.txt

**2. Verify:**

1. cat /root/ssh_hosts.txt

**Detailed Explanation for Learners**

- `**grep**`**:** The tool used to find text.
    
- `**-i**`**:** Case-insensitive (matches "Host", "host", "HOST").
    
- `**^Host**`**:** The caret `^` is a **Regular Expression anchor** meaning "Start of line."
    
    - This ensures we match lines that actually define a "Host" block.
        
    - It implicitly excludes comments because if a line starts with `Host`, it by definition does not start with `#`.
        
- `**>**`**:** Redirects the output list into the file `/root/ssh_hosts.txt`.


**Question 26**

**Task:** Configure **ServerA** to boot into the **Multi-User Target** by default.

1. Ensure that when the system reboots, it starts in a non-graphical command-line environment.
    
2. Verify the default target has been set correctly.
    

- **Aspects/Domains Covered:** Operate running systems (Boot systems into different targets manually, Configure systems to boot into a specific target automatically).


Overall explanation

**Correct Answer**

1. Set the Default Target

2. systemctl set-default multi-user.target

3. Verify

4. systemctl get-default

Expected output:

1. multi-user.target

**Detailed Explanation for Learners**

- **Targets**  
    In systemd, a "target" is like a "runlevel" in older Linux versions. It defines what state the system should reach.
    
- `**graphical.target**`  
    The GUI (GNOME/Desktop).
    
- `**multi-user.target**`  
    The standard server environment (Networking + Command Line, no GUI).
    
- **Why Use Multi-User?**  
    Servers usually run without a monitor or mouse to save resources (RAM/CPU). Setting this as default ensures the server doesn't waste energy loading a desktop interface that no one is watching.
    
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. `systemctl get-default` reports the setting, but a reboot is the only real proof — the system should come back to a text login prompt with no graphical session.


**Question 27**

**Task:** Configure **ServerA** to allow the web server to run on a non-standard port.

1. Configure the Apache (httpd) server to listen on port **82** (Edit /etc/httpd/conf/httpd.conf).
    
2. Restart the httpd service. It will likely fail.
    
3. Configure **SELinux** to allow the httpd process to bind to TCP port **82**.
    
4. Configure the **Firewall** to allow traffic on TCP port **82**.
    
5. Restart the service successfully.
    

- **Aspects/Domains Covered:** Manage security (Manage SELinux port labels, Configure firewall settings).


**Correct Answer**

1. Configure Apache

2. vim /etc/httpd/conf/httpd.conf

Change:

1. Listen 80

to:

1. Listen 82

2. Update the SELinux Port Label

**Note:** You can use short flags for speed or long flags for readability.

Option A (Fast)

1. semanage port -a -t http_port_t -p tcp 82

Option B (Readable)

1. semanage port --add --type http_port_t --proto tcp 82

2. Update the Firewall

3. firewall-cmd --permanent --add-port=82/tcp
4. firewall-cmd --reload

5. Restart the Service

6. systemctl restart httpd

**Detailed Explanation for Learners**

- **The Problem**  
    By default, SELinux only allows the Web Server (`httpd_t`) to talk on specific ports (80, 443, etc.). If you try to use port 82, SELinux blocks it as "unusual activity," thinking the server might be compromised.
    
- `**semanage port**`  
    This command modifies the policy. We add a rule stating that TCP port 82 is now a valid `http_port_t`.
    
- **Two Layers of Defense**  
    You must open the **Firewall** (to let the network packet in) **AND** configure **SELinux** (to let the application use the port).
    
- **PRO TIP: The "Man Page" Strategy**
    
    - Don't memorize the `semanage` syntax!
        
    - Run:
        
        1. man semanage-port
        
    - Scroll down to the **EXAMPLE** section. You will often find the exact command you need (e.g., `semanage port -a -t http_port_t -p tcp 81`) ready to be copied and adapted.
        
- **Exam Pitfall**
    
    - **Always Use Absolute Paths with SELinux.** When defining custom file contexts using `semanage fcontext`, you must use the absolute directory path (e.g., `/var/www/html(/.*)?`). Using a relative path while sitting in the parent directory will fail to apply the context correctly. This is a very common mistake under the time pressure of the real exam!
        
- **Exam Tip**  
    Always verify that your configuration survives a reboot before considering the task complete. `semanage port` and `firewall-cmd --permanent` are persistent, but `httpd` is not enabled by default. Run:
    
    1. systemctl enable --now httpd
    
    then confirm with:
    
    2. curl localhost:82
    
    after rebooting.


**Task:** Configure default file permissions for the user `harry` on **ServerA**.

1. Modify `harry`'s environment so that any **new file** he creates has the permission `rw-r-----` (640).
    
2. Ensure this setting is persistent (applies every time he logs in).
    

- **Aspects/Domains Covered:** Manage security (Manage default file permissions).


Overall explanation

**Correct Answer**

**1. Edit User's Bash Profile:**

1. vim /home/harry/.bashrc

**2. Add Umask Setting:** Add the following line to the bottom of the file:

1. umask 027

**3. Verify (Simulate Login):**

1. su - harry
2. touch testfile
3. ls -l testfile
4. # Output: -rw-r----- (which is 640)

**Detailed Explanation for Learners**

**What is Umask?** It stands for "User Mask." It acts as a filter that subtracts permissions from the system default.

- **Base Permissions:**
    
    - Files: Start at 666 (rw-rw-rw-).
        
    - Directories: Start at 777 (rwxrwxrwx).
        

**The Math (Why 027?):** The goal is rw-r----- (640) for files.

- **Option A (026):** 666 - 026 = 640. (Matches file goal).
    
- **Option B (027):** 666 - 027 = 640. (Also matches file goal, because files don't have the execute bit anyway).
    
- **Security Best Practice:** While both options work for files, 027 is the correct answer because of how it affects directories.
    
    - With 026: Directories become 751 (rwxr-x--x). The final 'x' allows strangers to "traverse" (enter) your directories.
        
    - With 027: Directories become 750 (rwxr-x---). This completely blocks strangers from entering, which is the secure standard.
        

**Instructor Notes on Syntax & Files:**

- **3-Digit vs. 4-Digit Umask:** You might see umask written as `0027` instead of `027`. Both are exactly the same! The first zero in the 4-digit format simply represents special permissions (SUID/SGID/Sticky Bit). If you use 3 digits, Linux automatically assumes the leading zero.
    
- `**.bashrc**` **vs.** `**.bash_profile**`**:** You can technically place the umask setting in `~/.bash_profile` as well. However, `.bash_profile` only runs for _login_ shells. `.bashrc` runs for _all interactive non-login_ shells. In RHEL, the default `.bash_profile` is configured to automatically source `.bashrc`, so putting your setting in `.bashrc` guarantees the umask is applied every single time the user opens a terminal, regardless of how they access the system.



**Question 29**

**Task:** Securely transfer a file from **ServerA** to **ServerB** (or localhost if ServerB is unavailable).

1. You have a file named `/root/anaconda-ks.cfg` on ServerA.
    
2. Copy this file to the `/tmp` directory on the remote system **ServerB** (or `localhost`).
    
3. Ensure the file attributes (timestamps/permissions) are preserved during the transfer.
    

- **Aspects/Domains Covered:** Operate running systems (Securely transfer files between systems).


Overall explanation

**Correct Answer:**

1. **Execute Transfer:**
    
    1. scp -p /root/anaconda-ks.cfg root@ServerB:/tmp/
    
    _OR (using rsync, which is preferred/modern):_
    
    2. rsync -av /root/anaconda-ks.cfg root@ServerB:/tmp/
    

**Detailed Explanation for Learners:**

- `**scp**` **vs** `**rsync**`**:** `scp` (Secure Copy) is the traditional tool. `rsync` (Remote Sync) is more powerful—it can resume interrupted downloads and only copies changed parts of files. Both run over SSH (port 22) and are encrypted.
    
- **Flags:**
    
    - `scp -p`: **P**reserves modification times and permissions.
        
    - `rsync -a`: **A**rchive mode (preserves almost everything: permissions, owners, times).



**Question 30**

**Task:** Create a shell script on **ServerA** named `/usr/local/bin/checkfile.sh`.

1. The script should accept **one argument** (a filename).
    
2. **Condition:**
    
    - If the file exists, print "File exists."
        
    - If the file does _not_ exist, print "File missing."
        
3. Make the script executable.
    

- **Aspects/Domains Covered:** Create simple shell scripts (Conditionally execute code using `if`, `test`, `[]`).



Overall explanation

**Correct Answer:**

1. **Create Script:**
    
    1. vim /usr/local/bin/checkfile.sh
    
2. **Add Content:**
    
    1. #!/bin/bash
    2. if [ -f "$1" ]; then
    3.     echo "File exists."
    4. else
    5.     echo "File missing."
    6. fi
    
3. **Make Executable:**
    
    1. chmod +x /usr/local/bin/checkfile.sh
    
4. **Verify:**
    
    1. /usr/local/bin/checkfile.sh /etc/passwd
    2. # Output: File exists.
    

**Detailed Explanation for Learners:**

- `**[ -f "$1" ]**`**:** This is the "Test" command.
    
    - `-f`: Checks if the path is a regular **F**ile. (Use `-d` to check for a directory).
        
    - `"$1"`: The first argument you passed to the script.
        
- **If/Else Structure:** The basic logic block of programming. If the test inside `[]` is true, run the first block. Otherwise (`else`), run the second block.









