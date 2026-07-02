# Reference solution — create an xz-compressed tar archive

```bash
tar cJf /root/<ARC>.tar.xz /opt/xz
tar tJf /root/<ARC>.tar.xz     # verify contents
```

The uppercase `J` selects xz compression, `c` creates, `f` names the output.
