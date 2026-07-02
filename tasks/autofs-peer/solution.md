# Reference solution — autofs of a peer's NFS home

Mount a user's home from the peer server over NFS, on demand. Create the local
account with its home set to the autofs path and NO local home dir (`-M`); an indirect
autofs map then fetches the home from the peer when that directory is first accessed.

This is the one autofs task whose lab shape already matches the real exam: the home
lives on a *separate* machine. In the real RHCSA exam that machine is the remote NFS
server the exam names; here the peer node (node1.example.com) IS that remote NFS
server stand-in. Either way you confirm the export and point the map at that host:

```bash
showmount -e node1.example.com     # confirm /exports/nodeshare/remoteu is exported
```

```bash
dnf -y install autofs nfs-utils
# Local user, no local home (-M); home points at the autofs-managed path:
useradd -u 4400 -M -d /rhome/remoteu remoteu
# Master map (indirect, base /rhome):
echo '/rhome  /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs
# Map entry — fetch this user's home from the peer (the remote NFS server) over NFS:
echo 'remoteu  -rw,sync,fstype=nfs4  node1.example.com:/exports/nodeshare/remoteu' \
     >/etc/auto.rhome
systemctl enable --now autofs
ls /rhome/remoteu        # triggers the automount from the peer
```
