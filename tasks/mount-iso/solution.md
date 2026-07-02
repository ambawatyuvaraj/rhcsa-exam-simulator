# Reference solution — persistently loop-mount an ISO read-only

```bash
mkdir -p /mnt/<MP>
echo "/root/<ISO>.iso /mnt/<MP> iso9660 loop,ro 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
The `loop` option attaches a loopback device for the image file; `ro` keeps it
read-only (ISO9660 is read-only anyway).
