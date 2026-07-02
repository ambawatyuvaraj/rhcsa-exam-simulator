ps -eo comm --sort=-%mem --no-headers | head -1 | tr -d ' ' > "/root/$OUT"
