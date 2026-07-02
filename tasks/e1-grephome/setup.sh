#!/usr/bin/env bash
rm -f /root/search.txt
# Snapshot the /etc/passwd 'home' lines that exist NOW — at seed time, before the
# candidate creates any of the exam's users (harry/natasha/alies/walhalla/...).
# The grade uses this as a lower bound: the captured file must contain every
# seed-time 'home' line, and may be MISSING only accounts added later by other
# tasks. That makes this grep task order-independent — doing it before OR after
# the user-creation tasks both grade correctly (previously, grepping before a
# user was added left the file permanently short one line and scored 0 on the
# reboot-grade). Stored under /var/lib (persistent) so it survives the reboot.
mkdir -p /var/lib/rhcsa-sim/state
grep home /etc/passwd | cut -d: -f1,6 | sort -u > /var/lib/rhcsa-sim/state/grephome.baseline 2>/dev/null
echo "e1-grephome: ready (grep 'home' from /etc/passwd)"
exit 0
