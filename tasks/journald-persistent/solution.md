# Reference solution — persistent systemd journal

By default the journal lives in /run (RAM) and is wiped on every reboot. Setting
`Storage=persistent` and creating `/var/log/journal` makes the journal survive
reboots so you can read logs from previous boots.

```bash
# Set Storage=persistent in journald.conf:
sed -i 's/^#\?Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
# Create the persistent journal directory and apply:
mkdir -p /var/log/journal
systemctl restart systemd-journald
journalctl --disk-usage       # verify it now reports usage under /var/log/journal
ls /var/log/journal
```
