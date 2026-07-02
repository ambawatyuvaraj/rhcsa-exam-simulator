# Reference solution — start a process with a nice value

The "nice" value (-20..19) sets scheduling priority — higher nice = lower priority.
`nice -n <NICE>` launches a command at that priority; the `exec -a <MARK>` tag just
makes the process easy to find afterwards.

```bash
nice -n <NICE> bash -c 'exec -a <MARK> sleep 7000' &
pid=$(pgrep -f <MARK> | head -1)
ps -o pid,ni,cmd -p "$pid"      # verify the NI column = <NICE>
```
