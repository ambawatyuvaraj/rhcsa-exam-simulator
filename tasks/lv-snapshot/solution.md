# Reference solution — LVM snapshot

`lvcreate -s` makes a snapshot LV — a point-in-time copy-on-write image of an
existing LV; `-L` sizes its copy-on-write space.

```bash
lvcreate -s -L 100M -n <SNAP> /dev/<VG>/<LV>   # snapshot of <LV>, named <SNAP>
lvs -o lv_name,origin <VG>                     # verify: <SNAP>'s origin is <LV>
```
