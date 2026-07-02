# Reference solution — user with a specific UID

`useradd -u` assigns the numeric UID at creation time.

```bash
useradd -u 3533 manalo                 # create manalo with UID 3533
id manalo                              # verify -> uid=3533(manalo)
echo flectrag | passwd --stdin manalo  # set the password (or interactively: passwd manalo)
```

> If manalo already exists, change its UID with `usermod -u 3533 manalo` (then
> `chown -R 3533 /home/manalo`) instead of `useradd`.
