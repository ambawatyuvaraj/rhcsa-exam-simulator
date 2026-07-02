# Reference solution — count occurrences of duplicate lines

```bash
sort /opt/dups.txt | uniq -c > /root/<OUT>
```

`uniq -c` collapses adjacent equal lines and prefixes each with a count, so the
input must be sorted first.
