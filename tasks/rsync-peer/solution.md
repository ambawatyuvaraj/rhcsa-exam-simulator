# Reference solution — rsync to the peer over SSH

`rsync -a -e ssh` copies a directory to the peer over SSH, preserving permissions,
ownership and timestamps. The connection is to the **deploy** account on node2: if you
already set up passwordless SSH (the SSH-key task), it just works; otherwise rsync
prompts for deploy's password (`Redhat123`) — not node2's root password.

```bash
dnf install -y rsync                          # rsync is not in a minimal install
rsync -a -e ssh /opt/datasrc deploy@node2.example.com:/home/deploy/
ssh deploy@node2.example.com 'ls -l /home/deploy/datasrc/file1'   # verify on the peer
```
Note: no trailing slash on the source — `/opt/datasrc` copies the directory itself
(becoming `/home/deploy/datasrc`).
