# Reference solution — extract matching lines to a file

`grep` prints every line that contains the pattern, in the file's original order;
redirecting with `>` writes exactly those lines to the output file.

```bash
grep "home" /etc/passwd > /root/search.txt   # matching lines -> file
cat /root/search.txt                          # verify
```
