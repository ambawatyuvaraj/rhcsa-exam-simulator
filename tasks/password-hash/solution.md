# Reference solution — set a user's password

Set the account's password. Interactively with `passwd`, or non-interactively by
piping into `passwd --stdin` or `chpasswd` (handy in scripts).

```bash
passwd <U>                          # interactive: type <PW> twice
# --- or non-interactively: ---
echo "<PW>" | passwd --stdin <U>
echo "<U>:<PW>" | chpasswd
```
