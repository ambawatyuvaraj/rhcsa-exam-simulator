#!/usr/bin/env bash
id natasha >/dev/null 2>&1 || useradd natasha
grep -q 'umask 227' /home/natasha/.bash_profile 2>/dev/null || echo 'umask 227' >> /home/natasha/.bash_profile
