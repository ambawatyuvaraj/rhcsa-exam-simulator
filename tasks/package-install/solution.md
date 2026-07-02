# Reference solution — install a package

`dnf install` fetches and installs the package (and its dependencies) from the
configured repositories; `rpm -q` confirms it is present.

```bash
dnf install -y <PKG>
rpm -q <PKG>            # verify it is installed
```
