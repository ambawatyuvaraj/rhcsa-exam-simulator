# Reference solution — find the top CPU process

Identify the process using the most CPU. `ps` sorted by %CPU descending puts the
busiest process first; take that row's command name and save it. (`top` shows the
same thing interactively.)

```bash
# Sort all processes by %CPU (descending); the first data row is the busiest:
ps -eo comm --sort=-%cpu --no-headers | head -1 | tr -d " " > /root/<OUT>
cat /root/<OUT>
```
