# Reference solution — configure the package repositories in rhcsa.repo

Create two repository stanzas in `/etc/yum.repos.d/rhcsa.repo`, both
`enabled=1` with `gpgcheck=0`. Use the **exact baseurls given in the task**:
`file:///opt/rhcsa-repo/BaseOS` and `file:///opt/rhcsa-repo/AppStream` — these
are the on-disk package trees this lab provisions, and they are what the grader
checks.

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

dnf clean all          # drop cached metadata
dnf repolist           # both BaseOS and AppStream must be listed
```

Verify each repo independently before moving on:

```bash
dnf --disablerepo='*' --enablerepo=BaseOS    repolist
dnf --disablerepo='*' --enablerepo=AppStream repolist
```

## In the real RHCSA exam (reference only)

On the real exam the published answer key points the baseurls at the classroom
HTTP content tree instead, e.g.:

```ini
baseurl=http://content/rhel9.0/x86_64/dvd/BaseOS
baseurl=http://content/rhel9.0/x86_64/dvd/AppStream
```

That `http://content/...` host only exists inside the exam network — it does
**not** resolve in this offline lab, so do not use it here. Use the
`file:///opt/rhcsa-repo/...` URLs above (the task prompt states them). The
mechanics are identical; only the baseurl location differs.
