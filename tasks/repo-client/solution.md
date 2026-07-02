# Reference solution — configure a dnf repo from a remote HTTP server

A `.repo` file under /etc/yum.repos.d/ defines a repository: an id, a name, the
`baseurl` to fetch from (here the peer's HTTP server), enabled, and gpgcheck. After
adding it, clear the cache and confirm dnf sees it.

```bash
cat >/etc/yum.repos.d/peerrepo.repo <<'EOF'
[peerrepo]
name=Peer repository
baseurl=http://node1.example.com/pkgrepo
enabled=1
gpgcheck=0
EOF

dnf clean all
dnf repolist enabled        # verify "peerrepo" is listed
```
