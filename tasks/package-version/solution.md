# Reference solution — ensure a package is installed

`dnf install` installs the package from the configured repositories; it is
idempotent (a no-op if the package is already present).

```bash
dnf install -y <PKG>   # install <PKG>
rpm -q <PKG>           # verify it is installed
```
