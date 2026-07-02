#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
getent group "${U}pg" >/dev/null 2>&1 && groupdel "${U}pg" >/dev/null 2>&1
getent group "$G" >/dev/null 2>&1 && groupdel "$G" >/dev/null 2>&1
exit 0
