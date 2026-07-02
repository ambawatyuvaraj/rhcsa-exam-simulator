# Reference solution — activate a specific tuned profile

`tuned` applies a bundle of performance tunings ("profile"). `tuned-adm profile`
switches to the requested one and makes it persist.

```bash
tuned-adm list                  # see available profiles
tuned-adm profile <PROF>        # activate the requested profile
tuned-adm active                # verify -> Current active profile: <PROF>
```
