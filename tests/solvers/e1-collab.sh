#!/usr/bin/env bash
getent group admin >/dev/null 2>&1 || groupadd -f admin
mkdir -p /common/admin
chgrp admin /common/admin
chmod 2770 /common/admin
