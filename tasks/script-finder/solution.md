# Reference solution — SUID finder script

```bash
cat >/usr/local/bin/mysearch <<'EOF'
#!/bin/bash
find /usr -size +5k -size -50k -perm -4000 > /root/setuid.list
EOF
chmod +x /usr/local/bin/mysearch
mysearch
cat /root/setuid.list
```
`-perm -4000` matches the SUID bit; `-size +5k -size -50k` bounds the size.
