#!/usr/bin/env bash
rm -f /etc/sudoers.d/admin 2>/dev/null
sed -i '/%admin/d' /etc/sudoers 2>/dev/null
exit 0
