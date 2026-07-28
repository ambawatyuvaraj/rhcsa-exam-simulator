# Install a Flatpak application

Install the app from the pre-configured remote (system-wide):

```bash
flatpak install --system -y {{REMOTE}} {{APP_ID}}
```

Verify:

```bash
flatpak list --app                 # {{APP_ID}} is listed, origin {{REMOTE}}
```

Remove it again with:

```bash
flatpak uninstall {{APP_ID}}
```
