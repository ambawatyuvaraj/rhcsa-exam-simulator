#!/usr/bin/env bash
umask 022   # so the student's createrepo/httpd serve without a 403 (dir must be world-traversable)
dnf -y install httpd createrepo_c dnf-plugins-core >/dev/null 2>&1 || true
mkdir -p /var/www/html/pkgrepo
if ! ls /var/www/html/pkgrepo/*.rpm >/dev/null 2>&1; then
  for mp in /mnt/dvd /run/media/*/* /mnt/cdrom; do
    [ -d "$mp/BaseOS" ] || [ -d "$mp/AppStream" ] || continue
    find "$mp"/AppStream "$mp"/BaseOS \( -name 'tree-*.rpm' -o -name 'wget-*.rpm' -o -name 'zsh-*.rpm' -o -name 'sl-*.rpm' \) 2>/dev/null | head -3 | xargs -rI{} cp {} /var/www/html/pkgrepo/ 2>/dev/null
    break
  done
  ls /var/www/html/pkgrepo/*.rpm >/dev/null 2>&1 || dnf download --destdir=/var/www/html/pkgrepo --resolve tree wget zsh >/dev/null 2>&1 || true
fi
echo "repo-server: httpd + createrepo_c installed, /var/www/html/pkgrepo created with rpms (not yet served)"
exit 0
