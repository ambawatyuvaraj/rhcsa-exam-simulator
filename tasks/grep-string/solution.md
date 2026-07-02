# Reference solution — grep to a file

```bash
grep strato /usr/share/rhcsa/wordlist > /root/lines.txt
cat /root/lines.txt
```
Use plain `grep` (not `grep -v`) and redirect with `>` to preserve order.
