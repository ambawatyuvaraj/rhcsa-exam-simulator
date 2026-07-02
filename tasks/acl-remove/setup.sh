#!/usr/bin/env bash
echo x >"/root/$F"
setfacl -m u:bin:rwx "/root/$F" 2>/dev/null
echo "acl-remove: /root/$F has a user:bin ACL entry"
exit 0
