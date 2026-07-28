# Configure access to a Flatpak repository

Add the repository as a system remote (it is unsigned, so `--no-gpg-verify`):

```bash
flatpak remote-add --system --no-gpg-verify {{REMOTE}} file://{{REPO_PATH}}
```

Verify:

```bash
flatpak remotes                     # {{REMOTE}} is listed
flatpak remote-ls {{REMOTE}}        # shows the app available from it
```

Notes:
- On the real RHCSA 10 exam the URL is usually an `http://` or
  `oci+https://` classroom mirror; the command is identical apart from the URL.
- Remove a remote with:  `flatpak remote-delete {{REMOTE}}`
