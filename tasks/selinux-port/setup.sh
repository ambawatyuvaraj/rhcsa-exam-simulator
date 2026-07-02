#!/usr/bin/env bash
dnf -y install httpd policycoreutils-python-utils >/dev/null 2>&1 || true
mkdir -p /var/www/html; chmod 0755 /var/www/html
echo "RHCSA simulator web content" >/var/www/html/index.html
# world-readable + correct label so httpd serves it cleanly (200) once the port is fixed,
# regardless of the seeding shell's umask (a 027 umask would otherwise make it 640 -> 403)
chmod 0644 /var/www/html/index.html
restorecon -F /var/www/html/index.html 2>/dev/null || true
if grep -qE "^Listen " /etc/httpd/conf/httpd.conf 2>/dev/null; then
  sed -i 's/^Listen .*/Listen 82/' /etc/httpd/conf/httpd.conf
else
  echo "Listen 82" >>/etc/httpd/conf/httpd.conf
fi
# Ensure the SELinux label is NOT yet present (this is the bug to fix).
semanage port -d -t http_port_t -p tcp 82 >/dev/null 2>&1 || true
systemctl restart httpd >/dev/null 2>&1 || true   # expected to fail until fixed
echo "selinux-port: httpd seeded to listen on 82 (currently broken)"
exit 0
