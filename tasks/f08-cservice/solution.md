# Reference solution — rootless container as a systemd user service

`loginctl enable-linger` lets the user's service keep running with no active login
(so it survives a reboot). Do the work as a real SSH login.

## In the real RHCSA exam
If the image must come from a registry, authenticate and pull it first (here it is
the `monitor` image you built in the container-build task, so this is only needed
when the image is not already local):

```bash
podman login <registry-url>           # username/password given in the exam
podman pull <image>                   # e.g. <registry>/monitor:latest
```

Then create the rootless service:

```bash
ssh walhalla@node1.example.com        # password: redhat
podman run -d --name ascii2pdf \
   -v /opt/files:/opt/incoming:Z \
   -v /opt/processed:/opt/outgoing:Z \
   monitor
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name ascii2pdf --new --files   # -> container-ascii2pdf.service
podman stop ascii2pdf
systemctl --user daemon-reload
systemctl --user enable --now container-ascii2pdf.service
exit
loginctl enable-linger walhalla       # start at boot with no login
```

## In this offline lab
The `monitor` image is already in walhalla's store (built in the container-build
task), so you skip `podman login`/`podman pull` and run the commands above as-is.
