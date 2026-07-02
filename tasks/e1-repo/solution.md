# Reference solution — configure the package repositories in app.repo

Create two repository stanzas in `/etc/yum.repos.d/app.repo`, both
`enabled=1` with `gpgcheck=0`. Use the **exact baseurls given in the task**:
`file:///opt/rhcsa-repo/BaseOS` and `file:///opt/rhcsa-repo/AppStream` — the
on-disk package trees this lab provisions, and what the grader checks.

```bash
cat >/etc/yum.repos.d/app.repo <<'EOF'
[BaseOS]
name=base
baseurl=file:///opt/rhcsa-repo/BaseOS
gpgcheck=0
enabled=1

[AppStream]
name=app
baseurl=file:///opt/rhcsa-repo/AppStream
gpgcheck=0
enabled=1
EOF

dnf clean all          # drop cached metadata
dnf repolist enabled   # both BaseOS and AppStream must be listed
```

## In the real RHCSA exam (reference only)

On the real exam the answer key points the baseurls at the classroom HTTP
mirror instead (e.g. `http://classroom.example.com/content/.../BaseOS` and
`.../AppStream`). That host only exists inside the exam network — it does
**not** resolve in this offline lab, so use the `file:///opt/rhcsa-repo/...`
URLs above (the prompt states them). Only the baseurl location differs.
