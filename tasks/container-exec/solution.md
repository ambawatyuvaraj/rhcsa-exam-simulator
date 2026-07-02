# Reference solution — exec inside a running container

`podman exec` runs a command INSIDE the already-running container <CN>; the
redirect saves that command's output on the host at /root/<OUT>.

The `podman exec` step is identical everywhere — the only difference is how the
container's image first reached the host.

## In the real RHCSA exam

The image lives in a registry, so before such a container could be started the
image was authenticated and pulled:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded) and the
container is already running — you skip login/pull and exec straight away:

```bash
podman exec <CN> cat /etc/os-release > /root/<OUT>   # run cmd in <CN>, capture output on host
cat /root/<OUT>                                       # verify the captured file
```
