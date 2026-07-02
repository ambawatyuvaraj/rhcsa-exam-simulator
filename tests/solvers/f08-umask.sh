#!/usr/bin/env bash
id daffy >/dev/null 2>&1 || useradd daffy
grep -q 'umask 027' /home/daffy/.bashrc 2>/dev/null || echo 'umask 027' >> /home/daffy/.bashrc
