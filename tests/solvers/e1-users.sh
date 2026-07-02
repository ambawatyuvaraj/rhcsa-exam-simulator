#!/usr/bin/env bash
getent group admin >/dev/null 2>&1 || groupadd admin
id harry   >/dev/null 2>&1 || useradd -G admin harry
id natasha >/dev/null 2>&1 || useradd -G admin natasha
id sarah   >/dev/null 2>&1 || useradd -s /sbin/nologin sarah
usermod -s /sbin/nologin sarah        # ensure nologin even if sarah already existed (e.g. seeded by the find task)
usermod -aG admin harry
usermod -aG admin natasha
for u in harry natasha sarah; do echo 123 | passwd --stdin "$u" >/dev/null 2>&1; done
