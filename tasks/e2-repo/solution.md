# Reference solution — configure the package repositories in rhcsa.repo

Create two repository stanzas in `/etc/yum.repos.d/rhcsa.repo`, both
`enabled=1` with `gpgcheck=0`. Use the **exact baseurls given in the task**:
`file:///opt/rhcsa-repo/BaseOS` and `file:///opt/rhcsa-repo/AppStream` — the
on-disk package trees this lab provisions, and what the grader checks.

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

## In the real RHCSA exam (reference only)

On the real exam the answer key points the baseurls at the classroom HTTP
content tree instead (e.g. `http://content/rhel9.0/x86_64/dvd/BaseOS` and
`.../AppStream`). That host only exists inside the exam network — it does
**not** resolve in this offline lab, so use the `file:///opt/rhcsa-repo/...`
URLs above (the prompt states them). Only the baseurl location differs.
