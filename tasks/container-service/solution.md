# Reference solution — rootless container systemd user service

A rootless service runs under the user's OWN systemd instance. `loginctl
enable-linger` lets that instance run with no active login. The catch: `su - user`
does NOT start a user D-Bus session, so `systemctl --user` fails with *"Failed to
connect to bus: No medium found"* until you point `XDG_RUNTIME_DIR` at the lingering
user's runtime directory.

```bash
# As root: allow contsvc's services to run without an active login session.
loginctl enable-linger contsvc

# Become contsvc, and give systemctl --user a runtime dir to reach the user bus:
su - contsvc
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Run the container, then generate + enable its user service:
podman run -d --name rhcsa-app \
   -v /opt/app-in:/opt/incoming:Z \
   -v /opt/app-out:/opt/outgoing:Z \
   localhost/rhcsa-app:latest
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name rhcsa-app --new --files
mv container-rhcsa-app.service container-rhcsa.service   # the service must be named container-rhcsa
systemctl --user daemon-reload
systemctl --user enable --now container-rhcsa.service
```
Tip: with newer podman you can also use a Quadlet (~/.config/containers/systemd/).
