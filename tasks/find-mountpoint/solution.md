# Reference solution — root filesystem type

```bash
findmnt -no FSTYPE / > /root/<OUT>
cat /root/<OUT>      # e.g. xfs
```
`findmnt -no FSTYPE /` prints just the filesystem type of the / mount.
