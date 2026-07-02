#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "BaseOS repo is enabled in dnf"          2 'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx BaseOS'
ckpt_expr "BaseOS baseurl points to local repo"    2 'grep -rhA10 "^\[BaseOS\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -q "file:///opt/rhcsa-repo/BaseOS"'
ckpt_expr "gpgcheck disabled for BaseOS"           2 'grep -rhA10 "^\[BaseOS\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0"'
ckpt_expr "AppStream repo is enabled in dnf"       2 'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx AppStream'
ckpt_expr "AppStream baseurl points to local repo" 2 'grep -rhA10 "^\[AppStream\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -q "file:///opt/rhcsa-repo/AppStream"'
ckpt_expr "gpgcheck disabled for AppStream"        2 'grep -rhA10 "^\[AppStream\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0"'
