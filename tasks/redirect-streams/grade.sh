#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$F1 contains the kernel release" 4 'grep -qxF "$(uname -r)" /root/'"$F1"''
ckpt_expr "/root/$F2 captured the error" 4 '[ -s /root/'"$F2"' ] && grep -q "/nonexistent-" /root/'"$F2"''
