#!/usr/bin/env bash
id deploy >/dev/null 2>&1 || useradd -m deploy
echo 'deploy:Redhat123' | chpasswd
systemctl enable --now sshd >/dev/null 2>&1
