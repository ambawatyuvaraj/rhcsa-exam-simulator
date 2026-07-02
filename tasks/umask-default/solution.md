# Reference solution — per-user default umask

Set the umask for the user by adding it to that user's shell startup files.

```bash
# As a per-user setting in the user's home (bash login + interactive shells):
echo 'umask <UM>' >> /home/<U>/.bashrc

# Verify it is what a fresh login shell of that user reports:
runuser -l <U> -c umask        # -> 0<UM>
```

Notes:
- A login shell reads `~/.bash_profile` (which usually sources `~/.bashrc`),
  so placing `umask <UM>` in `~/.bashrc` makes new shells use it.
- A system-wide alternative is `/etc/profile.d/<name>.sh`, but a per-user
  setting only needs the user's own startup file.
