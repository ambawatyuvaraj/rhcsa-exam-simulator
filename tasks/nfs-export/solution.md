# Reference solution — export a directory over NFS (server side)

Share a directory over NFS: install nfs-utils, declare the export in
/etc/exports.d/, start nfs-server, re-export, and open the firewall so clients can
reach it.

```bash
dnf -y install nfs-utils
id remoteu >/dev/null 2>&1 || useradd -u 4400 -d /exports/nodeshare/remoteu -m remoteu
# Export the directory (rw, synchronous writes):
echo '/exports/nodeshare *(rw,sync,no_root_squash)' >/etc/exports.d/nodeshare.exports
systemctl enable --now nfs-server
exportfs -ra              # re-read the export tables
exportfs -v               # confirm the export is active
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
```
