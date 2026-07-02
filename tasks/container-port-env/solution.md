# Reference solution — run a container with an env var and a published port

Run the image detached (`-d`). `-e <EV>=<VAL>` sets an environment variable inside
the container; `-p <HP>:80` publishes the container's port 80 on host port <HP>.

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it before running:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image
podman run -d --name <CN> -e <EV>=<VAL> -p <HP>:80 <registry>/<image>:tag
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded as
localhost/rhcsa-app:latest) and you skip login/pull:

```bash
podman run -d --name <CN> \
  -e <EV>=<VAL> \
  -p <HP>:80 \
  localhost/rhcsa-app:latest

podman inspect <CN> --format '{{range .Config.Env}}{{println .}}{{end}}'   # verify the env var
podman inspect <CN> --format '{{.HostConfig.PortBindings}}'                # verify the port mapping
```
