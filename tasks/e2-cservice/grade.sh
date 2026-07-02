#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user service container-ascii2pdf is enabled"  6 user_unit_enabled wallah container-ascii2pdf.service
ckpt "user service container-ascii2pdf is active"   5 user_unit_active wallah container-ascii2pdf.service
ckpt "lingering is enabled for wallah"              3 linger_enabled wallah
ckpt_expr "bind mount /opt/files -> /opt/dir1"      2 'runuser -l wallah -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/files:/opt/dir1"'
ckpt_expr "bind mount /opt/progress -> /opt/dir2"   2 'runuser -l wallah -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/progress:/opt/dir2"'
