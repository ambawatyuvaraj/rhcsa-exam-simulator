#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user service container-ascii2pdf is enabled"     6 user_unit_enabled walhalla container-ascii2pdf.service
ckpt "user service container-ascii2pdf is active"      5 user_unit_active walhalla container-ascii2pdf.service
ckpt "lingering is enabled for walhalla"               3 linger_enabled walhalla
ckpt_expr "bind mount /opt/files -> /opt/incoming"      2 'runuser -l walhalla -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/files:/opt/incoming"'
ckpt_expr "bind mount /opt/processed -> /opt/outgoing"  2 'runuser -l walhalla -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/processed:/opt/outgoing"'
