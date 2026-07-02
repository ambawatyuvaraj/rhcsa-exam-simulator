ps -eo comm --sort=-%cpu --no-headers | head -1 | tr -d ' ' > "/root/$OUT"
