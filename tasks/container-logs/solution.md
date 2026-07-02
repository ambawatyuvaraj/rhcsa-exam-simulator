# Reference solution — capture container logs

`podman logs` prints what container <CN> wrote to stdout/stderr; the redirect saves
those logs to /root/<OUT>.

The `podman logs` step is identical everywhere — the only difference is how the
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
container is already running — you skip login/pull and go straight to capturing the
logs:

```bash
podman logs <CN> > /root/<OUT>   # capture the container's logs to a host file
cat /root/<OUT>                  # verify
```
