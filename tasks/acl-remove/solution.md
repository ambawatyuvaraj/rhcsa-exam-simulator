# Reference solution — remove an ACL entry

```bash
setfacl -x u:bin /root/<F>
getfacl -p /root/<F>      # the user:bin line is gone
```
`-x` removes a specific ACL entry. To strip ALL ACLs use `setfacl -b`.
