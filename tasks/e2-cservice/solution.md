# Reference solution — rootless container as a systemd user service

`loginctl enable-linger` lets wallah's service keep running with no active login
(so it survives a reboot). Do the work as a real SSH login.

## In the real RHCSA exam
The `watch` image lives in a registry, so you authenticate and pull it:

```bash
ssh wallah@node1.example.com           # password: redhat
podman login <registry-url>            # username/password given in the exam
podman pull watch                      # pull watch:latest from the registry
podman run -d --name ascii2pdf \
   -v /opt/files:/opt/dir1:Z \
   -v /opt/progress:/opt/dir2:Z \
   watch:latest
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name ascii2pdf --new --files   # -> container-ascii2pdf.service
podman stop ascii2pdf
systemctl --user daemon-reload
systemctl --user enable --now container-ascii2pdf.service
exit
loginctl enable-linger wallah          # start at boot with no login
```

## In this offline lab
There is no registry here, so the `watch` image is pre-loaded into wallah's store
(tagged `watch:latest`). Skip `podman login`/`podman pull` and run the rest as-is.
