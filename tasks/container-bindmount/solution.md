# Reference solution — run a container with a host bind mount

The `ro` flag makes the mount read-only; `Z` relabels the host directory with
a private SELinux container context.

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it before running:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
podman run -d --name <CN> -v <BDIR>:/hostdata:ro,Z <registry>/<image>:tag
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded as
localhost/rhcsa-app:latest) and you skip login/pull:

```bash
podman run -d --name <CN> -v <BDIR>:/hostdata:ro,Z localhost/rhcsa-app:latest

podman inspect <CN> --format '{{range .HostConfig.Binds}}{{println .}}{{end}}'
```
