# Reference solution — ACLs

```bash
cp /etc/fstab /var/tmp/fstab
# owner/group root by default; ensure not executable:
chmod 0644 /var/tmp/fstab
setfacl -m u:frank:rw- /var/tmp/fstab
setfacl -m u:grace:--- /var/tmp/fstab
getfacl /var/tmp/fstab
```
The base "other" class keeps read for everyone else; named ACL entries
override for frank and grace.
