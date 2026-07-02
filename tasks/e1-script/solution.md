# Reference solution — find-and-copy small files script

`find /usr/share -type f -size -1M` matches every regular file smaller than 1
MiB; `-exec cp ... {} /root/myfiles/ \;` copies each match into the destination
(which must exist). Make the script executable, then run it.

```bash
mkdir -p /root/myfiles
cat > /usr/local/bin/mysearch <<'EOF'
#!/bin/sh
find /usr/share/ -type f -size -1M -exec cp -prvf {} /root/myfiles/ \;
EOF
chmod a+x /usr/local/bin/mysearch
/usr/local/bin/mysearch
ls /root/myfiles
```
