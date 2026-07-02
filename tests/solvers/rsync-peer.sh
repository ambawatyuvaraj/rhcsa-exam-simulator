#!/usr/bin/env bash
rsync -a -e 'ssh -o StrictHostKeyChecking=no -o ConnectTimeout=6' \
  /opt/datasrc "deploy@$PEER_ROLE.example.com:/home/deploy/"
