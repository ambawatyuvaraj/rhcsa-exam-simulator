#!/usr/bin/env bash
# Create a hard link and a symbolic link to /root/linksrc.txt. Idempotent.
[ -e /root/linksrc.txt ] || echo "link target content" > /root/linksrc.txt
[ "/root/$HL" -ef /root/linksrc.txt ] 2>/dev/null || { rm -f "/root/$HL"; ln /root/linksrc.txt "/root/$HL"; }
[ -L "/root/$SL" ] && [ "$(readlink -f "/root/$SL")" = /root/linksrc.txt ] || { rm -f "/root/$SL"; ln -s /root/linksrc.txt "/root/$SL"; }
