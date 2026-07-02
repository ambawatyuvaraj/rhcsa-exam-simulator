#!/usr/bin/env bash
# Resize the database LV (created by e3-lvm) to 500 MiB, growing the fs too.
lvresize -L 500M -r /dev/datastore/database >/dev/null 2>&1 || \
  lvextend -r -L 500M /dev/datastore/database >/dev/null 2>&1
