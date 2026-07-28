#!/usr/bin/env bash
# lib/params.sh — opt-in per-session parameterisation so tasks randomise their
# concrete values (users, sizes, ports, paths, …) each run and can't be memorised.
#
# A task opts in by shipping a `params.sh` that prints KEY=VALUE lines to stdout
# (using the rand_* generators below). At `start`, the dispatcher runs it once
# and persists the result to $RHCSA_STATE/params/<task>.env. That env file is
# then sourced into the task's setup.sh / grade.sh / teardown.sh, and {{KEY}}
# placeholders in prompt.txt are substituted for display.
#
# Tasks WITHOUT a params.sh are unaffected (the existing 22 behave identically).

: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
RHCSA_PARAMS_DIR="$RHCSA_STATE/params"
RHCSA_PROMPTS_DIR="$RHCSA_STATE/prompts"
RHCSA_HINTS_DIR="$RHCSA_STATE/hints"          # practice aids: per-task hints
RHCSA_SOLUTIONS_DIR="$RHCSA_STATE/solutions"  # practice aids: rendered solutions

# ---- random generators (safe to embed in KEY=VALUE; no spaces/specials) ----
rand_int() {            # rand_int MIN MAX  (inclusive)
  local min="$1" max="$2" span=$(( $2 - $1 + 1 ))
  echo $(( min + (RANDOM % span) ))
}
rand_choice() {         # rand_choice a b c ...  -> one of the args
  local n=$#; echo "${@:$(( (RANDOM % n) + 1 )):1}"
}
rand_user() {           # a plausible, unused-ish username
  local names=(alice bob carol dave erin frank grace heidi ivan judy mallory \
               niaj olivia peggy rupert sybil trent victor walter yara zoe \
               natasha harry sarah manalo jacques operator) \
        n; n="$(rand_choice "${names[@]}")"
  echo "${n}$(rand_int 1 99)"
}
rand_group() {
  local g=(developers managers sysmgrs operators engineers analysts admins \
           dbteam webteam qa research support); echo "$(rand_choice "${g[@]}")"
}
rand_password() {       # 10-char alnum
  tr -dc 'A-Za-z0-9' </dev/urandom 2>/dev/null | head -c 10 || echo "Pass$(rand_int 1000 9999)x"
}
rand_port() {           # an uncommon high port not already labelled by SELinux
  echo "$(rand_choice 82 808 1234 3000 5000 5001 6080 7000 8008 8200 9000 9090 9100)"
}
rand_size_mib() {       # rand from a set, in MiB
  echo "$(rand_choice 256 300 384 400 450 500 512 600 640 768)"
}
rand_profile() { echo "$(rand_choice virtual-guest balanced powersave throughput-performance)"; }

# ---- engine -----------------------------------------------------------------
# Generate (once) and persist a task's params. Idempotent within a session.
gen_task_params() {     # gen_task_params <task-id> <task-dir>
  local id="$1" dir="$2" out="$RHCSA_PARAMS_DIR/$1.env"
  mkdir -p "$RHCSA_PARAMS_DIR"
  [[ -f "$out" ]] && return 0                 # already generated this session
  [[ -f "$dir/params.sh" ]] || return 0       # task isn't parameterised
  RHCSA_LIB="${RHCSA_LIB:-$(dirname "${BASH_SOURCE[0]}")}" \
    bash "$dir/params.sh" >"$out" 2>/dev/null || : >"$out"
  # Make "name-like" values unique per task (append a short per-task token) so
  # several tasks in one exam never collide on a mountpoint/VG/LV/dir/label.
  # Only identifier params the candidate *creates* are touched; service names,
  # packages, profiles, sizes, etc. are left exactly as generated.
  local tok; tok="$(printf '%s' "$id" | cksum | cut -d' ' -f1)"; tok="x${tok: -4}"
  local k
  for k in MP VG LV SRC DIR LBL SNAP NEW OLD NEWNAME OLDNAME PNAME ISO VGNAME LVNAME GRP; do
    sed -i -E "s|^($k)=([A-Za-z0-9_./-]+)\$|\1=\2$tok|" "$out" 2>/dev/null
  done
}

