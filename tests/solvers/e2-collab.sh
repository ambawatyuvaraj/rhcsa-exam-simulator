#!/usr/bin/env bash
getent group sysmgrs >/dev/null 2>&1 || groupadd -f sysmgrs
mkdir -p /home/managers
chgrp sysmgrs /home/managers
chmod 2770 /home/managers
