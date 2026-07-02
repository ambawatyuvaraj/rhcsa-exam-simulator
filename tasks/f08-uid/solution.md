# Reference solution — user with a specific UID

`useradd -u` assigns the numeric UID at creation time.

```bash
useradd -u 4332 jean                   # create jean with UID 4332
id jean                                # verify -> uid=4332(jean)
echo ratencot | passwd --stdin jean    # set the password (or interactively: passwd jean)
```
