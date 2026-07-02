#!/usr/bin/env bash
# Restore the node's two-node role identity (node1/node2.example.com) so the
# hostname isn't left drifted after the exam. Falls back to localhost on a
# single-node setup. Cross-node addressing uses /etc/hosts + node.conf regardless.
if [ -r /var/lib/rhcsa-sim/node.conf ]; then
  . /var/lib/rhcsa-sim/node.conf
  hostnamectl set-hostname "${NODE_ROLE:-localhost}.example.com" >/dev/null 2>&1
else
  hostnamectl set-hostname localhost.localdomain >/dev/null 2>&1
fi
exit 0
