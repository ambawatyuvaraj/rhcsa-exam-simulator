#!/usr/bin/env bash
# Build-time generator: writes the remaining task definition files.
# Idempotent — safe to re-run. (Not shipped with the product runtime.)
set -euo pipefail
T="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/tasks"
w(){ mkdir -p "$(dirname "$1")"; cat >"$1"; }

# ============================ network-config ============================
w "$T/network-config/meta.sh" <<'TASKEOF'
TASK_TITLE="Configure a static network connection"
TASK_DOMAIN="network"
TASK_POINTS=12
TASKEOF
w "$T/network-config/prompt.txt" <<'TASKEOF'
A spare network interface named rhcsa0 is present on this system.

Create a NetworkManager connection named rhcsa0 (bound to interface rhcsa0)
with the following static IPv4 configuration, and make sure it starts
automatically:

  IPv4 address : 172.25.250.100/24
  Gateway      : 172.25.250.254
  DNS server   : 172.25.250.254
  Method       : manual

Also set this system's static hostname to:  node1.example.com
TASKEOF
w "$T/network-config/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
# Provide a spare dummy interface (persists across reboot via a boot unit).
cat >/etc/systemd/system/rhcsa-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsa0 type dummy
ExecStartPost=/usr/sbin/ip link set rhcsa0 up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsa0 >/dev/null 2>&1 || ip link add rhcsa0 type dummy 2>/dev/null
ip link set rhcsa0 up 2>/dev/null
systemctl enable rhcsa-dummy.service >/dev/null 2>&1
nmcli -t -f NAME con show 2>/dev/null | grep -qx rhcsa0 && nmcli con delete rhcsa0 >/dev/null 2>&1
echo "network-config: spare interface rhcsa0 ready"
exit 0
TASKEOF
w "$T/network-config/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "connection 'rhcsa0' exists"                 2 'nmcli -t -f NAME con show 2>/dev/null | grep -qx rhcsa0'
ckpt_expr "IPv4 address 172.25.250.100/24 configured"  4 'nmcli -g ipv4.addresses con show rhcsa0 2>/dev/null | grep -q "172.25.250.100/24"'
ckpt_expr "IPv4 gateway 172.25.250.254 configured"     2 'nmcli -g ipv4.gateway con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "DNS server 172.25.250.254 configured"       1 'nmcli -g ipv4.dns con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "IPv4 method is manual"                       1 'nmcli -g ipv4.method con show rhcsa0 2>/dev/null | grep -qi manual'
ckpt_expr "static hostname is node1.example.com"        2 '[ "$(hostnamectl --static hostname 2>/dev/null || hostname)" = node1.example.com ]'
TASKEOF
w "$T/network-config/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
nmcli con delete rhcsa0 >/dev/null 2>&1
systemctl disable --now rhcsa-dummy.service 2>/dev/null
rm -f /etc/systemd/system/rhcsa-dummy.service; systemctl daemon-reload 2>/dev/null
ip link del rhcsa0 2>/dev/null
hostnamectl set-hostname localhost.localdomain 2>/dev/null
exit 0
TASKEOF
w "$T/network-config/solution.md" <<'TASKEOF'
# Reference solution — Static network connection

```bash
nmcli con add type ethernet ifname rhcsa0 con-name rhcsa0 \
      ipv4.method manual \
      ipv4.addresses 172.25.250.100/24 \
      ipv4.gateway 172.25.250.254 \
      ipv4.dns 172.25.250.254 \
      connection.autoconnect yes
nmcli con up rhcsa0

hostnamectl set-hostname node1.example.com
```
Verify: `nmcli con show rhcsa0 | grep ipv4`, `hostname`.
TASKEOF

# ============================ repo-config ============================
w "$T/repo-config/meta.sh" <<'TASKEOF'
TASK_TITLE="Configure the default (local) YUM repositories"
TASK_DOMAIN="deploy"
TASK_POINTS=12
TASKEOF
w "$T/repo-config/prompt.txt" <<'TASKEOF'
Configure this system to use the following two repositories. They already
exist locally on this machine (offline):

  Repository id : BaseOS
    baseurl     : file:///opt/rhcsa-repo/BaseOS
  Repository id : AppStream
    baseurl     : file:///opt/rhcsa-repo/AppStream

GPG signature checking must be disabled for both repositories, and both must
be enabled.
TASKEOF
w "$T/repo-config/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
mkdir -p /opt/rhcsa-repo/BaseOS /opt/rhcsa-repo/AppStream
command -v createrepo_c >/dev/null 2>&1 || dnf -y install createrepo_c >/dev/null 2>&1 || true
createrepo_c /opt/rhcsa-repo/BaseOS    >/dev/null 2>&1 || true
createrepo_c /opt/rhcsa-repo/AppStream >/dev/null 2>&1 || true
echo "repo-config: local repo trees created under /opt/rhcsa-repo"
exit 0
TASKEOF
w "$T/repo-config/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "BaseOS repo is enabled in dnf"          4 'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx BaseOS'
ckpt_expr "AppStream repo is enabled in dnf"       4 'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx AppStream'
ckpt_expr "BaseOS baseurl points to local repo"    2 'grep -rhA10 "^\[BaseOS\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -q "file:///opt/rhcsa-repo/BaseOS"'
ckpt_expr "gpgcheck disabled for BaseOS"           2 'grep -rhA10 "^\[BaseOS\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0"'
TASKEOF
w "$T/repo-config/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -rf /opt/rhcsa-repo 2>/dev/null
exit 0
TASKEOF
w "$T/repo-config/solution.md" <<'TASKEOF'
# Reference solution — Local repositories

