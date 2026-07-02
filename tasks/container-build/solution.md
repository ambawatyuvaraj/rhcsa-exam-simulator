# Reference solution — build an image from a Containerfile

`podman build` reads the `Containerfile` in the build-context directory <BD> and
produces a local image tagged <IMG>.

## In the real RHCSA exam

The Containerfile and its base image come from the registry/URL the exam gives
you. Fetch the build context and authenticate so the `FROM` line can resolve the
base image:

```bash
wget <url>/Containerfile           # fetch the Containerfile into your build dir
podman login <registry-url>        # the exam gives you the registry + a username/password
                                   # this lets the FROM line pull the base image
cd <BD>
podman build -t <IMG> .            # build; the FROM base is pulled from the registry
```

## In this offline lab

There is no registry, so the Containerfile and its base image are already present
locally (pre-loaded) — you skip `wget`/`login` and just build:

```bash
cd <BD>                                  # directory that holds the Containerfile
podman build -t <IMG> .                  # build and tag the image as <IMG>
podman image exists <IMG> && echo built  # verify the image exists
podman images                            # list images (look for <IMG>)
```
