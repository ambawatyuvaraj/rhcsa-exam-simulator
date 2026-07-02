#!/usr/bin/env bash
dnf -y install createrepo_c dnf-plugins-core >/dev/null 2>&1 || true
mkdir -p "$DIR"
# Put a couple of REAL rpms in the dir so the configured repo actually serves
# installable packages (you can `dnf install` from it), not just empty metadata.
if ! ls "$DIR"/*.rpm >/dev/null 2>&1; then
  # OFFLINE-FIRST (like the real exam): copy rpms from the local install DVD.
  for mp in /mnt/dvd /run/media/*/* /mnt/cdrom; do
    [ -d "$mp/BaseOS" ] || [ -d "$mp/AppStream" ] || continue
    find "$mp"/AppStream "$mp"/BaseOS \( -name 'tree-*.rpm' -o -name 'wget-*.rpm' \) 2>/dev/null | head -2 | xargs -rI{} cp {} "$DIR"/ 2>/dev/null
    break
  done
  ls "$DIR"/*.rpm >/dev/null 2>&1 || dnf download --destdir="$DIR" tree wget >/dev/null 2>&1 || true
  ls "$DIR"/*.rpm >/dev/null 2>&1 || \
    find /var/cache/dnf -name '*.rpm' 2>/dev/null | head -3 | xargs -rI{} cp -n {} "$DIR"/ 2>/dev/null
fi
createrepo_c "$DIR" >/dev/null 2>&1 || true
rm -f /etc/yum.repos.d/$RID.repo
echo "repo-add: repo dir '$DIR' ready with $(ls "$DIR"/*.rpm 2>/dev/null | wc -l) rpms, no repo file yet"
exit 0