```bash
cat >/etc/yum.repos.d/rhcsa.repo <<'EOF'
[BaseOS]
name=BaseOS
baseurl=file:///opt/rhcsa-repo/BaseOS
enabled=1
gpgcheck=0

[AppStream]
name=AppStream
baseurl=file:///opt/rhcsa-repo/AppStream
enabled=1
gpgcheck=0
EOF

dnf clean all
dnf repolist enabled
```
TASKEOF

# ============================ selinux-port ============================
w "$T/selinux-port/meta.sh" <<'TASKEOF'
TASK_TITLE="Debug SELinux: web server on non-standard port 82"
TASK_DOMAIN="security"
TASK_POINTS=20
TASKEOF
w "$T/selinux-port/prompt.txt" <<'TASKEOF'
A web server (httpd) on this system is configured to listen on the
non-standard port 82, but it is failing to serve content. Diagnose and fix
the problem so that:

  * The web server serves the existing content located in /var/www/html
    (do NOT modify or remove the existing files there).
  * The web server serves its content on port 82.
  * The web server starts automatically at boot.

The content must be reachable, for example:  curl http://localhost:82
TASKEOF
w "$T/selinux-port/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
dnf -y install httpd policycoreutils-python-utils >/dev/null 2>&1 || true
mkdir -p /var/www/html
echo "RHCSA simulator web content" >/var/www/html/index.html
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
TASKEOF
w "$T/selinux-port/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "httpd package is installed"                  1 pkg_installed httpd
ckpt_expr "SELinux: http_port_t includes tcp/82"   6 'semanage port -l 2>/dev/null | awk "/^http_port_t/ && /tcp/" | grep -qw 82'
ckpt_expr "firewall allows 82/tcp"                 3 'firewall-cmd --list-ports 2>/dev/null | tr " " "\n" | grep -qx 82/tcp'
ckpt "httpd is enabled at boot"                    2 svc_enabled httpd
ckpt "httpd is running"                            2 svc_active httpd
ckpt_expr "content served on http://localhost:82"  6 'curl -s -o /dev/null -w "%{http_code}" http://localhost:82 2>/dev/null | grep -qE "^(200|403|301)$"'
TASKEOF
w "$T/selinux-port/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
systemctl disable --now httpd >/dev/null 2>&1
semanage port -d -t http_port_t -p tcp 82 >/dev/null 2>&1
firewall-cmd --remove-port=82/tcp >/dev/null 2>&1
firewall-cmd --permanent --remove-port=82/tcp >/dev/null 2>&1
sed -i 's/^Listen 82/Listen 80/' /etc/httpd/conf/httpd.conf 2>/dev/null
rm -f /var/www/html/index.html 2>/dev/null
exit 0
TASKEOF
w "$T/selinux-port/solution.md" <<'TASKEOF'
# Reference solution — SELinux port for httpd

```bash
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
TASKEOF

# ============================ cron-job ============================
w "$T/cron-job/meta.sh" <<'TASKEOF'
TASK_TITLE="Schedule a recurring cron job"
TASK_DOMAIN="deploy"
TASK_POINTS=12
TASKEOF
w "$T/cron-job/prompt.txt" <<'TASKEOF'
Configure a cron job, owned by the user operator, that runs the following
command every 3 minutes:

  /usr/bin/logger "EX200 Testing"
TASKEOF
w "$T/cron-job/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
id operator >/dev/null 2>&1 || useradd operator
crontab -r -u operator >/dev/null 2>&1 || true
echo "cron-job: user 'operator' ready"
exit 0
TASKEOF
w "$T/cron-job/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user 'operator' exists"                      2 user_exists operator
ckpt_expr "operator cron runs every 3 minutes"     6 'crontab -l -u operator 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "^\*/3[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"'
ckpt_expr "cron command is logger EX200 Testing"   4 'crontab -l -u operator 2>/dev/null | grep -F "logger" | grep -q "EX200 Testing"'
TASKEOF
w "$T/cron-job/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
crontab -r -u operator >/dev/null 2>&1
userdel -rf operator >/dev/null 2>&1
exit 0
TASKEOF
w "$T/cron-job/solution.md" <<'TASKEOF'
# Reference solution — cron job

```bash
crontab -e -u operator
# add the line:
*/3 * * * * /usr/bin/logger "EX200 Testing"
```
Verify: `crontab -l -u operator`
TASKEOF

# ============================ chrony-ntp ============================
w "$T/chrony-ntp/meta.sh" <<'TASKEOF'
TASK_TITLE="Configure the system as an NTP/chrony client"
TASK_DOMAIN="deploy"
TASK_POINTS=10
TASKEOF
w "$T/chrony-ntp/prompt.txt" <<'TASKEOF'
Configure this system to synchronise its time from the NTP server:

  time.example.com   (use the iburst option)

The chronyd service must be enabled and running.
TASKEOF
w "$T/chrony-ntp/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
dnf -y install chrony >/dev/null 2>&1 || true
echo "chrony-ntp: chrony present"
exit 0
TASKEOF
w "$T/chrony-ntp/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "chrony is installed"                         1 pkg_installed chrony
ckpt_expr "chrony.conf has server time.example.com" 5 'grep -vE "^[[:space:]]*#" /etc/chrony.conf | grep -qE "^(server|pool)[[:space:]]+time\.example\.com\b"'
ckpt "chronyd is enabled"                          2 svc_enabled chronyd
ckpt "chronyd is active"                           2 svc_active chronyd
TASKEOF
w "$T/chrony-ntp/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
sed -i '/time\.example\.com/d' /etc/chrony.conf 2>/dev/null
systemctl restart chronyd 2>/dev/null
exit 0
TASKEOF
w "$T/chrony-ntp/solution.md" <<'TASKEOF'
# Reference solution — chrony NTP client

```bash
# In /etc/chrony.conf add (or replace the pool line with):
server time.example.com iburst

