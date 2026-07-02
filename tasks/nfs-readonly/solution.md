# Reference solution — read-only NFS mount

Mount an NFS export read-only by adding the `ro` option in fstab (`_netdev` so it
waits for the network at boot).

```bash
dnf install -y nfs-utils                      # provides showmount + NFS client mount
mkdir -p /mnt/<MP>
showmount -e localhost
echo "localhost:/exports/ro /mnt/<MP> nfs ro,_netdev 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>         # verify the options include ro
```
