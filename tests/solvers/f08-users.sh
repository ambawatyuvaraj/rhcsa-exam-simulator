#!/usr/bin/env bash
getent group manager >/dev/null 2>&1 || groupadd manager
id harry   >/dev/null 2>&1 || useradd harry
id natasha >/dev/null 2>&1 || useradd natasha
id sarah   >/dev/null 2>&1 || useradd -s /sbin/nologin sarah
for u in harry natasha sarah; do echo ratencot | passwd --stdin "$u" >/dev/null 2>&1; done
usermod -aG manager harry; usermod -aG manager natasha
