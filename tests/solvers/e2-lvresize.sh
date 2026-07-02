#!/usr/bin/env bash
# Extend vo (seeded at 200M by setup) to 300M, growing the filesystem too.
lvextend -rL 300M /dev/myvol/vo >/dev/null 2>&1 || lvresize -rL 300M /dev/myvol/vo >/dev/null 2>&1
