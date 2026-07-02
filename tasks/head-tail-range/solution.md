# Reference solution — extract a specific line range

```bash
sed -n '<A>,<B>p' /etc/services > /root/<OUT>
```

`sed -n` suppresses default printing; `<A>,<B>p` prints only the lines in that
range. Equivalently `head -n <B> /etc/services | tail -n +<A>`.
