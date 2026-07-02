#!/usr/bin/env bash
if [ -f /etc/locale.conf.rhcsabak ]; then
  mv -f /etc/locale.conf.rhcsabak /etc/locale.conf 2>/dev/null
else
  localectl set-locale LANG=en_US.UTF-8 >/dev/null 2>&1
fi
# /etc/locale.conf MUST stay world-readable — /etc/profile.d/lang.sh reads it at every
# login; a 600 file makes every new shell print "sed: can't read /etc/locale.conf".
[ -e /etc/locale.conf ] && chmod 0644 /etc/locale.conf 2>/dev/null
exit 0
