# Reference solution — passwordless SSH to the peer

Set up key-based login: generate an SSH key pair (empty passphrase for automation),
then copy the PUBLIC key into deploy's authorized_keys with `ssh-copy-id`. It asks
ONCE for **deploy's** password — `Redhat123`, the password set on node2 in the
"provide a login account" task. (That is the deploy account's password, NOT node2's
root password, which stays unknown.) After the key is installed, SSH needs no password.

```bash
# Generate root's key if it does not already exist:
[ -f /root/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f /root/.ssh/id_ed25519
# Push the PUBLIC key to deploy@node2 — enter deploy's password (Redhat123) once:
ssh-copy-id -i /root/.ssh/id_ed25519.pub deploy@node2.example.com
ssh deploy@node2.example.com true     # verify: connects with no password
```
