# Reference solution — XFS logical volume mounted by UUID

Mounting by UUID is robust against device-name changes. Format the LV, read its
UUID with `blkid`, and put that UUID in fstab.

```bash
mkfs.xfs /dev/<VG>/<LV>                                         # format XFS (assigns a UUID)
mkdir -p /mnt/<MP>
echo "UUID=$(blkid -s UUID -o value /dev/<VG>/<LV>) /mnt/<MP> xfs defaults,nofail 0 0" >>/etc/fstab   # mount by UUID
mount -a
findmnt /mnt/<MP>                                               # verify it is mounted
```
