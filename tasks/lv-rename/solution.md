# Reference solution — rename a logical volume

`lvrename <VG> <OLD> <NEW>` changes the LV's name within its volume group.

```bash
lvs                        # see current LV names
lvrename <VG> <OLD> <NEW>  # rename <OLD> to <NEW> in volume group <VG>
lvs <VG>                   # verify the new name
```
