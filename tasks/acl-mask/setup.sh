#!/usr/bin/env bash
echo x >"/root/$F"
setfacl -m u:nobody:rwx "/root/$F" 2>/dev/null
echo "acl-mask: /root/$F has an ACL entry to mask"
exit 0
