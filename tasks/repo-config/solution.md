# Reference solution — configure local (file://) repositories

Each repository is a stanza in a `.repo` file under /etc/yum.repos.d/. A
`baseurl=file://` points dnf at packages on local disk (the offline exam model);
`gpgcheck=0` skips signature checks for the local tree.

```bash
cat >/etc/yum.repos.d/rhcsa.repo <<'EOF'
[BaseOS]
name=BaseOS
baseurl=file:///opt/rhcsa-repo/BaseOS
enabled=1
gpgcheck=0

[AppStream]
name=AppStream
baseurl=file:///opt/rhcsa-repo/AppStream
enabled=1
gpgcheck=0
EOF

dnf clean all            # drop cached metadata
dnf repolist enabled     # verify BaseOS + AppStream are listed
```
