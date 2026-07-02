# Reference solution — substitute a string throughout a copied file

```bash
sed 's/<OLD>/<NEW>/g' /opt/sedsrc.txt > /root/<OUT>
```

The `g` flag replaces every occurrence on each line, not just the first.
Writing to a new file with `>` leaves the original untouched.
