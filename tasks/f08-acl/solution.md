# Reference solution — POSIX ACLs on a file

Copying `/etc/fstab` gives a root:root file with mode `0644` (already readable by
others, not executable). Two ACL entries then grant harry read/write and deny
natasha entirely.

```bash
cp /etc/fstab /var/tmp                       # root:root, 0644 (not executable)
setfacl -m u:harry:rw- /var/tmp/fstab        # harry: read + write
setfacl -m u:natasha:--- /var/tmp/fstab      # natasha: no access
getfacl /var/tmp/fstab                       # verify
```
(harry and natasha are the users created in the users/group task.)
