# Reference solution — sticky world-writable directory

```bash
mkdir -p /<DIR>
chmod 1777 /<DIR>
stat -c %a /<DIR>     # 1777
```
The leading `1` is the sticky bit (like /tmp): everyone can write, but only the
owner of a file (or root) can remove it.
