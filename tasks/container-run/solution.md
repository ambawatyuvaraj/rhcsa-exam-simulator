# Reference solution — run a detached container

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it before running
(or let `podman run` pull it on first use):

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
podman run -d --name <CN> <registry>/<image>:tag
podman ps
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded as
localhost/rhcsa-app:latest) and you skip login/pull — just run it:

```bash
podman run -d --name <CN> localhost/rhcsa-app:latest
podman ps
```

The image's default command must keep the container running. If it exits
immediately, supply a long-running command, e.g.:
```bash
podman run -d --name <CN> localhost/rhcsa-app:latest sleep infinity
```
