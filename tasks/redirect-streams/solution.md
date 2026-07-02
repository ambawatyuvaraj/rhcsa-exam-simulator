# Reference solution — redirect output and error streams

```bash
# Append the kernel release to /root/<F1> (>> appends, does not truncate)
uname -r >> /root/<F1>

# Redirect ONLY standard error (fd 2) of the command to /root/<F2>
ls /nonexistent-$$ 2> /root/<F2>
```

Notes:
- `>>` appends; `>` would overwrite.
- `2>` redirects file descriptor 2 (stderr); stdout (fd 1) is left untouched.
