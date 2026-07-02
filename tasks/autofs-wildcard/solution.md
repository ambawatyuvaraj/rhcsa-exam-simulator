# Reference solution — autofs indirect wildcard map

A WILDCARD map serves many subdirectories with one rule: the key `*` matches any
requested name and `&` expands to that name in the NFS source — so /autohomes/u1
mounts .../homes/u1, /autohomes/u2 mounts .../homes/u2, and so on, all on demand.

## In the real RHCSA exam

The per-name directories are exported by a SEPARATE NFS server (the exam gives its
hostname/IP). Confirm the export and point the wildcard source at THAT server:

```bash
showmount -e <nfs-server>          # confirm /exports/homes is exported
# in the wildcard map, the source uses the remote server:
#   *  -rw,sync,fstype=nfs4  <nfs-server>:/exports/homes/&
```

## In this offline lab

There is no separate NFS server, so the share is exported from localhost and the map
source uses `localhost` instead of a remote hostname:

```bash
dnf -y install autofs nfs-utils
# Indirect master entry for the /autohomes base:
echo "/autohomes  /etc/auto.homes" >/etc/auto.master.d/homes.autofs
# Wildcard map: * matches any key, & expands to that key:
echo '*  -rw,sync,fstype=nfs4  localhost:/exports/homes/&' >/etc/auto.homes
systemctl enable --now autofs
ls /autohomes/u1        # triggers the on-demand mount of u1
```
