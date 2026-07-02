# Reference solution — automount an NFS home with autofs

autofs mounts a path on demand. Accessing the directory triggers the NFS mount;
when idle it is unmounted automatically.

## In the real RHCSA exam
The home directory is exported by a separate NFS server (e.g. materials.example.com).
Verify the export, then point the autofs map at THAT server (the answer key uses a
direct map):

```bash
dnf install -y nfs-utils autofs
systemctl enable --now autofs
showmount -e materials.example.com                  # confirm /rhome is exported

echo '/-  /etc/auto.rhome' > /etc/auto.master.d/homedir.autofs                 # direct map
echo '/rhome  -rw,sync,fstype=nfs4  materials.example.com:/rhome' > /etc/auto.rhome

systemctl restart autofs
ls /rhome/remoteuser1                                # accessing it triggers the automount
```

## In this offline lab
There is no separate NFS server, so remoteuser1's home is exported from
**localhost** (`/exports/rhome/remoteuser1`). An indirect map pointing at
localhost mounts only remoteuser1's home (exactly what the task asks):

```bash
dnf install -y nfs-utils autofs
systemctl enable --now autofs
grep -q '^/rhome' /etc/auto.master || echo '/rhome  /etc/auto.misc' >> /etc/auto.master
grep -q '^remoteuser1' /etc/auto.misc || echo 'remoteuser1  -rw,soft  localhost:/exports/rhome/remoteuser1' >> /etc/auto.misc
systemctl restart autofs
ls /rhome/remoteuser1
```
