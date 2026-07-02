# Reference solution — disable a SELinux boolean persistently

Same as enabling, but turn the boolean off. `-P` makes the change persist across
reboots.

```bash
setsebool -P <SB> off
getsebool <SB>                 # verify -> <SB> --> off
```
