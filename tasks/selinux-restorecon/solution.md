# Reference solution — restore default SELinux context

```bash
restorecon -v /var/www/html/<F>
```

Verify:
```bash
ls -Z /var/www/html/<F>       # type should be httpd_sys_content_t
```

Notes:
- `restorecon` resets a file's context to the default defined by policy
  (here, files under `/var/www/html` default to `httpd_sys_content_t`).
