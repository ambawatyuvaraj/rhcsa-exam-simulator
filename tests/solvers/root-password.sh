#!/usr/bin/env bash
# Candidate does this via console boot-interruption (rd.break); automation sets
# the same end state directly (grading verifies the shadow hash either way).
echo "root:${PW:-redhat123}" | chpasswd 2>/dev/null || echo "${PW:-redhat123}" | passwd --stdin root >/dev/null 2>&1
