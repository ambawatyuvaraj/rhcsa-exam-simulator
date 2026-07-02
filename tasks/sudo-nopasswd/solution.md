# Reference solution — passwordless sudo for a group

```bash
echo '%sysmgrs ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/sysmgrs
chmod 0440 /etc/sudoers.d/sysmgrs
visudo -c        # validate syntax
```
Prefer a file in /etc/sudoers.d/ over editing /etc/sudoers directly.
