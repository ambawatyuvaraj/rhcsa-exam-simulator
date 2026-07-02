#!/usr/bin/env bash
  cp /etc/fstab /var/tmp/fstab; chmod 0644 /var/tmp/fstab
  setfacl -m u:frank:rw- /var/tmp/fstab; setfacl -m u:grace:--- /var/tmp/fstab
