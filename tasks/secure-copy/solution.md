# Reference solution — securely copy a file

Copy a file over an encrypted SSH channel with `scp` (`local -> user@host:path`),
then confirm the copy is byte-identical.

```bash
scp /etc/hostname root@localhost:/root/<OUTF>
diff /etc/hostname /root/<OUTF> && echo OK
```
