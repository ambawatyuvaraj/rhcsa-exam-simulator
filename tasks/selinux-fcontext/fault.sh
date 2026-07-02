#!/usr/bin/env bash
# Troubleshooting fault: drop the fcontext rule and mislabel the files under $DIR.
semanage fcontext -d "$DIR(/.*)?" >/dev/null 2>&1
chcon -R -t var_t "$DIR" >/dev/null 2>&1 || chcon -R -t default_t "$DIR" >/dev/null 2>&1
echo "SYMPTOM: files under $DIR have the wrong SELinux type and there is no persistent fcontext rule (a web server would return 403 Permission denied)"
