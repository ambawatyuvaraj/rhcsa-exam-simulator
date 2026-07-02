dnf group install -y "$GROUPNAME" >/dev/null 2>&1 || dnf install -y "$MEMBER" >/dev/null 2>&1
