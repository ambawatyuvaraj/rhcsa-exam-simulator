#!/usr/bin/env bash
getent group admin >/dev/null 2>&1 || groupadd -f admin
mkdir -p /common/shared
chgrp admin /common/shared
chmod 2770 /common/shared
