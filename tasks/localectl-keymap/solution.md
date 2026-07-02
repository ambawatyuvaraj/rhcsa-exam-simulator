# Reference solution — set the console keymap

`localectl set-keymap` sets the virtual-console keyboard layout persistently (writes
/etc/vconsole.conf).

```bash
localectl set-keymap <KM>
localectl status        # verify the VC Keymap line
```
