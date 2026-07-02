#!/usr/bin/env bash
semanage fcontext -d "$DIR(/.*)?" 2>/dev/null
rm -rf $DIR
exit 0
