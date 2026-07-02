#!/usr/bin/env bash
runuser -l walhalla -c "podman rmi -f monitor localhost/monitor:latest localhost/rhcsa-app:latest" >/dev/null 2>&1
rm -rf /home/walhalla/build 2>/dev/null
loginctl disable-linger walhalla >/dev/null 2>&1
pkill -9 -u walhalla 2>/dev/null; sleep 1
userdel -rf walhalla >/dev/null 2>&1
rm -rf /home/walhalla 2>/dev/null
exit 0
