# Reference solution — SELinux port for httpd

```bash
dnf install -y policycoreutils-python-utils   # semanage ships here (not pre-installed)
# Allow httpd to bind tcp/82 in SELinux policy:
semanage port -a -t http_port_t -p tcp 82      # (-m if it already exists)

# Open the firewall:
firewall-cmd --permanent --add-port=82/tcp
firewall-cmd --reload

# Start at boot + now:
systemctl enable --now httpd

curl http://localhost:82
```
The root cause is SELinux: `httpd` may only bind ports labelled
`http_port_t`. Port 82 is not labelled by default, so the bind is denied.
