#!/usr/bin/env bash
# Force UID 1326 even if alies was pre-created (e.g. by the env-var task) with a
# different UID — a plain useradd would just fail and leave the wrong UID.
if id alies >/dev/null 2>&1; then
  usermod -u 1326 alies 2>/dev/null; chown -R 1326 /home/alies 2>/dev/null
else
  useradd -u 1326 alies
fi
echo 123 | passwd --stdin alies >/dev/null 2>&1
