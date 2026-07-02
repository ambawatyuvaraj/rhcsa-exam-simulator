#!/usr/bin/env bash
# Extend the database LV (created by e1-lvm) to 100 extents, growing the fs too.
lvresize -l 100 -r /dev/datastore/database >/dev/null 2>&1 || \
  lvextend -r -l 100 /dev/datastore/database >/dev/null 2>&1
