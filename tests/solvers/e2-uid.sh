#!/usr/bin/env bash
# Force UID 3533 even if manalo was pre-created (e.g. by the env-var task) with a
# different UID — a plain useradd would just fail and leave the wrong UID.
if id manalo >/dev/null 2>&1; then
  usermod -u 3533 manalo 2>/dev/null; chown -R 3533 /home/manalo 2>/dev/null
else
  useradd -u 3533 manalo
fi
echo flectrag | passwd --stdin manalo >/dev/null 2>&1
