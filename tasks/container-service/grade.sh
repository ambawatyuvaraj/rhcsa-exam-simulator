#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "image localhost/rhcsa-app:latest present"    3 image_present contsvc localhost/rhcsa-app:latest
ckpt "user service container-rhcsa is enabled"     5 user_unit_enabled contsvc container-rhcsa.service
ckpt "user service container-rhcsa is active"      4 user_unit_active contsvc container-rhcsa.service
ckpt "lingering is enabled for contsvc"            2 linger_enabled contsvc
ckpt_expr "bind mount /opt/app-in -> /opt/incoming"  2 'runuser -l contsvc -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/app-in:/opt/incoming"'
ckpt_expr "bind mount /opt/app-out -> /opt/outgoing" 2 'runuser -l contsvc -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/app-out:/opt/outgoing"'
