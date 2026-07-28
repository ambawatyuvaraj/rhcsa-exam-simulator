#!/usr/bin/env bash
# tests/version_test.sh — self-check for the RHEL 9 / RHEL 10 version mechanism.
# Runs anywhere (no VM, no root): builds a throwaway task tree in /tmp and asserts
# the detection, the TASK_RHEL filter and the solution.rhel<N>.md override.
#   bash tests/version_test.sh
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
fails=0
ck(){ if [[ "$2" == "$3" ]]; then echo "  ok   $1"; else echo "  FAIL $1: expected '$3', got '$2'"; fails=$((fails+1)); fi; }

mkdir -p "$T/tasks/plain" "$T/tasks/only9" "$T/tasks/only10" "$T/tasks/both" "$T/lib" "$T/state"
cp "$HERE/lib/common.sh" "$HERE/lib/params.sh" "$T/lib/"
echo 'TASK_TITLE="p"; TASK_DOMAIN=tools; TASK_POINTS=1'                    >"$T/tasks/plain/meta.sh"
echo 'TASK_TITLE="a"; TASK_DOMAIN=tools; TASK_POINTS=1; TASK_RHEL="9"'     >"$T/tasks/only9/meta.sh"
echo 'TASK_TITLE="b"; TASK_DOMAIN=tools; TASK_POINTS=1; TASK_RHEL="10"'    >"$T/tasks/only10/meta.sh"
echo 'TASK_TITLE="c"; TASK_DOMAIN=tools; TASK_POINTS=1; TASK_RHEL="9 10"'  >"$T/tasks/both/meta.sh"
printf 'nine\n'   >"$T/tasks/plain/solution.md"
printf 'ten\n'    >"$T/tasks/plain/solution.rhel10.md"

