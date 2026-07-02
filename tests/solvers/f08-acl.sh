#!/usr/bin/env bash
id harry   >/dev/null 2>&1 || useradd harry
id natasha >/dev/null 2>&1 || useradd natasha
# Always copy fresh and fix ownership/mode explicitly: if a prior step left a
# /var/tmp/fstab created under a non-022 umask (e.g. 0640), "others can read"
# would fail. 0644 = rw-r--r-- : other readable, not executable.
cp -f /etc/fstab /var/tmp/fstab
chown root:root /var/tmp/fstab
chmod 0644 /var/tmp/fstab
setfacl -m u:harry:rw-   /var/tmp/fstab        # harry: read + write
setfacl -m u:natasha:--- /var/tmp/fstab        # natasha: no access
