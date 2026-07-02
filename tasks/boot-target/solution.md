# Reference solution — default boot target

The default systemd target decides what state the system boots into.
`multi-user.target` is the text/non-graphical state; `set-default` updates the
`default.target` symlink so the choice persists across reboots.

```bash
systemctl set-default multi-user.target   # persist the default boot target (text mode)
systemctl get-default                      # verify: multi-user.target
```
