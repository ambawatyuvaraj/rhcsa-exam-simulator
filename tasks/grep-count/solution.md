# Reference solution — count matching lines

```bash
grep -c '<PAT>' /etc/passwd > /root/<OUT>
```

`grep -c` prints the number of matching lines. Redirecting writes just that
integer to the file.
