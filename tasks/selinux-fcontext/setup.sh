#!/usr/bin/env bash
mkdir -p $DIR
echo "<h1>x</h1>" > $DIR/index.html
semanage fcontext -d "$DIR(/.*)?" 2>/dev/null
restorecon -R $DIR 2>/dev/null
echo "selinux-fcontext: seeded $DIR"
exit 0
