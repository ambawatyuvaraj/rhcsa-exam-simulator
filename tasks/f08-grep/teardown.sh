#!/usr/bin/env bash
rm -f /root/lines.txt 2>/dev/null
if [ -f /var/lib/rhcsa-sim/f08-grep.seeded ]; then
  rm -f /usr/share/dict/words /var/lib/rhcsa-sim/f08-grep.seeded 2>/dev/null
  rmdir /usr/share/dict 2>/dev/null
fi
exit 0
