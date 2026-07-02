# Reference solution — renice a running process

`renice` changes the nice value of an ALREADY-running process by PID (root may lower
or raise it; regular users may only raise it = lower priority).

```bash
pid=$(pgrep -f <MARK> | head -1)   # find the running process
renice -n <NICE> -p "$pid"         # set its new nice value
ps -o pid,ni,comm -p "$pid"        # verify the NI column = <NICE>
```
