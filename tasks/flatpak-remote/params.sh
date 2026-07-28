#!/usr/bin/env bash
# A local, offline Flatpak repository (ostree-backed) is provisioned under
# REPO_PATH; the candidate adds it as a system remote named REMOTE. file:// is
# used for the same reason the RPM repo tasks do — it works fully offline, no
# httpd/subscription needed.
names=(localapps rhcsalab labrepo campusflat)
echo "REMOTE=${names[RANDOM % ${#names[@]}]}"
echo "REPO_PATH=/opt/rhcsa-flatpak/repo"
echo "APP_ID=com.example.HelloRHCSA"
