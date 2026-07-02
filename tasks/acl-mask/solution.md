# Reference solution — ACL mask

```bash
setfacl -m m::r-x /root/<F>
getfacl -p /root/<F>      # mask::r-x
```
The mask limits the maximum effective permission of named users, named groups,
and the owning group. Setting it to r-x drops write access for those entries.
