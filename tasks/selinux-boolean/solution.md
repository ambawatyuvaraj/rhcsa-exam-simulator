# Reference solution — enable a SELinux boolean persistently

SELinux booleans toggle bits of policy on/off. `setsebool -P` flips a boolean AND
writes it to policy so it survives a reboot (without `-P` it reverts on reboot).

```bash
setsebool -P <SBOOL> on        # -P = persistent
getsebool <SBOOL>              # verify -> <SBOOL> --> on
```
