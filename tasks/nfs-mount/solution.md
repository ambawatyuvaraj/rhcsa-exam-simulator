# Reference solution — persistently mount an NFS export

```bash
dnf install -y nfs-utils                # client tooling (usually present)
mkdir -p /mnt/<MP>
showmount -e localhost                  # confirm the export
echo "localhost:/exports/share2 /mnt/<MP> nfs defaults,_netdev 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
The `_netdev` option is recommended for network filesystems in fstab.
