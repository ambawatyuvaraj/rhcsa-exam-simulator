# Reference solution — fix permissions and ownership

Set a file's permission bits with `chmod` and its owner/group with `chown`, then
confirm with `ls -l`.

```bash
chmod <MODE> <TGT>        # set the permission bits, e.g. 644
chown root:root <TGT>     # set owner and group
ls -l <TGT>               # verify
```
