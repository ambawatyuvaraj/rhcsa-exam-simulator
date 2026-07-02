# Reference solution — SELinux file-context equivalence

```bash
dnf install -y policycoreutils-python-utils   # semanage ships here (not pre-installed)
# Make <DST> share the same labeling rules as <SRC>:
semanage fcontext -a -e <SRC> <DST>

# Apply it so existing files under <DST> are relabeled:
restorecon -R -v <DST>
```

Verify:
```bash
semanage fcontext -l | grep '<DST>'   # shows: <DST> = <SRC>
```
