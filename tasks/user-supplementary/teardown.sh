#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
getent group "$G1" >/dev/null 2>&1 && groupdel "$G1" >/dev/null 2>&1
getent group "$G2" >/dev/null 2>&1 && groupdel "$G2" >/dev/null 2>&1
exit 0
