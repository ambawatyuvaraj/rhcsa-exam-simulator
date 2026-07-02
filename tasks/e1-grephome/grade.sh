#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/search.txt exists"                     2 path_exists /root/search.txt
# Compare by user:home:shell (cut -f1,6,7), not byte-for-byte: a later task
# (create-user-with-UID) legitimately changes alies's UID field AFTER this file
# is captured, which would otherwise break an exact diff.
#
# Order-independence: the candidate may run this grep BEFORE or AFTER the user-
# creation tasks. Since the exam only ADDS users during the session, a correct
# capture is always a subset of the current 'home' lines, missing at most the
# accounts added later. So accept the file when:
#   (a) it matches the current grep exactly, OR
#   (b) every line it contains is still a real current 'home' line (nothing
#       fabricated/stale), AND it contains every 'home' line that existed at
#       seed time (the baseline) -- i.e.  baseline subset-of search.txt subset-of current.
# The seed-time baseline (default users only) is the lower bound; exam-added
# users may be absent. Falls back to an exact match if no baseline was recorded.
ckpt_expr "contents match grep home /etc/passwd"   8 '
  f=/root/search.txt; [ -s "$f" ] || exit 1;
  cur="$(grep home /etc/passwd | cut -d: -f1,6 | sort -u)";
  got="$(cut -d: -f1,6 "$f" 2>/dev/null | sort -u)";
  [ "$cur" = "$got" ] && exit 0;
  base=/var/lib/rhcsa-sim/state/grephome.baseline;
  [ -s "$base" ] || exit 1;
  bl="$(sort -u "$base")";
  [ -z "$(comm -23 <(printf "%s\n" "$got") <(printf "%s\n" "$cur"))" ] || exit 1;
  [ -z "$(comm -23 <(printf "%s\n" "$bl")  <(printf "%s\n" "$got"))" ] || exit 1;
  exit 0'
