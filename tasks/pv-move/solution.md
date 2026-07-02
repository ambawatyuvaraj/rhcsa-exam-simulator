# Reference solution — evacuate and remove a physical volume

`pvmove` relocates all used extents off one PV onto the VG's other PV(s); once it is
empty, `vgreduce` removes it from the volume group — how you retire a disk from LVM
without losing data.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
pvs -o pv_name,vg_name          # identify the PV to remove, e.g. ${disk}2
pvmove ${disk}2                # move its extents onto the other PV(s)
vgreduce <VG> ${disk}2         # drop the now-empty PV from the VG
vgs <VG>                        # verify the PV count dropped to 1
```
