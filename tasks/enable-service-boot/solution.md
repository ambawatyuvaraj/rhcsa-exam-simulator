# Reference solution — enable a service for boot (without starting it)

`enable` makes a service start automatically at boot (creates its wants-symlink) but
does NOT start it now — that's what `--now` would add. So afterwards the service is
"enabled" yet still "inactive" until the next boot.

```bash
systemctl enable <SVC>        # enable for boot only (no --now)
systemctl is-enabled <SVC>    # -> enabled
systemctl is-active  <SVC>    # -> inactive
```
