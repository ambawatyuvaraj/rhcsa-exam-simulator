# Reference solution — mask a service

Masking links the unit to /dev/null so it CANNOT be started — by you, by a dependency,
or at boot. It is stronger than `disable` (which only removes the boot autostart).

```bash
systemctl mask <SVC>
systemctl is-enabled <SVC>     # -> masked
```
