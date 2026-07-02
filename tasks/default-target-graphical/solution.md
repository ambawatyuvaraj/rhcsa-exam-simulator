# Reference solution — set the default systemd target

The default target is what the system boots into. `graphical.target` brings up the
GUI (it pulls in multi-user.target plus a display manager). `set-default` updates the
default.target symlink so the choice persists across reboots.

```bash
systemctl set-default graphical.target
systemctl get-default        # verify -> graphical.target
```
