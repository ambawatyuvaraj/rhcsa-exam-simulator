#!/usr/bin/env bash
cat >/etc/yum.repos.d/peerrepo.repo <<EOF
[peerrepo]
name=Peer repository
baseurl=http://$PEER_ROLE.example.com/pkgrepo
enabled=1
gpgcheck=0
EOF
dnf clean all >/dev/null 2>&1
