# Reference solution — restart and enable a service

Make sure the service runs now and on every boot: `enable` sets the boot autostart and
`restart` (re)starts it immediately to pick up any new configuration.

```bash
systemctl enable <SVC>         # start at boot
systemctl restart <SVC>        # (re)start now
systemctl is-enabled <SVC>     # -> enabled
systemctl is-active  <SVC>     # -> active
```
