#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true   # self-heal: ensure container engine (real exam has it preinstalled)
cp "$RHCSA_ASSETS/rhcsa-app.tar" /root/"$TARNAME".tar 2>/dev/null
# Remove the IMAGE TAG so the student must load it back from the archive. Use
# 'untag' (not 'rmi -f'): rmi -f would force-remove every CONTAINER using this
# image, destroying the containers seeded by sibling container-* tasks when a
# category practice seeds them together (seed order is randomized). untag drops
# only the name, leaving the image (as <none>) and all running containers intact;
# the student's `podman load` re-creates the tag.
podman untag localhost/rhcsa-app:latest >/dev/null 2>&1 || true
echo "container-pull: seeded /root/$TARNAME.tar"
exit 0
