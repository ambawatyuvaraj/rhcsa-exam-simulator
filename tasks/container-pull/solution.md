# Reference solution — get an image into local storage

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image into local storage
podman images                      # verify it is present
```

## In this offline lab

There is no registry, so instead of pulling, the image was saved to a tar archive
and you import it with `podman load -i` (the offline equivalent of `podman pull`),
which recreates localhost/rhcsa-app:latest:

```bash
podman load -i /root/<TARNAME>.tar                             # import the image from the archive
podman image exists localhost/rhcsa-app:latest && echo loaded # verify it is present
podman images
```
