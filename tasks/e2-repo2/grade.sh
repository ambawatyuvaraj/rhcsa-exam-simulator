#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# rhcsa.repo present at the faithful path.
ckpt_expr "rhcsa.repo exists" 2 \
  'test -f /etc/yum.repos.d/rhcsa.repo'

# [BaseOS]: enabled, gpgcheck=0, working local baseurl, and usable by dnf.
ckpt_expr "BaseOS enabled, gpgcheck=0, working baseurl, usable" 4 \
  'sec=$(awk "/^\[BaseOS\]/{f=1;next} /^\[/{f=0} f" /etc/yum.repos.d/rhcsa.repo 2>/dev/null);
   printf "%s\n" "$sec" | grep -q "file:///opt/rhcsa-repo/BaseOS" &&
   printf "%s\n" "$sec" | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0" &&
   printf "%s\n" "$sec" | grep -qiE "enabled[[:space:]]*=[[:space:]]*1" &&
   dnf -q --disablerepo="*" --enablerepo=BaseOS repolist 2>/dev/null | awk "{print \$1}" | grep -qix BaseOS'

# [AppStream]: enabled, gpgcheck=0, working local baseurl, and usable by dnf.
ckpt_expr "AppStream enabled, gpgcheck=0, working baseurl, usable" 4 \
  'sec=$(awk "/^\[AppStream\]/{f=1;next} /^\[/{f=0} f" /etc/yum.repos.d/rhcsa.repo 2>/dev/null);
   printf "%s\n" "$sec" | grep -q "file:///opt/rhcsa-repo/AppStream" &&
   printf "%s\n" "$sec" | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0" &&
   printf "%s\n" "$sec" | grep -qiE "enabled[[:space:]]*=[[:space:]]*1" &&
   dnf -q --disablerepo="*" --enablerepo=BaseOS,AppStream repolist 2>/dev/null | grep -qi appstream'
