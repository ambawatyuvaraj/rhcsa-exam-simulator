# Reference solution — run a container with a named volume

A named volume is podman-managed persistent storage. Create it, then mount it into
the container at /data with `-v <VOL>:/data`.

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it before running:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
podman volume create <VOL>
podman run -d --name <CN> -v <VOL>:/data <registry>/<image>:tag
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded as
localhost/rhcsa-app:latest) and you skip login/pull:

```bash
podman volume create <VOL>                                            # create the named volume
podman run -d --name <CN> -v <VOL>:/data localhost/rhcsa-app:latest   # mount it at /data
podman volume exists <VOL>                                            # verify the volume
podman inspect <CN> --format '{{range .Mounts}}{{.Name}} {{end}}'     # verify it is mounted
```
