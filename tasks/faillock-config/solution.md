# Reference solution — faillock deny count

```bash
# Uncomment/add the deny line in /etc/security/faillock.conf:
echo 'deny = <N>' >> /etc/security/faillock.conf
# (or edit the existing commented '# deny = 3' line)

# Verify:
grep '^deny' /etc/security/faillock.conf
```

On RHEL 9 pam_faillock is enabled via `authselect`; this task only requires the
deny count be set in faillock.conf.
