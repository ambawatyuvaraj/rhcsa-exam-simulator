# Reference solution — default ACL

```bash
setfacl -m d:g:<G>:rwx /<DIR>
getfacl -p /<DIR>      # shows default:group:<G>:rwx
```
The `d:` (default) prefix makes the ACL apply to objects created later inside
the directory, rather than to the directory itself.
