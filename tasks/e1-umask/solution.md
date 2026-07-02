# Reference solution — per-user default umask

A umask of `277` produces `r--------` for new files and `r-x------` for new
directories (read-only for the owner, nothing for group/other). Set it in
natasha's own login profile, `~/.bash_profile`.

```bash
useradd natasha 2>/dev/null || true
echo 'umask 277' >> /home/natasha/.bash_profile   # natasha's default umask
runuser -l natasha -c umask                        # verify -> 0277
```
