#!/usr/bin/env bash
# Extend vgext/lvext to ~600 MiB and grow its ext4 filesystem. Idempotent.
mount /mnt/lvext 2>/dev/null || mount -a 2>/dev/null
lvextend -r -L 600M /dev/vgext/lvext >/dev/null 2>&1 || \
  lvextend -L 600M /dev/vgext/lvext >/dev/null 2>&1
resize2fs /dev/vgext/lvext >/dev/null 2>&1
