# Reference solution — system-wide cron job

System cron files in /etc/cron.d use SIX time fields plus a user field:

```bash
cat > /etc/cron.d/<F> <<'EOF'
*/10 * * * * root /usr/bin/logger sysjob
EOF
```
Verify: `cat /etc/cron.d/<F>`
