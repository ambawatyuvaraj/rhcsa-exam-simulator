#!/usr/bin/env bash
# Set up passwordless SSH from root to deploy@peer. A candidate would use
# ssh-copy-id with deploy's password; this test automation installs root's
# public key into deploy's authorized_keys over the controller channel
# (rhcsactl@peer + sudo), which keeps working even if an exam task has set
# PermitRootLogin no. (Raw append needs a restorecon or sshd rejects the key.)
[ -f /root/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f /root/.ssh/id_ed25519 >/dev/null 2>&1
PUB="$(cat /root/.ssh/id_ed25519.pub)"
SSHOPTS="-o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8"
RCTLKEY="/home/rhcsactl/.ssh/id_ed25519"
peer="$PEER_ROLE.example.com"
install_keys="install -d -m700 -o deploy -g deploy /home/deploy/.ssh; \
grep -qF '$PUB' /home/deploy/.ssh/authorized_keys 2>/dev/null || echo '$PUB' >> /home/deploy/.ssh/authorized_keys; \
chown deploy: /home/deploy/.ssh/authorized_keys; chmod 600 /home/deploy/.ssh/authorized_keys; restorecon -RF /home/deploy/.ssh 2>/dev/null"
# Prefer the rhcsactl controller account; fall back to root for old setups.
if ssh $SSHOPTS -i "$RCTLKEY" "rhcsactl@$peer" sudo -n true >/dev/null 2>&1; then
  ssh $SSHOPTS -i "$RCTLKEY" "rhcsactl@$peer" "sudo bash -c \"$install_keys\""
else
  ssh $SSHOPTS "root@$peer" "$install_keys"
fi
