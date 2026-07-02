# Reference solution — add a persistent kernel argument

```bash
# add the argument to every installed kernel entry
grubby --update-kernel=ALL --args="<ARG>"

# verify
grubby --info=ALL | grep args=
```

To also have NEW kernels inherit it, add it to GRUB_CMDLINE_LINUX in
/etc/default/grub.