# Source a task's params into the current shell (no-op if none).
load_task_params() {    # load_task_params <task-id>
  local f="$RHCSA_PARAMS_DIR/$1.env"
  if [[ -f "$f" ]]; then set -a; . "$f"; set +a; fi
}

# Render prompt.txt with {{KEY}} substituted from the task's params; persist a
# rendered copy for the TUI/report. Falls back to the raw prompt if no params.
render_prompt() {       # render_prompt <task-id> <task-dir>
  local id="$1" dir="$2"
  local pf="$RHCSA_PARAMS_DIR/$id.env" src="$dir/prompt.txt" out="$RHCSA_PROMPTS_DIR/$id.txt"
  # A task whose wording differs per RHEL release ships prompt.rhel<N>.txt beside
  # prompt.txt; the versioned file wins when present (see also render_solution).
  [[ -f "$dir/prompt.rhel${RHCSA_RHEL}.txt" ]] && src="$dir/prompt.rhel${RHCSA_RHEL}.txt"
  mkdir -p "$RHCSA_PROMPTS_DIR"
  [[ -f "$src" ]] || return 0
  if [[ -f "$pf" ]]; then
    python3 - "$src" "$pf" >"$out" 2>/dev/null <<'PY' || cp "$src" "$out"
import re,sys
txt=open(sys.argv[1],encoding="utf-8",errors="replace").read()
params={}
for line in open(sys.argv[2],encoding="utf-8",errors="replace"):
    line=line.strip()
    if "=" in line and not line.startswith("#"):
        k,v=line.split("=",1); params[k]=v
sys.stdout.write(re.sub(r"\{\{(\w+)\}\}", lambda m: params.get(m.group(1), m.group(0)), txt))
PY
  else
    cp "$src" "$out"
  fi
}

# Render a task's reference solution with the session's ACTUAL values: both
# {{KEY}} (prompt convention) and <KEY> (solution convention) are substituted
# when KEY exists in the task's params. Go-template syntax like {{.Id}} /
# {{range .Mounts}} and generic <placeholders> are left untouched (no matching
# param key). Falls back to the raw solution.md when the task has no params.
render_solution() {     # render_solution <task-id> [outfile]
  local id="$1" dir; dir="$(task_dir "$id")"
  local out="${2:-$RHCSA_SOLUTIONS_DIR/$id.txt}"
  local pf="$RHCSA_PARAMS_DIR/$id.env" src="$dir/solution.md"
  # Teach the procedure that is correct for THIS OS: a task whose answer differs
  # between releases (e.g. podman generate systemd on 9 vs Quadlet on 10) ships
  # solution.rhel<N>.md, which wins over solution.md when running on that release.
  [[ -f "$dir/solution.rhel${RHCSA_RHEL}.md" ]] && src="$dir/solution.rhel${RHCSA_RHEL}.md"
  mkdir -p "$(dirname "$out")"
  [[ -f "$src" ]] || { echo "(no reference solution for $id)" >"$out"; return 0; }
  if [[ -f "$pf" ]]; then
    python3 - "$src" "$pf" >"$out" 2>/dev/null <<'PY' || cp "$src" "$out"
import re,sys
txt=open(sys.argv[1],encoding="utf-8",errors="replace").read()
params={}
for line in open(sys.argv[2],encoding="utf-8",errors="replace"):
    line=line.strip()
    if "=" in line and not line.startswith("#"):
        k,v=line.split("=",1); params[k]=v.strip().strip('"')
txt=re.sub(r"\{\{(\w+)\}\}",      lambda m: params.get(m.group(1), m.group(0)), txt)
txt=re.sub(r"<([A-Z][A-Z0-9_]*)>", lambda m: params.get(m.group(1), m.group(0)), txt)
sys.stdout.write(txt)
PY
  else
    cp "$src" "$out"
  fi
}

