# Reference solution — per-user default umask

A umask of `227` removes write+execute from group (2+1) and all of read+write+
execute from "other" only partially — precisely: new files become `r--r-----`
(444 & ~227 = 440) and new directories `r-xr-x---` (777 & ~227 = 550). Set it in
natasha's own login profile, `~/.bash_profile`.

```bash
echo 'umask 227' >> /home/natasha/.bash_profile   # natasha's default umask
runuser -l natasha -c umask                        # verify -> 0227
```
