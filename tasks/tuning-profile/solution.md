# Reference solution — apply the recommended tuned profile

Install/enable tuned, then apply the profile tuned itself recommends for this machine
(`tuned-adm recommend` — e.g. virtual-guest on a VM).

```bash
dnf -y install tuned
systemctl enable --now tuned
tuned-adm profile "$(tuned-adm recommend)"   # apply the recommended profile
tuned-adm active                              # verify
```
