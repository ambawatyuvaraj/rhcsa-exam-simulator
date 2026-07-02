# Reference solution — logical volume by size + XFS + persistent mount

`lvcreate -L <SZ>M` makes an LV of a fixed SIZE (use `-l` for an extent COUNT);
format it XFS, then add an fstab line so it remounts on every boot.

```bash
lvcreate -L <SZ>M -n <LV> <VG>                                  # create the LV, <SZ> MiB
mkfs.xfs -f /dev/<VG>/<LV>                                         # format XFS
mkdir -p /mnt/<MP>
echo "/dev/<VG>/<LV> /mnt/<MP> xfs defaults,nofail 0 0" >>/etc/fstab   # persist the mount
mount -a                                                        # mount everything in fstab now
df -h /mnt/<MP>                                                 # verify
```
