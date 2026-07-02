#!/usr/bin/env bash
# Create a local dnf repo file pointing at file://$DIR, enabled.
cat >"/etc/yum.repos.d/$RID.repo" <<EOF
[$RID]
name=$RID
baseurl=file://$DIR
enabled=1
gpgcheck=0
EOF
dnf -q clean all >/dev/null 2>&1
true
