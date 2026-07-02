# Reference solution — extract matching lines to a file

`grep` prints every line that contains the pattern, in the file's original order;
redirecting with `>` writes exactly those lines to the output file.

```bash
grep ng /usr/share/xml/iso-codes/iso_639_3.xml > /root/list   # matching lines -> file
cat /root/list                                                 # verify
```
