#!/usr/bin/env bash
mkdir -p /usr/share/rhcsa
cat >/usr/share/rhcsa/wordlist <<WL
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
rm -f /root/lines.txt
echo "grep-string: seeded /usr/share/rhcsa/wordlist"
exit 0
