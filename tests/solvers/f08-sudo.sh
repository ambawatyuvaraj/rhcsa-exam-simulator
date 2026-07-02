#!/usr/bin/env bash
groupadd -f admin
grep -qE '^%admin[[:space:]]' /etc/sudoers /etc/sudoers.d/* 2>/dev/null || echo "%admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
