# Reference solution — extract matching lines to a file

`grep` prints every line that contains the pattern, in the file's original order;
redirecting with `>` writes exactly those lines to the output file.

```bash
grep strato /usr/share/dict/words > /root/lines.txt   # matching lines -> file
cat /root/lines.txt                                    # verify
```
