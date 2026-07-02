# Reference solution — make sshd listen on an extra port (with SELinux)

SELinux only lets sshd bind ports labelled `ssh_port_t`, so you must label the new port
BEFORE sshd can use it. Then tell sshd to listen on both 22 and the new port and restart.

```bash
dnf install -y policycoreutils-python-utils   # semanage ships here (not pre-installed)
semanage port -a -t ssh_port_t -p tcp <PORT>     # label the port for SELinux
echo 'Port 22'     >  /etc/ssh/sshd_config.d/99-rhcsa-extraport.conf
echo 'Port <PORT>' >> /etc/ssh/sshd_config.d/99-rhcsa-extraport.conf
systemctl restart sshd
semanage port -l | grep ssh_port_t    # verify the label includes <PORT>
ss -ltnp | grep sshd                  # verify it listens on 22 and <PORT>
```
