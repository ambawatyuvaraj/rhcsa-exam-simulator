#!/usr/bin/env bash
dnf install -y words >/dev/null 2>&1 || true
mkdir -p /usr/share/dict
if [ ! -f /usr/share/dict/words ] || ! grep -q strato /usr/share/dict/words 2>/dev/null; then
  cat > /usr/share/dict/words <<'WL'
atmosphere
stratosphere
stratus
cumulus
substrate
stratovolcano
nimbostratus
mountain
demonstrator
stratify
ocean
WL
  mkdir -p /var/lib/rhcsa-sim; touch /var/lib/rhcsa-sim/f08-grep.seeded
fi
rm -f /root/lines.txt
echo "f08-grep: ready (/usr/share/dict/words has strato matches)"
exit 0
