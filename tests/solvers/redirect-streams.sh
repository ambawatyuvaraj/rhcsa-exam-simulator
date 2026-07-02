#!/usr/bin/env bash
# Append kernel release to /root/$F1; capture stderr of a failing command to /root/$F2.
uname -r >> "/root/$F1"
ls "/nonexistent-rhcsa-$$" 2> "/root/$F2"
true
