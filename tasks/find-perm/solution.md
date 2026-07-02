# Reference solution — find files with an exact permission and copy them

```bash
mkdir -p /root/<OUT>
find /opt/permsrc -type f -perm <MODE> -exec cp -t /root/<OUT> {} +
```

`-perm <MODE>` matches files whose permission bits are exactly `<MODE>` (octal).
Use `-perm -<MODE>` for "at least these bits"; here we want an exact match.
