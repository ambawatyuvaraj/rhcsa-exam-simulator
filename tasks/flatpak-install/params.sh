#!/usr/bin/env bash
# The offline Flatpak repo is provisioned AND its remote is pre-added by setup,
# so this task is purely about installing the app system-wide.
names=(localapps rhcsalab labrepo campusflat)
echo "REMOTE=${names[RANDOM % ${#names[@]}]}"
echo "REPO_PATH=/opt/rhcsa-flatpak/repo"
echo "APP_ID=com.example.HelloRHCSA"
