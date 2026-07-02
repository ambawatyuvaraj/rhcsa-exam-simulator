# Reference solution — swap partition with a priority

Make a swap partition, format it with `mkswap`, then add an fstab entry. The
`pri=<PRI>` option sets the swap priority (higher = used first).

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary linux-swap 1MiB 300MiB
mkswap ${disk}1                                            # format as swap
echo "UUID=$(blkid -s UUID -o value ${disk}1) none swap defaults,nofail,pri=<PRI> 0 0" >>/etc/fstab   # persist with priority
swapon -a                                                  # activate fstab swaps now
swapon --show=NAME,PRIO                                     # verify the priority
```
