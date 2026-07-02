# Reference solution — list files by name into a file

`find /etc -name '*.conf'` prints the full path of every file ending in .conf
under /etc; redirect that output into /search.

```bash
find /etc -name '*.conf' > /search    # write every matching path to /search
cat /search                            # verify
```
