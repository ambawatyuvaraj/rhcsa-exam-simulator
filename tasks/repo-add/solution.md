# Reference solution — configure a local dnf repository

A `.repo` file under `/etc/yum.repos.d/` defines a repository: a section id in
`[brackets]`, a name, the `baseurl` packages are fetched from (here a local
directory via `file://`), and the enabled/gpgcheck flags.

```bash
cat > /etc/yum.repos.d/<RID>.repo <<'EOF'
[<RID>]
name=<RID>
baseurl=file://<DIR>
enabled=1
gpgcheck=0
EOF

dnf clean all
dnf repolist enabled | grep <RID>     # verify the repo is enabled and listed
```
