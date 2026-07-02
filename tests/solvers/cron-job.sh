#!/usr/bin/env bash
crontab -u operator - <<EOF
*/3 * * * * /usr/bin/logger "EX200 Testing"
EOF
