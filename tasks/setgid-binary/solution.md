# Reference solution — SGID bit on a binary

The SGID bit on an executable makes it run with the file's GROUP, not the caller's —
useful for granting group-level access. Add it with `g+s` (or octal `2` in front of
the mode).

```bash
chmod g+s /usr/local/bin/<B>           # or: chmod 2755 /usr/local/bin/<B>
stat -c '%A %a' /usr/local/bin/<B>     # verify: 's' in the group slot, e.g. rwxr-sr-x / 2755
```
