# Reference solution — stop and disable a service

`disable --now` both stops the service immediately and removes its boot-time
autostart, so it is neither running now nor on the next boot.

```bash
systemctl disable --now <SVC>
systemctl is-enabled <SVC>     # -> disabled
systemctl is-active  <SVC>     # -> inactive
```
