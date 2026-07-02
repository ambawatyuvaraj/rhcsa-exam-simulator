# Reference solution — capture an image's ID

`podman image inspect` prints image metadata; the Go-template `--format` pulls out
just the image ID, saved to /root/<OUTF>.

The `inspect` step is identical everywhere — the only difference is how the image
first reached local storage so it can be inspected.

## In the real RHCSA exam

The image lives in a registry, so you authenticate and pull it first, then inspect:

```bash
podman login <registry-url>        # the exam gives you the registry + a username/password
podman pull <registry>/<image>:tag # download the image into local storage
podman image inspect --format '{{.Id}}' <registry>/<image>:tag > /root/<OUTF>
```

## In this offline lab

There is no registry, so the image is already present locally (pre-loaded as
localhost/rhcsa-app:latest) — you skip login/pull and inspect it directly:

```bash
podman image inspect --format '{{.Id}}' localhost/rhcsa-app:latest > /root/<OUTF>   # extract the image ID
cat /root/<OUTF>                                                                    # verify
```
