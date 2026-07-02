# Reference solution — restrict su to the wheel group

Edit `/etc/pam.d/su` and uncomment the pam_wheel line:

```
auth            required        pam_wheel.so use_uid
```

```bash
# Non-interactive equivalent:
sed -i -E 's|^[[:space:]]*#[[:space:]]*(auth[[:space:]]+required[[:space:]]+pam_wheel\.so.*use_uid.*)|\1|' /etc/pam.d/su

# Verify (the line is now active / not commented):
grep pam_wheel /etc/pam.d/su
```

Now only users in the `wheel` group may run `su`.