systemctl enable --now chronyd
chronyc sources -v
```
TASKEOF

# ============================ autofs-nfs ============================
w "$T/autofs-nfs/meta.sh" <<'TASKEOF'
TASK_TITLE="Automount an NFS home directory with autofs"
TASK_DOMAIN="filesystems"
TASK_POINTS=16
TASKEOF
w "$T/autofs-nfs/prompt.txt" <<'TASKEOF'
This system exports an NFS share. Configure autofs to automatically mount a
remote user's home directory as follows:

  * NFS export (on this host):  localhost:/exports/rhome/remoteuser1
  * It must be automounted on demand at:  /rhome/remoteuser1
  * The mount must be read-write.
  * The autofs service must be enabled and running.

Test:  ls /rhome/remoteuser1     (you should see a README file)
TASKEOF
w "$T/autofs-nfs/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
dnf -y install nfs-utils autofs >/dev/null 2>&1 || true
mkdir -p /exports/rhome/remoteuser1
id remoteuser1 >/dev/null 2>&1 || useradd -u 4101 -d /rhome/remoteuser1 -M remoteuser1 2>/dev/null
echo "hello from remoteuser1 home" >/exports/rhome/remoteuser1/README
chown -R remoteuser1:remoteuser1 /exports/rhome/remoteuser1
grep -q "/exports/rhome" /etc/exports 2>/dev/null || \
  echo "/exports/rhome *(rw,sync,no_root_squash)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
echo "autofs-nfs: NFS export localhost:/exports/rhome ready"
exit 0
TASKEOF
w "$T/autofs-nfs/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "autofs is installed"                          1 pkg_installed autofs
ckpt "sim NFS server is running"                    1 svc_active nfs-server
ckpt_expr "autofs map references the NFS export"    2 'grep -rhs "/exports/rhome" /etc/auto.master /etc/auto.master.d/ /etc/auto.* 2>/dev/null | grep -q .'
ckpt "autofs is enabled"                            2 svc_enabled autofs
ckpt "autofs is active"                             2 svc_active autofs
ckpt_expr "/rhome/remoteuser1 automounts on access" 6 'ls /rhome/remoteuser1/README >/dev/null 2>&1 && findmnt /rhome/remoteuser1 >/dev/null 2>&1'
ckpt_expr "automounted directory is writable"       2 'touch /rhome/remoteuser1/.wtest 2>/dev/null && rm -f /rhome/remoteuser1/.wtest'
TASKEOF
w "$T/autofs-nfs/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount /rhome/remoteuser1 2>/dev/null
rm -rf /rhome 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/rhome#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
userdel -rf remoteuser1 >/dev/null 2>&1
rm -rf /exports 2>/dev/null
exit 0
TASKEOF
w "$T/autofs-nfs/solution.md" <<'TASKEOF'
# Reference solution — autofs + NFS

```bash
dnf -y install autofs nfs-utils

# Master map entry (indirect map for /rhome):
echo '/rhome  /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs

# The map itself:
echo 'remoteuser1  -rw,sync,fstype=nfs4  localhost:/exports/rhome/remoteuser1' \
     >/etc/auto.rhome

