#!/usr/bin/env bash
# Assign the dedicated dummy interface to the requested zone, permanently +
# runtime (never touches the default zone the real services live in).
firewall-cmd --permanent --zone="$ZONE" --change-interface=rhcsafw >/dev/null 2>&1
firewall-cmd --zone="$ZONE" --change-interface=rhcsafw >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
