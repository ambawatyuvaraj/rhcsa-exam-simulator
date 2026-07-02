# Reference solution — SSH key-based authentication

```bash
# Generate a key pair for root with no passphrase, at the requested path:
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rhcsa

# Install the public key into the target user's authorized_keys.
# Easiest (also fixes permissions/ownership):
ssh-copy-id -i /root/.ssh/id_rhcsa.pub <U>@localhost

# Test:
ssh -i /root/.ssh/id_rhcsa <U>@localhost hostname
```

Manual alternative to ssh-copy-id:
```bash
h=$(getent passwd <U> | cut -d: -f6)
install -d -m 700 -o <U> -g <U> "$h/.ssh"
cat /root/.ssh/id_rhcsa.pub >> "$h/.ssh/authorized_keys"
chown <U>:<U> "$h/.ssh/authorized_keys"
chmod 600 "$h/.ssh/authorized_keys"
restorecon -RF "$h/.ssh"   # IMPORTANT: a raw append leaves authorized_keys as
                           # default_t; sshd then silently rejects the key.
                           # ssh-copy-id sets this context for you.
```
