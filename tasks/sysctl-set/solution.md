# Reference solution — set and persist a kernel parameter

Kernel tunables (`sysctl`) reset on reboot unless saved. Put the setting in a drop-in
under /etc/sysctl.d/ so it persists, then apply it to the running kernel.

```bash
echo '<KEY> = <VAL>' > /etc/sysctl.d/99-rhcsa.conf   # persist
sysctl -p /etc/sysctl.d/99-rhcsa.conf                # apply now (or: sysctl --system)
sysctl -n <KEY>                                      # verify -> <VAL>
```
