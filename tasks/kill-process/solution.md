# Reference solution — find and kill a runaway process

Locate the process by a string in its command line, then terminate it. `pkill -f`
matches the full command line; escalate to `kill -9` only if it ignores SIGTERM.

```bash
pgrep -af <MARK>        # find the process + its PID
pkill -f <MARK>         # terminate it by command-line match
pgrep -f <MARK>         # verify: no output means it is gone
```
