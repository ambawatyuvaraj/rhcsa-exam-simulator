# Reference solution — rootless container as a systemd user service

In the real RHCSA you would `podman login docker.io` (admin034 / redhat321) and
`podman pull docker.io/admin034/monitor:latest`. In this offline lab the image is
already present as `monitor:latest` in student's image store.

Do this as **student** (log in over SSH: `ssh student@node1.example.com`), not via
`su`, so the rootless user session and D-Bus are set up correctly.

```bash
# 1) run the container with the two bind mounts
podman run -d --name ascii2pdf \
  -v /opt/files:/opt/incoming:Z \
  -v /opt/processed:/opt/outgoing:Z \
  monitor:latest

# 2) generate a systemd USER unit from the running container, then remove the
#    hand-run container (the --new unit recreates one of the same name)
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name ascii2pdf --new --files
mv container-ascii2pdf.service ~/.config/systemd/user/ 2>/dev/null
podman rm -f ascii2pdf

# 3) enable it for boot WITHOUT a login session (linger), and start it now
systemctl --user daemon-reload
systemctl --user enable --now container-ascii2pdf.service
loginctl enable-linger student        # so it starts at boot with no login
```
