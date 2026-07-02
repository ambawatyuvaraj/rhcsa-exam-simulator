#!/usr/bin/env bash
# Solver for e1-repo: write /etc/yum.repos.d/app.repo with the working LOCAL
# (offline) baseurls. Section names + name=/gpgcheck=/enabled= stay faithful to
# the published answer key; only the baseurls are localized to file:///opt/...
cat >/etc/yum.repos.d/app.repo <<'EOF'
[BaseOS]
name=base
baseurl=file:///opt/rhcsa-repo/BaseOS
gpgcheck=0
enabled=1

[AppStream]
name=app
baseurl=file:///opt/rhcsa-repo/AppStream
gpgcheck=0
enabled=1
EOF
dnf -q clean all >/dev/null 2>&1
