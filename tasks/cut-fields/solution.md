# Reference solution — extract colon-separated fields

```bash
cut -d: -f<F> /etc/passwd > /root/<OUT>
```

`-d:` sets the field delimiter to a colon; `-f<F>` selects the requested fields.
`cut` always emits fields in ascending order joined by the delimiter.
