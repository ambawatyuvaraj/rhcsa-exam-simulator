# Reference solution — sudo timestamp timeout

`timestamp_timeout` is how many minutes sudo remembers your password before asking
again. Set it in a drop-in under /etc/sudoers.d/ (never edit /etc/sudoers directly),
mode 0440, and validate the syntax with `visudo -c`.

```bash
echo 'Defaults timestamp_timeout=<T>' > /etc/sudoers.d/rhcsa-timeout
chmod 0440 /etc/sudoers.d/rhcsa-timeout
visudo -c                              # verify the sudoers syntax is valid
```
