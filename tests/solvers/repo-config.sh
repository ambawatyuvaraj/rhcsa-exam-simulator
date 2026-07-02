#!/usr/bin/env bash
  cat >/etc/yum.repos.d/rhcsa.repo <<'EOF'
[BaseOS]
name=BaseOS
baseurl=file:///opt/rhcsa-repo/BaseOS
enabled=1
gpgcheck=0

[AppStream]
name=AppStream
baseurl=file:///opt/rhcsa-repo/AppStream
enabled=1
gpgcheck=0
EOF
  dnf -q clean all >/dev/null 2>&1
