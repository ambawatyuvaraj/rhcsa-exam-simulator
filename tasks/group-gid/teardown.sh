#!/usr/bin/env bash
getent group "$G" >/dev/null 2>&1 && groupdel "$G" >/dev/null 2>&1
exit 0
