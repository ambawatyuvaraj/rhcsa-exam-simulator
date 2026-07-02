# Reference solution — build a container image as a user

Build the image in the user's own (rootless) image store. Log in as the user
**over SSH** — a real login gives a clean systemd user session (becoming the user
with `su -` instead prints harmless `cgroup`/`no systemd user session` warnings).

## In the real RHCSA exam
The Containerfile is downloaded from a URL and its base image (`FROM …`) comes
from a registry, so you authenticate to the registry first:

```bash
ssh walhalla@node1.example.com        # password: redhat
wget http://<server>/Containerfile    # download the provided Containerfile
podman login <registry-url>           # username: admin   password: redhat321
podman build -t monitor .             # the FROM line now pulls the base from the registry
podman images                         # verify 'monitor' is listed
```

## In this offline lab
There is no registry or Internet here, so the Containerfile is already staged in
`~/build` and its base image is pre-loaded into walhalla's rootless store — just
build (no `wget`, no `podman login`):

```bash
ssh walhalla@node1.example.com        # password: redhat
cd ~/build
podman build -t monitor .
podman images
```
