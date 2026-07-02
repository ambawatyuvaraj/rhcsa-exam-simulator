# Reference solution — persistently mount a peer's NFS export (client side)

Mount the server's export at boot via fstab. `_netdev` tells systemd the mount needs
the network up first, so boot doesn't hang or fail before networking is ready.

```bash
dnf -y install nfs-utils
mkdir -p /mnt/peernfs
showmount -e node1.example.com          # confirm the server's export
echo "node1.example.com:/exports/nodeshare /mnt/peernfs nfs defaults,_netdev 0 0" >>/etc/fstab
mount -a
findmnt /mnt/peernfs      # verify
```
