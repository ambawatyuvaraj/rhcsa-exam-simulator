# Reference solution — automount an NFS home with autofs

autofs mounts a path on demand: the master map ties a base directory to a map
file; the map file maps the key (production5) to its NFS source. Accessing the
directory triggers the mount.

## In the real RHCSA exam
The home directory is exported by a separate NFS server (e.g. 172.25.250.10).
Verify the export, then point the autofs map at THAT server:

```bash
dnf install -y nfs-utils autofs
systemctl enable --now autofs
showmount -e 172.25.250.10                          # confirm /localhome is exported

echo '/localhome  /etc/auto.misc' > /etc/auto.master.d/name.autofs            # base -> map file
echo 'production5  -rw,sync,fstype=nfs4  172.25.250.10:/localhome/production5' >> /etc/auto.misc

systemctl restart autofs
ls /localhome/production5                            # accessing it triggers the automount
```

## In this offline lab
There is no separate NFS server, so production5's home is exported from
**localhost** (`/exports/localhome/production5`). Use the same autofs config but
with localhost as the source:

```bash
dnf install -y nfs-utils autofs
systemctl enable --now autofs
grep -q '^/localhome' /etc/auto.master || echo '/localhome  /etc/auto.misc' >> /etc/auto.master
grep -q '^production5' /etc/auto.misc || echo 'production5  -rw,soft  localhost:/exports/localhome/production5' >> /etc/auto.misc
systemctl restart autofs
ls /localhome/production5
```
