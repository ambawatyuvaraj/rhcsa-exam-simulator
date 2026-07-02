#!/usr/bin/env bash
getent group sysmgrs >/dev/null 2>&1 || groupadd sysmgrs
id harry   >/dev/null 2>&1 || useradd -G sysmgrs harry
id natasha >/dev/null 2>&1 || useradd -G sysmgrs natasha
id sarah   >/dev/null 2>&1 || useradd -s /sbin/nologin sarah
usermod -s /sbin/nologin sarah        # ensure nologin even if sarah already existed (e.g. seeded by the find task)
usermod -aG sysmgrs harry
usermod -aG sysmgrs natasha
for u in harry natasha sarah; do echo flectrags | passwd --stdin "$u" >/dev/null 2>&1; done
