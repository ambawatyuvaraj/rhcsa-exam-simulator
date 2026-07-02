# Reference solution — copy preserving SELinux context

A plain `cp` gives the destination the default context of the target directory
(here that already happens to be httpd_sys_content_t), but to be explicit:

```bash
# Either copy preserving the source context:
cp --preserve=context /var/www/html/<F> /var/www/html/<F2>

# ...or copy then restore the default context for that path:
cp /var/www/html/<F> /var/www/html/<F2>
restorecon -v /var/www/html/<F2>
```

Verify:
```bash
ls -Z /var/www/html/<F2>    # type is httpd_sys_content_t
```
