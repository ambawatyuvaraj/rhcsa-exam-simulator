# Reference solution — write the non-matching lines

```bash
grep -v '<PAT>' /opt/invsrc.log > /root/<OUT>
```

`grep -v` inverts the match, printing only lines that do not contain the pattern.
