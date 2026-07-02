#!/usr/bin/env bash
mkdir -p /opt/permsrc/sub
# Seed files spanning the candidate modes (644 600 755) plus distractors.
printf 'a\n' >/opt/permsrc/file_a.txt;     chmod 644 /opt/permsrc/file_a.txt
printf 'b\n' >/opt/permsrc/file_b.cfg;     chmod 600 /opt/permsrc/file_b.cfg
printf 'c\n' >/opt/permsrc/script_c.sh;    chmod 755 /opt/permsrc/script_c.sh
printf 'd\n' >/opt/permsrc/sub/file_d.txt; chmod 644 /opt/permsrc/sub/file_d.txt
printf 'e\n' >/opt/permsrc/sub/file_e.dat; chmod 600 /opt/permsrc/sub/file_e.dat
printf 'f\n' >/opt/permsrc/sub/run_f.sh;   chmod 755 /opt/permsrc/sub/run_f.sh
printf 'g\n' >/opt/permsrc/other_g.txt;    chmod 640 /opt/permsrc/other_g.txt
rm -rf "/root/$OUT"
echo "find-perm: seeded /opt/permsrc (target mode $MODE -> /root/$OUT)"
exit 0
