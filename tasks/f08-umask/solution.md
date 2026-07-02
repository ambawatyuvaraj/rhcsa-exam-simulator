# Reference solution — per-user default umask

A umask of `027` produces `rw-r-----` for new files and `rwxr-x---` for new
directories. Set it in the user's own `~/.bashrc`.

```bash
useradd daffy 2>/dev/null || true
echo 'umask 027' >> /home/daffy/.bashrc      # daffy's default umask
su - daffy -c umask                           # verify -> 0027
```
