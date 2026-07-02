# Reference solution — persistent SELinux file context

```bash
dnf install -y policycoreutils-python-utils   # semanage ships here (not pre-installed)
# Add a persistent rule for the directory and everything beneath it:
semanage fcontext -a -t httpd_sys_content_t "<DIR>(/.*)?"

# Apply the rule to existing files:
restorecon -R -v <DIR>
```

Verify:
```bash
semanage fcontext -l | grep '<DIR>'   # shows httpd_sys_content_t
ls -Z <DIR>/index.html                # type is httpd_sys_content_t
```

Notes:
- `semanage fcontext -a` writes the rule to local policy so it survives
  reboots and relabels; `restorecon` applies it to files already present.
