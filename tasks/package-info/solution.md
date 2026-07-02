# Reference solution — record a package's version

`rpm -q --qf` queries an installed package and prints only the fields you ask for
(here just the VERSION), saved to /root/<OUT>.

```bash
rpm -q --qf '%{VERSION}\n' <PKG> > /root/<OUT>   # write <PKG>'s version to the file
cat /root/<OUT>                                  # verify
```
