#!/usr/bin/env bash
groupadd -f sysmgrs
echo '%sysmgrs ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sysmgrs
chmod 440 /etc/sudoers.d/sysmgrs
