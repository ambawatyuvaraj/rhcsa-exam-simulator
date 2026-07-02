#!/usr/bin/env bash
# Test-only: apply the CORRECT solution for every exam-01 task, as a candidate
# would. Run as root on the VM. Verifies setup+grade+solution coherence.
set -u
say(){ printf '\n### %s\n' "$*"; }

say network-config
nmcli con delete rhcsa0 >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsa0 con-name rhcsa0 ipv4.method manual \
  ipv4.addresses 172.25.250.100/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 \
  connection.autoconnect yes >/dev/null 2>&1
nmcli con up rhcsa0 >/dev/null 2>&1
hostnamectl set-hostname node1.example.com
echo "done"

say repo-config
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
dnf -q clean all >/dev/null 2>&1; echo "done"

say selinux-port
semanage port -a -t http_port_t -p tcp 82 2>/dev/null || semanage port -m -t http_port_t -p tcp 82
firewall-cmd --permanent --add-port=82/tcp >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
systemctl enable --now httpd >/dev/null 2>&1; echo "done"

say users-groups
useradd -G sysmgrs natasha 2>/dev/null
useradd -G sysmgrs harry 2>/dev/null
useradd -s /sbin/nologin sarah 2>/dev/null
for u in natasha harry sarah; do echo flectrags | passwd --stdin "$u" >/dev/null 2>&1; done
echo "done"

say collaborative-dir
mkdir -p /home/managers; chgrp sysmgrs /home/managers; chmod 2770 /home/managers; echo "done"

say cron-job
crontab -u operator - <<'EOF'
*/3 * * * * /usr/bin/logger "EX200 Testing"
EOF
echo "done"

say autofs-nfs
echo '/rhome /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs
echo 'remoteuser1 -rw,sync,fstype=nfs4 localhost:/exports/rhome/remoteuser1' >/etc/auto.rhome
systemctl enable --now autofs >/dev/null 2>&1
sleep 1; ls /rhome/remoteuser1 >/dev/null 2>&1; echo "done"

say find-files
mkdir -p /root/findfiles
find / -user jacques -exec cp -a {} /root/findfiles/ \; 2>/dev/null; echo "done"

say tar-archive
tar -czf /root/backup.tar.gz /etc 2>/dev/null; echo "done"

say script-finder
cat >/usr/local/bin/mysearch <<'EOF'
#!/bin/bash
find /usr -size +5k -size -50k -perm -4000 > /root/setuid.list
EOF
chmod +x /usr/local/bin/mysearch; /usr/local/bin/mysearch; echo "done"

say sudo-nopasswd
echo '%sysmgrs ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/sysmgrs
chmod 0440 /etc/sudoers.d/sysmgrs; echo "done"

say lvm-create
DEV="$(cat /var/lib/rhcsa-sim/spare.dev)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 1024MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
PART="${DEV}p1"; [ -b "$PART" ] || PART="${DEV}1"
pvcreate -ff -y "$PART" >/dev/null 2>&1
vgcreate -s 16M myvg "$PART" >/dev/null 2>&1
lvcreate -y -l 50 -n mylv myvg >/dev/null 2>&1
mkfs.vfat /dev/myvg/mylv >/dev/null 2>&1
mkdir -p /mnt/mydata
grep -q /mnt/mydata /etc/fstab || echo "/dev/myvg/mylv /mnt/mydata vfat defaults 0 0" >>/etc/fstab
mount -a 2>/dev/null; echo "done (dev=$DEV part=$PART)"

say tuning-profile
tuned-adm profile "$(tuned-adm recommend)" >/dev/null 2>&1; echo "done"

say root-password
echo redhat123 | passwd --stdin root >/dev/null 2>&1; echo "done"

say container-service
id contsvc >/dev/null 2>&1 || useradd contsvc
grep -q "^contsvc:" /etc/subuid || usermod --add-subuids 200000-265535 --add-subgids 200000-265535 contsvc
loginctl enable-linger contsvc
UID_C=$(id -u contsvc); RD="/run/user/$UID_C"
for i in 1 2 3 4 5; do [ -d "$RD" ] && break; sleep 1; done
runuser -u contsvc -- env HOME=/home/contsvc XDG_RUNTIME_DIR="$RD" \
  DBUS_SESSION_BUS_ADDRESS="unix:path=$RD/bus" bash -lc '
  cd ~
  podman rm -f rhcsa >/dev/null 2>&1
  podman run -d --name rhcsa -v /opt/app-in:/opt/incoming:Z -v /opt/app-out:/opt/outgoing:Z localhost/rhcsa-app:latest >/dev/null 2>&1
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user && podman generate systemd --name rhcsa --new --files >/dev/null 2>&1
  podman rm -f rhcsa >/dev/null 2>&1
  systemctl --user daemon-reload
  systemctl --user enable --now container-rhcsa.service >/dev/null 2>&1
  echo "container is-active: $(systemctl --user is-active container-rhcsa.service)"
'
echo "done"

echo; echo "ALL TASKS SOLVED"