systemctl enable --now autofs
ls /rhome/remoteuser1        # triggers the automount
```
TASKEOF

# ============================ find-files ============================
w "$T/find-files/meta.sh" <<'TASKEOF'
TASK_TITLE="Find files owned by a user and copy them"
TASK_DOMAIN="tools"
TASK_POINTS=12
TASKEOF
w "$T/find-files/prompt.txt" <<'TASKEOF'
Find all files on this system that are owned by the user jacques, and copy
them into the directory /root/findfiles (create the directory if needed).
TASKEOF
w "$T/find-files/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
id jacques >/dev/null 2>&1 || useradd jacques
for p in /opt/jdata/report.txt /var/tmp/jnotes.log /srv/jacques.cfg; do
  mkdir -p "$(dirname "$p")"; echo "owned by jacques" >"$p"; chown jacques "$p"
done
rm -rf /root/findfiles
echo "find-files: seeded jacques-owned files"
exit 0
TASKEOF
w "$T/find-files/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/findfiles is a directory"              2 is_dir /root/findfiles
ckpt_expr "all jacques-owned files were copied"    8 'for f in report.txt jnotes.log jacques.cfg; do [ -e "/root/findfiles/$f" ] || exit 1; done; exit 0'
ckpt_expr "at least the 3 seeded files are present" 2 '[ "$(find /root/findfiles -type f 2>/dev/null | wc -l)" -ge 3 ]'
TASKEOF
w "$T/find-files/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -rf /root/findfiles /opt/jdata /var/tmp/jnotes.log /srv/jacques.cfg 2>/dev/null
userdel -rf jacques >/dev/null 2>&1
exit 0
TASKEOF
w "$T/find-files/solution.md" <<'TASKEOF'
# Reference solution — find + copy by owner

```bash
mkdir -p /root/findfiles
find / -user jacques -exec cp -a {} /root/findfiles/ \;
ls -l /root/findfiles
```
TASKEOF

# ============================ grep-string ============================
w "$T/grep-string/meta.sh" <<'TASKEOF'
TASK_TITLE="Extract matching lines to a file"
TASK_DOMAIN="tools"
TASK_POINTS=10
TASKEOF
w "$T/grep-string/prompt.txt" <<'TASKEOF'
Find all the lines that contain the string 'strato' in the file
/usr/share/rhcsa/wordlist and write all of those lines, in their original
order, into the file /root/lines.txt.

/root/lines.txt must contain ONLY the matching lines (no blank lines), and
each line must be an exact copy of the corresponding source line.
TASKEOF
w "$T/grep-string/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
mkdir -p /usr/share/rhcsa
cat >/usr/share/rhcsa/wordlist <<WL
atmosphere
stratosphere
stratus
cumulus
substrate
stratovolcano
nimbostratus
mountain
demonstrator
stratify
ocean
WL
rm -f /root/lines.txt
echo "grep-string: seeded /usr/share/rhcsa/wordlist"
exit 0
TASKEOF
w "$T/grep-string/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/lines.txt exists"                      2 path_exists /root/lines.txt
ckpt_expr "contents exactly match grep output"     6 'diff <(grep strato /usr/share/rhcsa/wordlist) /root/lines.txt >/dev/null 2>&1'
ckpt_expr "no blank lines present"                 2 '! grep -qx "" /root/lines.txt'
TASKEOF
w "$T/grep-string/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /root/lines.txt /usr/share/rhcsa/wordlist 2>/dev/null
rmdir /usr/share/rhcsa 2>/dev/null
exit 0
TASKEOF
w "$T/grep-string/solution.md" <<'TASKEOF'
# Reference solution — grep to a file

```bash
grep strato /usr/share/rhcsa/wordlist > /root/lines.txt
cat /root/lines.txt
```
Use plain `grep` (not `grep -v`) and redirect with `>` to preserve order.
TASKEOF

# ============================ tar-archive ============================
w "$T/tar-archive/meta.sh" <<'TASKEOF'
TASK_TITLE="Create a gzip-compressed tar archive"
TASK_DOMAIN="tools"
TASK_POINTS=10
TASKEOF
w "$T/tar-archive/prompt.txt" <<'TASKEOF'
Create a tar archive named /root/backup.tar.gz that contains the contents of
the /etc directory. The archive must be compressed using gzip.
TASKEOF
w "$T/tar-archive/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /root/backup.tar.gz
echo "tar-archive: ready"
exit 0
TASKEOF
w "$T/tar-archive/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/backup.tar.gz exists"                  3 path_exists /root/backup.tar.gz
ckpt_expr "archive is gzip-compressed"             4 'file /root/backup.tar.gz | grep -qiE "gzip compressed"'
ckpt_expr "archive contains /etc content"          3 'tar tzf /root/backup.tar.gz 2>/dev/null | grep -qE "(^|/)etc/"'
TASKEOF
w "$T/tar-archive/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /root/backup.tar.gz 2>/dev/null
exit 0
TASKEOF
w "$T/tar-archive/solution.md" <<'TASKEOF'
# Reference solution — gzip tar archive

```bash
tar -czf /root/backup.tar.gz /etc
file /root/backup.tar.gz
tar tzf /root/backup.tar.gz | head
```
TASKEOF

# ============================ script-finder ============================
w "$T/script-finder/meta.sh" <<'TASKEOF'
TASK_TITLE="Write a shell script to find SUID files"
TASK_DOMAIN="scripting"
TASK_POINTS=14
TASKEOF
w "$T/script-finder/prompt.txt" <<'TASKEOF'
Create a script named /usr/local/bin/mysearch that finds all files under
/usr which are larger than 5k AND smaller than 50k AND have the SUID
permission set, and writes the resulting list of file paths to
/root/setuid.list.

  * The script must be executable.
  * Running the command  mysearch  (with no arguments) must (re)create
    /root/setuid.list containing exactly those matching paths.
TASKEOF
w "$T/script-finder/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /usr/local/bin/mysearch /root/setuid.list
echo "script-finder: ready"
exit 0
TASKEOF
w "$T/script-finder/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/usr/local/bin/mysearch exists"              2 path_exists /usr/local/bin/mysearch
ckpt_expr "mysearch is executable"                 2 '[ -x /usr/local/bin/mysearch ]'
ckpt_expr "running mysearch creates /root/setuid.list" 4 'rm -f /root/setuid.list; /usr/local/bin/mysearch >/dev/null 2>&1; [ -s /root/setuid.list ]'
ckpt_expr "results match the required criteria"    6 'diff <(find /usr -size +5k -size -50k -perm -4000 2>/dev/null | sort) <(sort /root/setuid.list 2>/dev/null) >/dev/null 2>&1'
TASKEOF
w "$T/script-finder/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /usr/local/bin/mysearch /root/setuid.list 2>/dev/null
exit 0
TASKEOF
w "$T/script-finder/solution.md" <<'TASKEOF'
# Reference solution — SUID finder script

```bash
cat >/usr/local/bin/mysearch <<'EOF'
#!/bin/bash
find /usr -size +5k -size -50k -perm -4000 > /root/setuid.list
EOF
chmod +x /usr/local/bin/mysearch
mysearch
cat /root/setuid.list
```
`-perm -4000` matches the SUID bit; `-size +5k -size -50k` bounds the size.
TASKEOF

# ============================ container-service ============================
w "$T/container-service/meta.sh" <<'TASKEOF'
TASK_TITLE="Run a rootless container as a systemd user service"
TASK_DOMAIN="containers"
TASK_POINTS=18
TASKEOF
w "$T/container-service/prompt.txt" <<'TASKEOF'
As the existing user contsvc, configure a container that runs as a rootless
systemd *user* service:

  * Use the container image:  localhost/rhcsa-app:latest
    (already present in contsvc's local image store)
  * The container is managed by a systemd user service named
    container-rhcsa.service
  * The service starts automatically at boot, with NO manual intervention,
    even when contsvc is not logged in.
  * Bind-mount host /opt/app-in  -> container /opt/incoming
    and        host /opt/app-out -> container /opt/outgoing
TASKEOF
w "$T/container-service/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
dnf -y install podman >/dev/null 2>&1 || true
id contsvc >/dev/null 2>&1 || useradd contsvc
mkdir -p /opt/app-in /opt/app-out
chown contsvc:contsvc /opt/app-in /opt/app-out
if [ -f "$RHCSA_ASSETS/rhcsa-app.tar" ]; then
  runuser -l contsvc -c "podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'" >/dev/null 2>&1 || true
else
  # Fallback: tag a tiny base image as the expected name (best-effort, needs an image present)
  runuser -l contsvc -c "podman image exists localhost/rhcsa-app:latest || podman pull registry.access.redhat.com/ubi9/ubi-micro 2>/dev/null && podman tag registry.access.redhat.com/ubi9/ubi-micro localhost/rhcsa-app:latest" >/dev/null 2>&1 || true
fi
echo "container-service: user contsvc + image localhost/rhcsa-app:latest seeded"
exit 0
TASKEOF
w "$T/container-service/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "image localhost/rhcsa-app:latest present"    3 image_present contsvc localhost/rhcsa-app:latest
ckpt "user service container-rhcsa is enabled"     5 user_unit_enabled contsvc container-rhcsa.service
ckpt "user service container-rhcsa is active"      4 user_unit_active contsvc container-rhcsa.service
ckpt "lingering is enabled for contsvc"            2 linger_enabled contsvc
ckpt_expr "bind mount /opt/app-in -> /opt/incoming"  2 'runuser -l contsvc -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/app-in:/opt/incoming"'
ckpt_expr "bind mount /opt/app-out -> /opt/outgoing" 2 'runuser -l contsvc -c "podman ps -aq | xargs -r podman inspect --format {{.HostConfig.Binds}}" 2>/dev/null | grep -q "/opt/app-out:/opt/outgoing"'
TASKEOF
w "$T/container-service/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
runuser -l contsvc -c "systemctl --user disable --now container-rhcsa.service" >/dev/null 2>&1
loginctl disable-linger contsvc >/dev/null 2>&1
userdel -rf contsvc >/dev/null 2>&1
rm -rf /opt/app-in /opt/app-out 2>/dev/null
exit 0
TASKEOF
w "$T/container-service/solution.md" <<'TASKEOF'
# Reference solution — rootless container systemd user service

```bash
# As root: allow contsvc services to run without an active login session
loginctl enable-linger contsvc

