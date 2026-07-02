#!/usr/bin/env bash
rm -rf /common/shared 2>/dev/null
rmdir /common 2>/dev/null   # remove parent only if now empty
exit 0
