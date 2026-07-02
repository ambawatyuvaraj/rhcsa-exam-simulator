# Reference solution — script to find SETUID files

```bash
vim /usr/local/bin/newsearch
   #!/bin/bash
   find /usr -size +30k -size -50k -perm /u+s > /root/scriptfind

chmod +x /usr/local/bin/newsearch
newsearch                       # run it
cat /root/scriptfind            # verify
```

Note: the answer key saves results to `/root/findfiles`, but that path is the
directory created by the "find files" task (owned by jacques), so a file of the
same name cannot coexist — this exam uses `/root/scriptfind`.
