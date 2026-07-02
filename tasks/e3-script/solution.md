# Reference solution — find-and-copy script (400k–800k)

`find /usr/share -type f -size +400k -size -800k` matches every regular file
larger than 400 KiB and smaller than 800 KiB; `-exec cp ... {} /root/myfiles/ \;`
copies each match into the destination (which must exist first).

```bash
mkdir -p /root/myfiles
cat > /usr/local/bin/myfind <<'SCRIPT'
#!/bin/sh
find /usr/share/ -type f -size +400k -size -800k -exec cp -prvf {} /root/myfiles/ \;
SCRIPT
chmod a+x /usr/local/bin/myfind
/usr/local/bin/myfind
ls /root/myfiles
```
