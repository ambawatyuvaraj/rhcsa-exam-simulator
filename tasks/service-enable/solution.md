# Reference solution — enable and start a service

`enable --now` does both halves at once: starts the service immediately AND sets it to
start automatically at every boot.

```bash
systemctl enable --now <SVC>
systemctl is-enabled <SVC>     # -> enabled
systemctl is-active  <SVC>     # -> active
```
