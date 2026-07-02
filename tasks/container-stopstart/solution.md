# Reference solution — start a stopped container

The container <CN> already exists but is stopped; `podman start` runs it again.

The `podman start` step is identical everywhere — the only difference is how the
image first reached the host so the container could be created.

## In the real RHCSA exam

The image lives in a registry, so before such a container could be created the image
was authenticated and pulled:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded) and the
stopped container already exists — you skip login/pull and just start it:

```bash
podman start <CN>   # start the stopped container
podman ps           # verify it is now "Up"
```
