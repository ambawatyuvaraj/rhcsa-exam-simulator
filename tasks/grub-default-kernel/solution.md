# Reference solution — set the default boot kernel

`grubby` edits bootloader entries without hand-editing config files. `--set-default`
makes the next boot use a specific kernel; `--default-kernel` confirms the choice.

```bash
grubby --set-default "/boot/vmlinuz-$(uname -r)"   # default = the running kernel
grubby --default-kernel                            # verify
```
