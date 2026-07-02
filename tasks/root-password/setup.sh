#!/usr/bin/env bash
# Make the scenario AUTHENTIC: actually set root's password to a random value
# that nobody knows, so the candidate must genuinely break in via the boot
# loader (rd.break) — exactly like the real EX200's "second system". Safe for
# the simulator: harness/grading use root's SSH key + the rhcsactl channel,
# both password-independent.
rand="$(tr -dc 'A-Za-z0-9' </dev/urandom 2>/dev/null | head -c 24)"
[ -n "$rand" ] || rand="Scrambled-$$-$RANDOM$RANDOM"
echo "root:$rand" | chpasswd 2>/dev/null
echo "root-password: root's password is now an unknown random value — reset it to '${PW:-redhat123}'"
exit 0
