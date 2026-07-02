#!/usr/bin/env bash
  groupadd -f sysmgrs
  useradd -G sysmgrs natasha 2>/dev/null; useradd -G sysmgrs harry 2>/dev/null
  useradd -s /sbin/nologin sarah 2>/dev/null
  for u in natasha harry sarah; do echo flectrags | passwd --stdin "$u" >/dev/null 2>&1; done
