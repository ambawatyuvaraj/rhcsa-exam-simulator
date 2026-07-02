#!/usr/bin/env bash
echo "%sysmgrs ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/sysmgrs; chmod 0440 /etc/sudoers.d/sysmgrs
