# Reference solution — autofs + NFS (indirect map)

autofs mounts NFS shares on demand and unmounts them when idle. An INDIRECT map
attaches a base directory (here /rhome) to a map file; each key in that file becomes
a subdirectory that autofs mounts from NFS the moment you access it.

## In the real RHCSA exam

The home/share is exported by a SEPARATE NFS server (the exam gives its hostname/IP).
Confirm the export and point the map source at THAT server:

```bash
showmount -e <nfs-server>          # confirm /exports/rhome/remoteuser1 is exported
# in the map, the source uses the remote server:
#   remoteuser1  -rw,sync,fstype=nfs4  <nfs-server>:/exports/rhome/remoteuser1
```

## In this offline lab

There is no separate NFS server, so the share is exported from localhost and the map
source uses `localhost` instead of a remote hostname:

```bash
dnf -y install autofs nfs-utils
# Master map: attach the /rhome base to a map file:
echo '/rhome  /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs
# The map itself — "key  options  source":
echo 'remoteuser1  -rw,sync,fstype=nfs4  localhost:/exports/rhome/remoteuser1' \
     >/etc/auto.rhome
systemctl enable --now autofs
ls /rhome/remoteuser1        # accessing it triggers the automount
```
