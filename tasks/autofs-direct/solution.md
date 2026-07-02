# Reference solution — autofs direct map

A DIRECT map mounts a share on demand at one specific absolute path. The master map
points the special mount point `/-` at a direct map file, which lists the full target
path and its NFS source; autofs mounts it the instant the path is accessed.

## In the real RHCSA exam

The share is exported by a SEPARATE NFS server (the exam gives its hostname/IP).
Confirm the export and point the direct-map source at THAT server:

```bash
showmount -e <nfs-server>          # confirm /exports/direct is exported
# in the direct map, the source uses the remote server:
#   /mnt/<MP>  -rw,sync,fstype=nfs4  <nfs-server>:/exports/direct
```

## In this offline lab

There is no separate NFS server, so the share is exported from localhost and the map
source uses `localhost` instead of a remote hostname:

```bash
dnf -y install autofs nfs-utils
# Direct maps use the special "/-" mount point in the master map:
echo "/-  /etc/auto.direct" >/etc/auto.master.d/direct.autofs
# The map lists the absolute target path, options, and NFS source:
echo "/mnt/<MP>  -rw,sync,fstype=nfs4  localhost:/exports/direct" >/etc/auto.direct
systemctl enable --now autofs
ls /mnt/<MP>        # accessing the path triggers the automount
```
