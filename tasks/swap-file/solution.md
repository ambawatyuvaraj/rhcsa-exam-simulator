# Reference solution — swap file

```bash
dd if=/dev/zero of=/swapfile bs=1M count=<SZ>   # or: fallocate -l <SZ>M /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap defaults,nofail 0 0" >>/etc/fstab
swapon -a
swapon --show
```
`chmod 600` is required or `mkswap`/`swapon` will warn/refuse.
