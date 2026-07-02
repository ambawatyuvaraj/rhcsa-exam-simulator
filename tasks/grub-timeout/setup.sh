#!/usr/bin/env bash
cp /etc/default/grub /etc/default/grub.rhcsabak 2>/dev/null
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub 2>/dev/null
echo "grub-timeout: seeded GRUB_TIMEOUT=1"
exit 0
