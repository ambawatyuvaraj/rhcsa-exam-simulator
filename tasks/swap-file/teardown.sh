#!/usr/bin/env bash
swapoff /swapfile 2>/dev/null
sed -i '\#^/swapfile#d' /etc/fstab 2>/dev/null
rm -f /swapfile 2>/dev/null
exit 0
