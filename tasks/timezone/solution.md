# Reference solution — set the system time zone

`timedatectl set-timezone` sets the system clock's zone (updates /etc/localtime). Use
`list-timezones` to find the exact region/city name.

```bash
timedatectl list-timezones | grep -i <TZ>   # find the exact zone name
timedatectl set-timezone <TZ>
timedatectl                                       # verify the "Time zone" line
```
