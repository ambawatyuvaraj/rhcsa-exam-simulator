# Reference solution — group, members and a nologin user

Create the group, add harry and natasha to it at creation with `-G`, create sarah
with a non-interactive shell, then set the shared password for all three.

```bash
groupadd admin                            # the group

useradd -G admin harry                    # harry -> member of admin
useradd -G admin natasha                  # natasha -> member of admin
useradd -s /sbin/nologin sarah            # sarah: no interactive shell

echo 123 | passwd --stdin harry           # passwords (or interactively: passwd harry)
echo 123 | passwd --stdin natasha
echo 123 | passwd --stdin sarah

id harry; id natasha; getent passwd sarah # verify
```

> If a user already exists, `useradd` fails — use `usermod` instead:
> `usermod -aG admin harry` (add to the group) and
> `usermod -s /sbin/nologin sarah` (set the login shell).
