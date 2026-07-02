# Reference solution — numerically sort a data file

```bash
sort -n /opt/nums.txt > /root/<OUT>
```

`sort -n` compares lines by numeric value, so `9` sorts before `100` (unlike the
default lexical sort).
