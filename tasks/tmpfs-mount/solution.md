# Reference solution — persistent tmpfs

```bash
mkdir -p /mnt/<MP>
echo "tmpfs /mnt/<MP> tmpfs size=<SZ>M 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
tmpfs is RAM-backed; the `size=` option caps how much memory it may use.