vis(){ RHCSA_RHEL="$1" RHCSA_HOME="$T" RHCSA_STATE="$T/state" bash -c '. '"$T"'/lib/common.sh 2>/dev/null; all_tasks | tr "\n" " "'; }
sol(){ RHCSA_RHEL="$1" RHCSA_HOME="$T" RHCSA_STATE="$T/state" bash -c '
  . '"$T"'/lib/common.sh 2>/dev/null; . '"$T"'/lib/params.sh 2>/dev/null
  RHCSA_SOLUTIONS_DIR='"$T"'/sol; render_solution plain >/dev/null 2>&1; cat '"$T"'/sol/plain.txt 2>/dev/null'; }

echo "== detection =="
ck "explicit override honoured" "$(RHCSA_RHEL=10 bash -c '. '"$T"'/lib/common.sh 2>/dev/null; echo $RHCSA_RHEL')" "10"
ck "non-RHEL host falls back to 9" \
   "$(RHCSA_RHEL= bash -c 'unset RHCSA_RHEL; . '"$T"'/lib/common.sh 2>/dev/null; echo $RHCSA_RHEL')" \
   "$( . /etc/os-release 2>/dev/null; case "${VERSION_ID%%.*}" in 10) echo 10;; *) echo 9;; esac)"

echo "== TASK_RHEL filter (untagged must stay visible on BOTH: protects the existing set) =="
v9="$(vis 9)"; v10="$(vis 10)"
ck "untagged visible on 9"   "$([[ " $v9 "  == *" plain "*  ]] && echo y || echo n)" "y"
ck "untagged visible on 10"  "$([[ " $v10 " == *" plain "*  ]] && echo y || echo n)" "y"
ck "9-only hidden on 10"     "$([[ " $v10 " == *" only9 "*  ]] && echo y || echo n)" "n"
ck "9-only visible on 9"     "$([[ " $v9 "  == *" only9 "*  ]] && echo y || echo n)" "y"
ck "10-only hidden on 9"     "$([[ " $v9 "  == *" only10 "* ]] && echo y || echo n)" "n"
ck "10-only visible on 10"   "$([[ " $v10 " == *" only10 "* ]] && echo y || echo n)" "y"
ck "multi-version on 9"      "$([[ " $v9 "  == *" both "*   ]] && echo y || echo n)" "y"
ck "multi-version on 10"     "$([[ " $v10 " == *" both "*   ]] && echo y || echo n)" "y"

echo "== solution.rhel<N>.md override =="
ck "plain solution on 9"        "$(sol 9  | tr -d '[:space:]')" "nine"
ck "versioned solution on 10"   "$(sol 10 | tr -d '[:space:]')" "ten"

echo "== exam-paper release gating =="
printf '# RHCSA_RHEL: 10\nselinux-port\n'    >"$T/exams10.list"
printf '# RHCSA_RHEL: 9 10\nselinux-port\n' >"$T/examboth.list"
printf 'selinux-port\n'                     >"$T/examany.list"
mkdir -p "$T/exams"; cp "$T"/exams10.list "$T"/exams/only10.list
cp "$T"/examboth.list "$T"/exams/both.list; cp "$T"/examany.list "$T"/exams/any.list
egate(){ RHCSA_RHEL="$1" RHCSA_HOME="$T" RHCSA_STATE="$T/state" bash -c '. '"$T"'/lib/common.sh 2>/dev/null; exam_rhel_ok '"$2"' && echo y || echo n'; }
ck "undeclared paper valid on 9"    "$(egate 9  any)"    "y"
ck "undeclared paper valid on 10"   "$(egate 10 any)"    "y"
ck "10-only paper hidden on 9"      "$(egate 9  only10)" "n"
ck "10-only paper visible on 10"    "$(egate 10 only10)" "y"
ck "multi-release paper on 9"       "$(egate 9  both)"   "y"
ck "multi-release paper on 10"      "$(egate 10 both)"   "y"

echo "== category availability (empty domains must not be offered) =="
echo 'TASK_TITLE="c"; TASK_DOMAIN=containers; TASK_POINTS=1; TASK_RHEL="9"' >"$T/tasks/only9/meta.sh"
cats(){ RHCSA_RHEL="$1" RHCSA_HOME="$T" RHCSA_STATE="$T/state" bash -c '. '"$T"'/lib/common.sh 2>/dev/null; available_categories'; }
ck "domain with a 9-only task is offered on 9"      "$([[ " $(cats 9)  " == *" containers "* ]] && echo y || echo n)" "y"
ck "domain empty on 10 is not offered on 10"        "$([[ " $(cats 10) " == *" containers "* ]] && echo y || echo n)" "n"

echo "== live repo invariants =="
REPO="$HERE"
inv(){ RHCSA_RHEL="$1" RHCSA_HOME="$REPO" RHCSA_STATE="$T/state" bash -c '. '"$REPO"'/lib/common.sh 2>/dev/null; all_tasks'; }
n9="$(inv 9 | wc -l)"; n10="$(inv 10 | wc -l)"; ndirs="$(find "$REPO/tasks" -mindepth 1 -maxdepth 1 -type d | wc -l)"
# Every task must be reachable on at least one release: a typo'd tag (TASK_RHEL="11")
# would silently hide a task from BOTH exams, which no other check would catch.
union="$( { inv 9; inv 10; } | sort -u | wc -l )"
orphans="$( { inv 9; inv 10; } | sort -u | comm -13 - <(find "$REPO/tasks" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort) )"
ck "no task is hidden on every release" "$(printf '%s' "$orphans" | tr -d '[:space:]' | head -c 20)" ""
ck "v9+v10 together see every task dir"  "$union" "$ndirs"
ck "v10 has fewer tasks than v9 (containers/collab/mbr benched)" "$([[ $n10 -lt $n9 ]] && echo y || echo n)" "y"
ck "no containers task on 10"           "$(inv 10 | while read -r t; do grep -ql 'TASK_DOMAIN="containers"' "$REPO/tasks/$t/meta.sh" 2>/dev/null && echo x; done | head -c 1)" ""
# Every task id referenced by every paper must resolve, on both releases.
bad=""; for f in "$REPO"/exams/*.list; do
  # Strip trailing "# Qn ..." annotations before reading fields, else the id
  # swallows the rest of the line. Two-node papers prefix the id with the node.
  while read -r id; do
    [[ -z "$id" ]] && continue
    [[ -f "$REPO/tasks/$id/meta.sh" ]] || bad="$bad $(basename "$f"):$id"
  done < <(sed 's/#.*//' "$f" | awk 'NF{ print ($1=="node1"||$1=="node2") ? $2 : $1 }')
done
ck "every exam paper's task ids resolve" "$(printf '%s' "$bad" | head -c 40)" ""

echo
if [[ $fails -eq 0 ]]; then echo "version_test: ALL PASS"; else echo "version_test: $fails FAILURE(S)"; fi
exit $(( fails > 0 ))
