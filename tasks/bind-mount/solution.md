# Reference solution — persistent bind mount

```bash
mkdir -p /mnt/<MP>
echo "/srv/<SRC> /mnt/<MP> none bind 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
A bind mount makes an existing directory tree visible at a second location;
the `bind` option in fstab makes it persistent.
