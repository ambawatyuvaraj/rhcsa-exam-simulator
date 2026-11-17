# Two-Node Setup Guide

The full, step-by-step two-node setup (with screenshots) now lives in the README:

**→ [README: 4. Two-node exam](README.md#4-two-node-exam)**

In short, on two VMs prepared and installed as in README steps 1–2:

1. On **node1**, copy root's SSH key to node2's root (README 4.1).
2. `sudo rhcsa-sim node-setup --role node1 --peer <node2-ip>` on node1, and
   `sudo rhcsa-sim node-setup --role node2 --peer <node1-ip>` on node2.
3. `sudo rhcsa-sim doctor` on both. node1 must show `controller channel to node2 works`.
4. Run everything else on **node1**: `start`, `tui`, `grade --reboot`, `report --combined`, `reset`.
