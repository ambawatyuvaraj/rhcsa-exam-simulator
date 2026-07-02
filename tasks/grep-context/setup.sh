#!/usr/bin/env bash
cat >/opt/ctxsrc.log <<'EOF'
line begin
ERROR first failure
detail one
detail two
line idle
START batch run
step a
step b
step c
COMMIT transaction
done one
done two
line end
EOF
rm -f "/root/$OUT"
echo "grep-context: seeded /opt/ctxsrc.log ($PAT +$N -> /root/$OUT)"
exit 0
