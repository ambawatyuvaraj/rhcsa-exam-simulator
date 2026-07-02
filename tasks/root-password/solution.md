# Reference solution — reset a lost root password (boot interruption)

The root password is unknown, so you reset it from the boot loader. Do this on the
VM **console** (not over SSH — you have to interrupt GRUB, which only the console
sees). The method: edit the kernel boot line in GRUB so the system starts a root
shell directly with `init=/bin/bash` (skipping normal startup and the login), then
change the password from that shell.

1. **Reboot** the system. At the GRUB menu, highlight the default entry and press
   **`e`** to edit it.
2. Find the line that starts with **`linux`** (the kernel command line) and go to its
   end — press **Ctrl+e** to jump there. Append:  **`init=/bin/bash`**
   This tells the kernel to run a bash shell as PID 1 instead of systemd, so you get
   a root prompt with no password asked.
3. Press **Ctrl‑x** (or F10) to boot with that edit.
4. You land at a root shell, but `/` is mounted **read‑only**. Remount it writable,
   set root's password, flag SELinux to relabel (so `/etc/shadow` gets the right
   context — SELinux is Enforcing), then hand control back to systemd to finish boot:
   ```bash
   mount -o remount,rw /                    # make the root filesystem writable
   echo 'root:{{PW}}' | chpasswd            # set root's password to {{PW}}
   touch /.autorelabel                      # force a SELinux relabel on next boot
   exec /usr/lib/systemd/systemd            # continue booting normally
   ```
   The relabel causes one extra automatic reboot — that is expected. (Skipping
   `touch /.autorelabel` is the #1 mistake: the new `/etc/shadow` keeps the wrong
   SELinux context and login still fails.)
5. After it boots, log in on the console as **root** with the new password **{{PW}}**.

> `init=/bin/bash` is the method to use. (The older `rd.break` / `switch_root`
> approach still works but is no longer the preferred route.)
