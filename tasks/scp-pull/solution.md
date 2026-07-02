# Reference solution — pull a file with scp

`scp` copies files over SSH. Here you PULL from a remote account (`user@host:path`)
to a local path.

```bash
scp root@localhost:/etc/os-release /root/<OUT>
diff /etc/os-release /root/<OUT>      # verify it matches
```
