#!/usr/bin/env bash
getent group manager >/dev/null 2>&1 || groupadd manager
mkdir -p /home/contrib; chgrp manager /home/contrib; chmod 2770 /home/contrib
