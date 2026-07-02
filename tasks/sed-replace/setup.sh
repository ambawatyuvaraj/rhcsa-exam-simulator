#!/usr/bin/env bash
# Seed text containing the (parameterised) OLD word several times, including two
# on one line, plus a distractor line. Built from $OLD so the content always
# matches regardless of the per-exam uniqueness suffix the param engine adds to
# OLD/NEW (a literal word here would not match the suffixed $OLD).
cat >/opt/sedsrc.txt <<EOF
The $OLD server runs the $OLD workload.
$OLD mirrors $OLD closely for $OLD tests.
We retire the $OLD box; $OLD data moves off $OLD disks.
No keyword on this line.
$OLD and more $OLD together on one line.
EOF
rm -f "/root/$OUT"
echo "sed-replace: seeded /opt/sedsrc.txt ($OLD -> $NEW into /root/$OUT)"
exit 0
