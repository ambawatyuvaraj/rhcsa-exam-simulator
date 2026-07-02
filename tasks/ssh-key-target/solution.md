# Reference solution — provide a login account on this system

Create the account the peer will log into and give it a password (so `ssh-copy-id` from
the peer can authenticate the first time), and make sure sshd is running.

```bash
id deploy >/dev/null 2>&1 || useradd -m deploy
echo 'deploy:Redhat123' | chpasswd      # initial password for ssh-copy-id
systemctl enable --now sshd
```
