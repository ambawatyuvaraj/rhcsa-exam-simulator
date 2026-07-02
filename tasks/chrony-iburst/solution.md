# Reference solution — NTP client with iburst

Add the time source to `/etc/chrony.conf` — `iburst` makes the first sync fast —
then enable + start `chronyd` so it syncs now and at every boot.

```bash
vi /etc/chrony.conf
   # comment out any existing pool/server lines, then add ONE source line:
   # server <SRV> iburst
echo 'server <SRV> iburst' >> /etc/chrony.conf   # (equivalent non-interactive form)
systemctl enable --now chronyd
systemctl restart chronyd
chronyc sources -v        # the source appears; `timedatectl` shows "synchronized: yes"
```

> `server <SRV> iburst` names a single time source (what the RHCSA answer keys
> use). `pool <SRV> iburst` is also valid — it lets the name expand to several
> servers. Either is accepted; `iburst` and an enabled+running chronyd are the
> requirements.
