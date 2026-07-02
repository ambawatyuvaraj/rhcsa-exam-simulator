# Reference solution — passwordless sudo for a single command

```bash
echo '<U> ALL=(ALL) NOPASSWD: /usr/bin/systemctl' >/etc/sudoers.d/<U>
chmod 0440 /etc/sudoers.d/<U>
visudo -c        # validate syntax
```

Notes:
- Prefer a drop-in file under /etc/sudoers.d/ over editing /etc/sudoers.
- Listing only `/usr/bin/systemctl` after `NOPASSWD:` limits the user to that one
  command.
