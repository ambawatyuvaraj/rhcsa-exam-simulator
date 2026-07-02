# Reference solution — write matches with trailing context

```bash
grep -A <N> '<PAT>' /opt/ctxsrc.log > /root/<OUT>
```

`grep -A <N>` prints each matching line plus `<N>` lines of trailing context.
`grep` inserts a `--` group separator between non-adjacent match blocks; keep it
as produced by `grep`.