# Work as contsvc:
su - contsvc
podman run -d --name rhcsa-app \
   -v /opt/app-in:/opt/incoming:Z \
   -v /opt/app-out:/opt/outgoing:Z \
   localhost/rhcsa-app:latest

mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name rhcsa-app --new --files
# The generated unit is container-rhcsa-app.service; rename/symlink to
# container-rhcsa.service as required, then:
systemctl --user daemon-reload
systemctl --user enable --now container-rhcsa.service
```
Tip: with newer podman you can also use a Quadlet (~/.config/containers/systemd/).
TASKEOF

# ============================ sudo-nopasswd ============================
w "$T/sudo-nopasswd/meta.sh" <<'TASKEOF'
TASK_TITLE="Grant passwordless sudo to a group"
TASK_DOMAIN="users"
TASK_POINTS=10
TASKEOF
w "$T/sudo-nopasswd/prompt.txt" <<'TASKEOF'
Configure sudo so that members of the sysmgrs group can run any command as
root using sudo, WITHOUT being prompted for a password.
TASKEOF
w "$T/sudo-nopasswd/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
groupadd -f sysmgrs
rm -f /etc/sudoers.d/sysmgrs 2>/dev/null
echo "sudo-nopasswd: group sysmgrs ready"
exit 0
TASKEOF
w "$T/sudo-nopasswd/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "a NOPASSWD rule for %sysmgrs exists" 7 'grep -rhE "^[[:space:]]*%sysmgrs[[:space:]]+ALL=\(ALL(:ALL)?\)[[:space:]]+NOPASSWD:[[:space:]]*ALL" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q .'
ckpt_expr "sudoers configuration is syntactically valid" 3 'visudo -c >/dev/null 2>&1'
TASKEOF
w "$T/sudo-nopasswd/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /etc/sudoers.d/sysmgrs 2>/dev/null
sed -i '/%sysmgrs/d' /etc/sudoers 2>/dev/null
exit 0
TASKEOF
w "$T/sudo-nopasswd/solution.md" <<'TASKEOF'
# Reference solution — passwordless sudo for a group

```bash
echo '%sysmgrs ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/sysmgrs
chmod 0440 /etc/sudoers.d/sysmgrs
visudo -c        # validate syntax
```
Prefer a file in /etc/sudoers.d/ over editing /etc/sudoers directly.
TASKEOF

# ============================ swap-partition ============================
w "$T/swap-partition/meta.sh" <<'TASKEOF'
TASK_TITLE="Add a swap partition"
TASK_DOMAIN="storage"
TASK_POINTS=14
TASKEOF
w "$T/swap-partition/prompt.txt" <<'TASKEOF'
Add an additional 512 MiB of swap space to this system, using a new partition
on the spare block device attached to this machine (identify it with `lsblk`
— it is the unused disk that has no partitions/filesystems).

  * The new swap must be active now and must be enabled automatically at
    every boot.
  * Do NOT remove or alter any existing swap.
TASKEOF
w "$T/swap-partition/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "swap-partition: could not provide a spare disk"; exit 1; }
# record baseline swap (MiB) so grading can detect the increase
free -m | awk '/Swap/{print $2}' >"$RHCSA_STATE/swap.base"
echo "swap-partition: spare disk = $dev (baseline swap recorded)"
exit 0
TASKEOF
w "$T/swap-partition/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
base="$(cat "$RHCSA_STATE/swap.base" 2>/dev/null || echo 0)"
ckpt_expr "total swap increased by ~512 MiB" 6 "now=\$(free -m | awk '/Swap/{print \$2}'); [ \$(( now - $base )) -ge 480 ]"
ckpt_expr "a swap entry exists in /etc/fstab"  5 'grep -vE "^[[:space:]]*#" /etc/fstab | grep -qw swap'
ckpt_expr "new swap is currently active"       3 'swapon --show=NAME --noheadings 2>/dev/null | grep -q .'
TASKEOF
w "$T/swap-partition/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
spare_cleanup
rm -f "$RHCSA_STATE/swap.base" 2>/dev/null
exit 0
TASKEOF
w "$T/swap-partition/solution.md" <<'TASKEOF'
# Reference solution — add swap

```bash
lsblk                              # identify the spare disk, e.g. /dev/vdb
parted /dev/vdb mklabel gpt        # (only if the disk has no label)
parted /dev/vdb mkpart primary linux-swap 1MiB 513MiB
mkswap /dev/vdb1
# add to fstab by UUID:
echo "UUID=$(blkid -s UUID -o value /dev/vdb1) none swap defaults 0 0" >>/etc/fstab
swapon -a
swapon --show
```
Note: in this simulator the spare disk may be a loop device (/dev/loopN).
TASKEOF

# ============================ lvm-create ============================
w "$T/lvm-create/meta.sh" <<'TASKEOF'
TASK_TITLE="Create a volume group and logical volume"
TASK_DOMAIN="storage"
TASK_POINTS=18
TASKEOF
w "$T/lvm-create/prompt.txt" <<'TASKEOF'
On the spare block device attached to this machine, create LVM storage:

  * A volume group named myvg whose physical extent (PE) size is 16 MiB.
  * A logical volume named mylv in myvg, sized at exactly 50 extents.
  * Format mylv with the vfat filesystem.
  * Mount mylv persistently (it must remain mounted across reboots) at
    /mnt/mydata.
TASKEOF
w "$T/lvm-create/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "lvm-create: could not provide a spare disk"; exit 1; }
vgremove -f myvg >/dev/null 2>&1 || true
rm -rf /mnt/mydata 2>/dev/null
echo "lvm-create: spare disk = $dev"
exit 0
TASKEOF
w "$T/lvm-create/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume group myvg exists"         3 'vgs myvg >/dev/null 2>&1'
ckpt "PE (extent) size is 16 MiB"            3 vg_extent_size myvg 16
ckpt "logical volume myvg/mylv exists"       4 lv_exists myvg mylv
ckpt "mylv size is ~50 extents (~800 MiB)"   2 lv_size_between /dev/myvg/mylv 760 840
ckpt "filesystem at /mnt/mydata is vfat"     3 fs_type /mnt/mydata vfat
ckpt "mounted & persistent at /mnt/mydata"   3 mount_persistent /mnt/mydata
TASKEOF
w "$T/lvm-create/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount /mnt/mydata 2>/dev/null
sed -i '\#/mnt/mydata#d' /etc/fstab 2>/dev/null
lvremove -f myvg >/dev/null 2>&1
vgremove -f myvg >/dev/null 2>&1
rm -rf /mnt/mydata 2>/dev/null
spare_cleanup
exit 0
TASKEOF
w "$T/lvm-create/solution.md" <<'TASKEOF'
# Reference solution — VG + LV + vfat + persistent mount

```bash
lsblk
parted /dev/vdb mklabel gpt
parted /dev/vdb mkpart primary 1MiB 1024MiB
pvcreate /dev/vdb1
vgcreate -s 16M myvg /dev/vdb1          # 16 MiB physical extents
lvcreate -l 50 -n mylv myvg            # 50 extents
mkfs.vfat /dev/myvg/mylv
mkdir -p /mnt/mydata
echo "/dev/myvg/mylv /mnt/mydata vfat defaults 0 0" >>/etc/fstab
mount -a
```
TASKEOF

# ============================ lvm-resize ============================
w "$T/lvm-resize/meta.sh" <<'TASKEOF'
TASK_TITLE="Resize a logical volume"
TASK_DOMAIN="storage"
TASK_POINTS=12
TASKEOF
w "$T/lvm-resize/prompt.txt" <<'TASKEOF'
A logical volume named vo (in volume group vgroup) is mounted at /mnt/vo and
contains data. Resize the logical volume vo, AND its filesystem, to 300 MiB
without losing the existing data.

Note: an exact size is rarely possible — any size between 290 MiB and 310 MiB
is acceptable.
TASKEOF
w "$T/lvm-resize/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "lvm-resize: could not provide a spare disk"; exit 1; }
# Build the pre-existing vgroup/vo (192 MiB ext4) mounted at /mnt/vo with data.
if ! vgs vgroup >/dev/null 2>&1; then
  pvcreate -ff -y "$dev" >/dev/null 2>&1
  vgcreate vgroup "$dev" >/dev/null 2>&1
  lvcreate -y -L 192M -n vo vgroup >/dev/null 2>&1
  mkfs.ext4 -F /dev/vgroup/vo >/dev/null 2>&1
fi
mkdir -p /mnt/vo
grep -q "/mnt/vo" /etc/fstab 2>/dev/null || \
  echo "/dev/vgroup/vo /mnt/vo ext4 defaults 0 0" >>/etc/fstab
mount /mnt/vo 2>/dev/null || mount -a 2>/dev/null
echo "important data do not lose" >/mnt/vo/data.txt
echo "lvm-resize: seeded vgroup/vo (192M ext4) at /mnt/vo"
exit 0
TASKEOF
w "$T/lvm-resize/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "logical volume vgroup/vo exists"         2 lv_exists vgroup vo
ckpt "vo size is between 290 and 310 MiB"      5 lv_size_between /dev/vgroup/vo 290 310
ckpt_expr "filesystem was grown to match"      3 '[ "$(df -m --output=size /mnt/vo 2>/dev/null | tail -1 | tr -d " ")" -ge 270 ]'
ckpt_expr "original data is still present"     2 'grep -q "important data do not lose" /mnt/vo/data.txt'
TASKEOF
w "$T/lvm-resize/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount /mnt/vo 2>/dev/null
sed -i '\#/mnt/vo#d' /etc/fstab 2>/dev/null
lvremove -f vgroup >/dev/null 2>&1
vgremove -f vgroup >/dev/null 2>&1
rm -rf /mnt/vo 2>/dev/null
spare_cleanup
exit 0
TASKEOF
w "$T/lvm-resize/solution.md" <<'TASKEOF'
# Reference solution — resize a logical volume

```bash
# Grow the LV and its filesystem in one step:
lvextend -r -L 300M /dev/vgroup/vo
# (-r / --resizefs resizes the ext4/xfs filesystem too)

