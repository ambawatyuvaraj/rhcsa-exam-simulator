# Reference solution — group, members and a nologin user

Create the group, add harry and natasha to it at creation with `-G`, create sarah
with a non-interactive shell (and NOT in sysmgrs), then set the shared password
for all three.

```bash
groupadd sysmgrs                          # the group

useradd -G sysmgrs harry                  # harry -> member of sysmgrs
useradd -G sysmgrs natasha                # natasha -> member of sysmgrs
useradd -s /sbin/nologin sarah            # sarah: no interactive shell, not in sysmgrs

echo flectrags | passwd --stdin harry     # passwords (or interactively: passwd harry)
echo flectrags | passwd --stdin natasha
echo flectrags | passwd --stdin sarah

id harry; id natasha; getent passwd sarah # verify
```

> If a user already exists, `useradd` fails — use `usermod` instead:
> `usermod -aG sysmgrs harry` (add to the group) and
> `usermod -s /sbin/nologin sarah` (set the login shell).
