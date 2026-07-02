# Reference solution — users, group and group membership

Create the group, the three users (sarah with no interactive shell), set the
shared password, then add harry and natasha to the group as a secondary group.

```bash
groupadd manager                          # the group

useradd harry                             # the users
useradd natasha
useradd -s /sbin/nologin sarah            # sarah: no interactive shell

echo ratencot | passwd --stdin harry      # passwords (or interactively: passwd harry)
echo ratencot | passwd --stdin natasha
echo ratencot | passwd --stdin sarah

usermod -aG manager harry                 # harry + natasha -> manager (secondary group)
usermod -aG manager natasha

id harry; id natasha; getent passwd sarah # verify
```
