#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "GRUB_TIMEOUT=$N in /etc/default/grub" 4 'grep -q "^GRUB_TIMEOUT='"$N"'$" /etc/default/grub'
ckpt_expr "regenerated grub.cfg reflects timeout $N" 4 'grep -hoR "set timeout=\"\?'"$N"'\"\?" /boot/grub2/grub.cfg /boot/efi/EFI/*/grub.cfg 2>/dev/null | grep -q .'
