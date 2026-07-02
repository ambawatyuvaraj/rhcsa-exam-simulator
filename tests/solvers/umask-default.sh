#!/usr/bin/env bash
# Set a per-user default umask in the user's login startup files.
home="$(getent passwd "$U" | cut -d: -f6)"
[ -n "$home" ] || home="/home/$U"
mkdir -p "$home"

# Ensure both ~/.bashrc and ~/.bash_profile carry the umask, and that the
# login shell (which reads ~/.bash_profile) actually picks it up.
add_umask() {
  local f="$1"
  touch "$f"
  grep -qxF "umask $UM" "$f" || echo "umask $UM" >>"$f"
}
add_umask "$home/.bashrc"
add_umask "$home/.bash_profile"

# Make sure .bash_profile sources .bashrc (default RHEL skel does this).
grep -q '\.bashrc' "$home/.bash_profile" 2>/dev/null || cat >>"$home/.bash_profile" <<'EOF'
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
EOF

chown -R "$U":"$U" "$home/.bashrc" "$home/.bash_profile" 2>/dev/null || true
restorecon -RF "$home/.bashrc" "$home/.bash_profile" 2>/dev/null || true