lvs ; df -h /mnt/vo
```
For ext4 you can also use `resize2fs`; for XFS use `xfs_growfs` (grow only).
TASKEOF

# ============================ tuning-profile ============================
w "$T/tuning-profile/meta.sh" <<'TASKEOF'
TASK_TITLE="Apply the recommended tuned profile"
TASK_DOMAIN="operate"
TASK_POINTS=10
TASKEOF
w "$T/tuning-profile/prompt.txt" <<'TASKEOF'
Select the tuned profile that is recommended for this system (as reported by
'tuned-adm recommend') and set it as the active/default profile.
TASKEOF
w "$T/tuning-profile/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
dnf -y install tuned >/dev/null 2>&1 || true
systemctl enable --now tuned >/dev/null 2>&1
echo "tuning-profile: tuned installed and running"
exit 0
TASKEOF
w "$T/tuning-profile/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "tuned is installed"                      1 pkg_installed tuned
ckpt "tuned is enabled"                        2 svc_enabled tuned
ckpt "tuned is active"                         2 svc_active tuned
ckpt "active profile == recommended profile"   5 tuned_is_recommended
TASKEOF
w "$T/tuning-profile/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
exit 0
TASKEOF
w "$T/tuning-profile/solution.md" <<'TASKEOF'
# Reference solution — tuned profile

```bash
dnf -y install tuned
systemctl enable --now tuned
tuned-adm recommend            # e.g. virtual-guest
tuned-adm profile "$(tuned-adm recommend)"
tuned-adm active
```
TASKEOF

# ============================ root-password ============================
w "$T/root-password/meta.sh" <<'TASKEOF'
TASK_TITLE="Reset the root password (boot interruption)"
TASK_DOMAIN="operate"
TASK_POINTS=12
TASKEOF
w "$T/root-password/prompt.txt" <<'TASKEOF'
You do not know the current root password for this system. Reset the root
account's password to:  redhat123

On the real exam this requires interrupting the boot process (the rd.break
method). Any method that results in the correct root password being set is
graded as correct.
TASKEOF
w "$T/root-password/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
echo "root-password: target password is 'redhat123'"
exit 0
TASKEOF
w "$T/root-password/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "root password is set to 'redhat123'"    12 user_password root redhat123
TASKEOF
w "$T/root-password/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
exit 0
TASKEOF
w "$T/root-password/solution.md" <<'TASKEOF'
# Reference solution — reset root password via rd.break

1. Reboot; at the GRUB menu press `e` on the default entry.
2. On the line starting with `linux`, append:  `rd.break`
   (optionally remove `console=` parameters). Press Ctrl-x to boot.
3. At the switch_root prompt:
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   echo 'redhat123' | passwd --stdin root
   touch /.autorelabel          # so SELinux relabels /etc/shadow on boot
   exit
   exit
   ```
