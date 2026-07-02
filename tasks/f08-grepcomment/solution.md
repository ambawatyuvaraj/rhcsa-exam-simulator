# Reference solution — extract the uncommented lines

Uncommented lines are the ones that do NOT begin with '#'.

```bash
grep -v '^#' /etc/sudoers > /root/list    # keep lines not starting with #
cat /root/list                             # verify
```
