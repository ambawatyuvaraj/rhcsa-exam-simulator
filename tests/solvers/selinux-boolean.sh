#!/usr/bin/env bash
# Enable the SELinux boolean persistently
setsebool -P "$SBOOL" on
