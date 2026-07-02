#!/usr/bin/env bash
# Restore the default SELinux context on the file under /var/www/html
restorecon -Fv "/var/www/html/$F" >/dev/null 2>&1
