# Reference solution — user with a specific UID

`useradd -u` assigns the numeric UID at creation time.

```bash
useradd -u 1326 alies                  # create alies with UID 1326
id alies                               # verify -> uid=1326(alies)
echo 123 | passwd --stdin alies        # set the password (or interactively: passwd alies)
```

> If alies already exists, change its UID with `usermod -u 1326 alies` (then
> `chown -R 1326 /home/alies`) instead of `useradd`.
