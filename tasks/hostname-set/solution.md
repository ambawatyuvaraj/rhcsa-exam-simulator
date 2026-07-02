# Reference solution — set the static hostname

`hostnamectl set-hostname` writes the permanent (static) hostname to /etc/hostname so
it survives reboots.

```bash
hostnamectl set-hostname <HN>
hostnamectl --static         # verify -> <HN>
```
