#!/usr/bin/env bash
mv -f /etc/default/grub.rhcsabak /etc/default/grub 2>/dev/null
restorecon -F /etc/default/grub 2>/dev/null   # mv keeps the backup's label; put the file's own back
exit 0
