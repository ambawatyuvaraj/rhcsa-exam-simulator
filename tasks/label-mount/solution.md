# Reference solution — mount by filesystem label

```bash
blkid | grep <LBL>           # confirm the label exists
mkdir -p /mnt/<MP>
echo "LABEL=<LBL> /mnt/<MP> ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
Mounting by `LABEL=` (or `UUID=`) is stable across device-name changes.
