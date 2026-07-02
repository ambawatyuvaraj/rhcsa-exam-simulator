# Reference solution — remove a package

`dnf remove` uninstalls the package; `rpm -q` should then report it is not installed.

```bash
dnf remove -y <PKG>
rpm -q <PKG>            # -> "package <PKG> is not installed"
```
