# Reference solution — filter lines with an extended regular expression

```bash
grep -E '<PAT>' /etc/passwd > /root/<OUTF>
```

`grep -E` uses extended regular expressions. Redirecting with `>` writes the
matching lines, in order, with no extra lines.
