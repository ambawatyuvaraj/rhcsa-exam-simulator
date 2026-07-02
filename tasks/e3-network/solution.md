# Reference solution — static networking + hostname

A profile named `rhcsa0`, already pinned to the spare `rhcsa0` interface, exists —
configure it. `ipv4.method manual` makes it static (no DHCP) and
`connection.autoconnect yes` brings it up at boot. `hostnamectl set-hostname`
writes the persistent hostname.

```bash
nmcli connection modify rhcsa0 \
      ipv4.method manual \
      ipv4.addresses 172.25.250.11/24 \
      ipv4.gateway 172.25.250.254 \
      ipv4.dns 172.25.250.254 \
      connection.autoconnect yes
nmcli connection up rhcsa0     # NOTE: on this isolated dummy interface NM may say
                               # "no suitable device found" — that is EXPECTED and does
                               # NOT affect grading; the saved configuration is what counts
nmcli connection show rhcsa0 | grep -i ipv4   # verify the saved static settings

hostnamectl set-hostname serverb.lab.example.com
exit                            # log back in to see the new hostname prompt
```

If you build it from scratch instead, you MUST bind it to the spare interface:
`nmcli connection add con-name rhcsa0 ifname rhcsa0 type ethernet ...`.

If you use nmtui: choose **Edit a connection → rhcsa0** and leave the **Device**
field set to `rhcsa0`. Never leave Device blank or set it to your primary NIC
(e.g. `enp1s0`) — an unbound profile attaches to the management interface and
cuts the node off the network.
