#!/usr/bin/env bash
mkdir -p /root/myfiles
cat > /usr/local/bin/myfind <<'SCRIPT'
#!/bin/sh
find /usr/share/ -type f -size +400k -size -800k -exec cp -prvf {} /root/myfiles/ \;
SCRIPT
chmod a+x /usr/local/bin/myfind
/usr/local/bin/myfind
