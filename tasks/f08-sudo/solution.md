# Reference solution — passwordless sudo for a group

A `%group` line in sudoers grants sudo to every member; `NOPASSWD: ALL` removes
the password prompt. Always validate the file with `visudo -c` afterwards.

```bash
groupadd admin                                           # create the group if it does not exist
echo "%admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers    # append the rule
visudo -c                                                # validate the sudoers syntax
```
