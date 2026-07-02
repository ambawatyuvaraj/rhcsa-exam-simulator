# Reference solution — deny SSH root login

Prevent direct root logins over SSH by setting `PermitRootLogin no`. A drop-in under
sshd_config.d/ is the clean way (the main config includes that directory); reload sshd
and confirm the *effective* value with `sshd -T`.

```bash
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/99-rhcsa-norootlogin.conf
systemctl reload sshd
sshd -T | grep -i permitrootlogin     # verify -> permitrootlogin no
```
