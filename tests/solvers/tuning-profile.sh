#!/usr/bin/env bash
systemctl enable --now tuned >/dev/null 2>&1
tuned-adm profile "$(tuned-adm recommend)" >/dev/null 2>&1
