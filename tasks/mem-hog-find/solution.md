# Reference solution — find the top memory process

Identify the process using the most memory: `ps` sorted by %MEM descending puts the
largest first; save that row's command name.

```bash
ps -eo comm --sort=-%mem --no-headers | head -1 | tr -d " " > /root/<OUT>
cat /root/<OUT>
```