The system relabels SELinux contexts and reboots with the new password.
TASKEOF

# ============================ boot-target ============================
w "$T/boot-target/meta.sh" <<'TASKEOF'
TASK_TITLE="Set the default boot target"
TASK_DOMAIN="operate"
TASK_POINTS=8
TASKEOF
w "$T/boot-target/prompt.txt" <<'TASKEOF'
Configure this system so that it boots into the multi-user (text /
non-graphical) target by default.
TASKEOF
w "$T/boot-target/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
# Make the task meaningful: set a non-multi-user default if possible.
if systemctl list-unit-files graphical.target >/dev/null 2>&1; then
  systemctl set-default graphical.target >/dev/null 2>&1 || true
fi
echo "boot-target: default target seeded to graphical (change it to multi-user)"
exit 0
TASKEOF
w "$T/boot-target/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "default target is multi-user.target"     8 default_target multi-user.target
TASKEOF
w "$T/boot-target/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
exit 0
TASKEOF
w "$T/boot-target/solution.md" <<'TASKEOF'
# Reference solution — default boot target

```bash
systemctl set-default multi-user.target
systemctl get-default
```
TASKEOF

# ============================ acl-permissions ============================
w "$T/acl-permissions/meta.sh" <<'TASKEOF'
TASK_TITLE="Configure file permissions with ACLs"
TASK_DOMAIN="users"
TASK_POINTS=14
TASKEOF
w "$T/acl-permissions/prompt.txt" <<'TASKEOF'
Copy the file /etc/fstab to /var/tmp/fstab. Then configure the permissions
(using ACLs as needed) of /var/tmp/fstab so that:

  * The file is owned by user root and group root.
  * The file is NOT executable by anyone.
  * The user frank is able to read and write the file.
  * The user grace is unable to read or write the file.
  * All other users (current and future) are able to read the file.
