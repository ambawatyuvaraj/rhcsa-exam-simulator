# Reference solution — translate text to uppercase

```bash
tr 'a-z' 'A-Z' < /opt/text.txt > /root/<OUT>
```

`tr` reads from standard input, so redirect the source file in with `<`.
The two ranges map each lowercase letter to its uppercase counterpart.
