#!/usr/bin/env bash
id walhalla >/dev/null 2>&1 || useradd -m walhalla
loginctl enable-linger walhalla >/dev/null 2>&1; sleep 1
runuser -l walhalla -c 'cd ~/build && podman build -t monitor .' >/dev/null 2>&1
