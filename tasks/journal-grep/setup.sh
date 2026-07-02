#!/usr/bin/env bash
rm -f "/root/$OUT"
# Ensure the journal has at least one line containing the target string.
case "$STR" in
  chronyd) systemctl restart chronyd >/dev/null 2>&1 || true ;;
esac
logger "rhcsa journal-grep seed line mentioning $STR"
echo "journal-grep: ensured the journal has '$STR' lines and removed any prior /root/$OUT"
exit 0
