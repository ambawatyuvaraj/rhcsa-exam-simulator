systemctl enable "$SVC"
systemctl stop "$SVC" >/dev/null 2>&1 || true
