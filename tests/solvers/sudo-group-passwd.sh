#!/usr/bin/env bash
echo "%$G ALL=(ALL) ALL" >"/etc/sudoers.d/$G"
chmod 0440 "/etc/sudoers.d/$G"
