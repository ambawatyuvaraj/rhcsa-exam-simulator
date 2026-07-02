#!/usr/bin/env bash
runuser -l contsvc -c "systemctl --user disable --now container-rhcsa.service" >/dev/null 2>&1
loginctl disable-linger contsvc >/dev/null 2>&1
# Kill any lingering contsvc processes (podman, systemd --user) so userdel -r
# can actually remove the home — otherwise a stale home with the old uid breaks
# the next run.
pkill -9 -u contsvc 2>/dev/null; sleep 1
userdel -rf contsvc >/dev/null 2>&1
rm -rf /home/contsvc /opt/app-in /opt/app-out 2>/dev/null
exit 0
