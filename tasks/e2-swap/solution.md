# Reference solution — swap partition

This spare disk is shared with the LVM tasks, so **add** a partition (do not
re-label the whole disk). Partition 1 already holds the existing `myvol` volume
group (the resize task) and the new `myvg` goes on partition 2; the answer key
puts swap on /dev/vdb, partition 3.

> Note: use the spare disk on this system (run `lsblk`; here it is `/dev/vdb`).

```bash
fdisk /dev/vdb
   # n -> p -> 3 -> <enter> -> +512M     (new 512 MiB partition)
   # t -> 3 -> 82                        (type: Linux swap)
   # w
udevadm settle
mkswap /dev/vdb3
# make it persistent by UUID (don't disturb existing fstab lines):
echo "UUID=$(blkid -s UUID -o value /dev/vdb3)  swap  swap  defaults,nofail  0 0" >> /etc/fstab
swapon -a
free -m        # verify the total swap increased by ~512 MiB
```
