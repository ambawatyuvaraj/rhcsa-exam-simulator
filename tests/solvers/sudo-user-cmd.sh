#!/usr/bin/env bash
echo "$U ALL=(ALL) NOPASSWD: /usr/bin/systemctl" >"/etc/sudoers.d/$U"
chmod 0440 "/etc/sudoers.d/$U"