# Build a HINT for a task: a curated tasks/<id>/hint.txt wins (rendered with the
# session params); otherwise the hint is derived from the reference solution —
# the approach line, the step comments, and the COMMANDS involved — guidance
# without revealing the exact command lines.
render_hint() {         # render_hint <task-id> [outfile]
  local id="$1" dir; dir="$(task_dir "$id")"
  local out="${2:-$RHCSA_HINTS_DIR/$id.txt}"
  local pf="$RHCSA_PARAMS_DIR/$id.env"
  mkdir -p "$(dirname "$out")"
  if [[ -f "$dir/hint.txt" ]]; then
    if [[ -f "$pf" ]]; then
      python3 - "$dir/hint.txt" "$pf" >"$out" 2>/dev/null <<'PY' || cp "$dir/hint.txt" "$out"
import re,sys
txt=open(sys.argv[1],encoding="utf-8",errors="replace").read()
params={}
for line in open(sys.argv[2],encoding="utf-8",errors="replace"):
    line=line.strip()
    if "=" in line and not line.startswith("#"):
        k,v=line.split("=",1); params[k]=v.strip().strip('"')
sys.stdout.write(re.sub(r"\{\{(\w+)\}\}", lambda m: params.get(m.group(1), m.group(0)), txt))
PY
    else
      cp "$dir/hint.txt" "$out"
    fi
    return 0
  fi
  python3 - "$dir/solution.md" >"$out" 2>/dev/null <<'PY' || \
    printf 'Re-read the task, then explore with: man -k <topic>, <command> --help.\n' >"$out"
import os,re,sys
path=sys.argv[1]
if not os.path.isfile(path):
    print("Re-read the task, then explore with: man -k <topic>, <command> --help."); raise SystemExit
lines=open(path,encoding="utf-8",errors="replace").read().splitlines()
approach=""; steps=[]; tools=[]
in_fence=False; heredoc=None
STOP={"if","then","else","elif","fi","for","while","until","do","done","case","esac",
      "function","exit","return","set","cd","source",".","[","[[","test","true","false",
      "read","local","then;","EOF"}
for ln in lines:
    s=ln.strip()
    if not in_fence and s.startswith("# Reference solution"):
        approach=s.split("—",1)[-1].split("--",1)[-1].strip(" -#")
        continue
    if s.startswith("```"):
        in_fence=not in_fence; heredoc=None; continue
    if not in_fence or not s:
        continue
    if heredoc:                       # inside a heredoc body: skip until the terminator
        if s==heredoc: heredoc=None
        continue
    if s.startswith("#"):
        c=s.lstrip("#").strip()
        if c and len(steps)<6 and c not in steps: steps.append(c)
        continue
    m=re.search(r"<<-?\s*'?(\w+)'?",s)
    if m: heredoc=m.group(1)
    # harvest command names from each pipeline/sequence segment
    for seg in re.split(r"\||&&|\|\||;",s):
        toks=seg.strip().split()
        while toks and (toks[0] in ("sudo","env","timeout","nohup") or re.match(r"^[A-Za-z_][A-Za-z0-9_]*=",toks[0])
                        or (toks and toks[0]=="timeout" )):
            toks=toks[1:] if toks[0]!="timeout" else toks[2:]
        if not toks: continue
        c=toks[0]
        if re.match(r"^[a-zA-Z][\w.+-]*$",c) and c not in STOP and c not in tools:
            tools.append(c)
out=[]
if approach: out.append(f"Approach: {approach}")
if steps:
    out.append("Steps:")
    out += [f"  • {s}" for s in steps]
if tools:
    out.append("Commands you'll likely need: " + ", ".join(tools[:8]))
    manp=[t for t in tools if t not in ("echo","cat","printf","mkdir","cp","mv","rm","ls")][:3]
    if manp: out.append("Docs: " + "  ·  ".join(f"man {t}" for t in manp))
if not out:
    out=["Re-read the task, then explore with: man -k <topic>, <command> --help."]
out.append("")
out.append("(Still stuck?  rhcsa-sim solution TASK  shows the full reference answer.)")
print("\n".join(out))
PY
}
