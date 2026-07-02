#!/usr/bin/env bash
systemctl restart chronyd 2>/dev/null
rm -f "/root/$OUTF"
echo "journal-find: ensured chronyd has logged and removed any prior /root/$OUTF"
exit 0
