# Reference solution — passwordless sudo for a group

A `%group` line in sudoers grants sudo to every member; `NOPASSWD: ALL` removes
the password prompt. Put it in a drop-in file under `/etc/sudoers.d/` (mode 0440)
and always validate with `visudo -c` afterwards.

```bash
echo '%sysmgrs ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sysmgrs   # the rule
chmod 440 /etc/sudoers.d/sysmgrs                                   # correct permissions
visudo -c                                                          # validate the sudoers syntax
```
