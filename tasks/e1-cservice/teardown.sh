#!/usr/bin/env bash
runuser -l walhalla -c "systemctl --user disable --now container-ascii2pdf.service" >/dev/null 2>&1
loginctl disable-linger walhalla >/dev/null 2>&1
pkill -9 -u walhalla 2>/dev/null; sleep 1
userdel -rf walhalla >/dev/null 2>&1
rm -rf /home/walhalla /opt/files /opt/processed 2>/dev/null
exit 0