TASKEOF
w "$T/acl-permissions/setup.sh" <<'TASKEOF'
#!/usr/bin/env bash
id frank >/dev/null 2>&1 || useradd frank
id grace >/dev/null 2>&1 || useradd grace
rm -f /var/tmp/fstab 2>/dev/null
echo "acl-permissions: users frank and grace ready"
exit 0
TASKEOF
w "$T/acl-permissions/grade.sh" <<'TASKEOF'
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/var/tmp/fstab exists"                   2 path_exists /var/tmp/fstab
ckpt "owner is root"                           1 file_owner /var/tmp/fstab root
ckpt "group is root"                           1 file_group /var/tmp/fstab root
ckpt_expr "not executable by anyone"           2 '! stat -c %A /var/tmp/fstab 2>/dev/null | grep -q x'
ckpt "frank has rw- via ACL"                   4 acl_has /var/tmp/fstab user:frank:rw-
ckpt "grace has --- via ACL"                   3 acl_has /var/tmp/fstab user:grace:---
ckpt_expr "other users can read"               1 'getfacl -p /var/tmp/fstab 2>/dev/null | grep -qE "^other::r"'
TASKEOF
w "$T/acl-permissions/teardown.sh" <<'TASKEOF'
#!/usr/bin/env bash
rm -f /var/tmp/fstab 2>/dev/null
userdel -rf frank >/dev/null 2>&1
userdel -rf grace >/dev/null 2>&1
exit 0
TASKEOF
w "$T/acl-permissions/solution.md" <<'TASKEOF'
# Reference solution — ACLs

```bash
cp /etc/fstab /var/tmp/fstab
# owner/group root by default; ensure not executable:
chmod 0644 /var/tmp/fstab
setfacl -m u:frank:rw- /var/tmp/fstab
setfacl -m u:grace:--- /var/tmp/fstab
getfacl /var/tmp/fstab
```
The base "other" class keeps read for everyone else; named ACL entries
override for frank and grace.
TASKEOF

echo "Generated task files under: $T"
