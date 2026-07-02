#!/usr/bin/env bash
# Set GRUB_TIMEOUT and regenerate the bootloader config (idempotent).
if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
  sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$N/" /etc/default/grub
else
  echo "GRUB_TIMEOUT=$N" >> /etc/default/grub
fi

# Regenerate whichever grub.cfg is active (UEFI takes precedence if present).
ue=$(ls /boot/efi/EFI/*/grub.cfg 2>/dev/null | head -1)
if [ -n "$ue" ]; then
  grub2-mkconfig -o "$ue" >/dev/null 2>&1
fi
if [ -f /boot/grub2/grub.cfg ]; then
  grub2-mkconfig -o /boot/grub2/grub.cfg >/dev/null 2>&1
fi
