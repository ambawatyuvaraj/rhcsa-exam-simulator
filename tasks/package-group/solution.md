# Reference solution — install a package group

A package group is a named bundle of related packages (e.g. "Development Tools").
`dnf group install` pulls in the group's packages; verify by checking the group is
installed and/or that a representative member package is present.

```bash
dnf group list                      # see available groups
dnf group install -y "<GROUPNAME>"  # install the group (quote names with spaces)
dnf group list --installed          # verify the group
rpm -q <MEMBER>                     # verify a member package
```
