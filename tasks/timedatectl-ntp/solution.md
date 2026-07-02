# Reference solution — enable NTP time synchronisation

`timedatectl set-ntp true` turns on automatic clock synchronisation (it enables the
time-sync service, e.g. chronyd).

```bash
timedatectl set-ntp true
timedatectl show -p NTP --value        # verify -> yes
```
