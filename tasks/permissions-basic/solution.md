# Reference solution — set file permissions

```bash
chmod <MODE> <TGT>
# Owner/group already root; if needed:
chown root:root <TGT>
ls -l <TGT>
```

`chmod` with an octal mode sets the permission bits exactly.
