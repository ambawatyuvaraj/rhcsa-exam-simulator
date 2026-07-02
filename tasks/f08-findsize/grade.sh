#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/home/manage is a directory"               2 is_dir /home/manage
ckpt_expr "small /usr/bin files were copied"      4 'for f in ls cat find; do [ -e "/home/manage/$f" ] || exit 1; done; exit 0'
ckpt_expr "files >= 5 MiB were excluded"          4 '[ -n "$(ls -A /home/manage 2>/dev/null)" ] && ! find /home/manage -type f -size +5M 2>/dev/null | grep -q .'
