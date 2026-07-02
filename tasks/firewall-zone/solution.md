# Reference solution — Assign an interface to a firewalld zone

```bash
# Permanently bind the dedicated interface rhcsafw to the requested zone
# (do NOT change the default zone — that affects the interface you're on).
firewall-cmd --permanent --zone=<ZONE> --change-interface=rhcsafw
firewall-cmd --zone=<ZONE> --change-interface=rhcsafw   # runtime, no reload needed
firewall-cmd --reload
```
Verify: `firewall-cmd --get-zone-of-interface=rhcsafw`,
`firewall-cmd --permanent --zone=<ZONE> --query-interface=rhcsafw`.
