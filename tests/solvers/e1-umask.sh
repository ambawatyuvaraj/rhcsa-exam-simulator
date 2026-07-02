#!/usr/bin/env bash
id natasha >/dev/null 2>&1 || useradd natasha
grep -q 'umask 277' /home/natasha/.bash_profile 2>/dev/null || echo 'umask 277' >> /home/natasha/.bash_profile
