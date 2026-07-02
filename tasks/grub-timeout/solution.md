# Reference solution — GRUB menu timeout

The boot-menu wait is `GRUB_TIMEOUT` in /etc/default/grub. After changing that file you
MUST regenerate the actual bootloader config with `grub2-mkconfig`, or the change won't
take effect at boot.

```bash
# Set the timeout in /etc/default/grub:
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=<N>/' /etc/default/grub
# Regenerate the bootloader config (BIOS path shown; UEFI: /boot/efi/EFI/<distro>/grub.cfg):
grub2-mkconfig -o /boot/grub2/grub.cfg
grep ^GRUB_TIMEOUT /etc/default/grub        # verify -> GRUB_TIMEOUT=<N>
```
