# Two-Node Setup Guide

How to set up and run the simulator across **two VMs** — the way the real remote
EX200 is laid out. **node1** is the controller: you drive everything from it, and
it seeds, grades, and controls **node2** over SSH.

> All simulator commands run **as root inside the VMs** (`sudo -i`).
> `virsh`/snapshot commands run on the **hypervisor host**.

---

## Prerequisites

- **Two disposable VMs**, both **RHEL 9** (or Rocky / AlmaLinux / CentOS Stream 9).
  Building the second as a **clone** of the first is easiest.
- Each VM: **~2 GB RAM** and **one blank spare disk** (e.g. `/dev/vdb`) for the
  storage tasks.
- The matching **install DVD ISO attached** to each VM (the offline package source).
- The two VMs are on the **same network and can reach each other by IP**.
- You know each VM's IP (`ip -4 addr` inside the VM). This guide uses:
  - node1 = `192.168.100.10`
  - node2 = `192.168.100.11`

> 💡 **Take a snapshot of each VM before you start.** Reverting a snapshot is the
> fastest, most reliable way to reset.

---

## Step 1 — Copy the simulator to both VMs

On **each** VM, get the project (git clone, or `scp` the folder), e.g.:

```bash
git clone https://github.com/ambawatyuvaraj/rhcsa-exam-simulator.git
cd rhcsa-exam-simulator
```

## Step 2 — Passwordless root SSH: node1 → node2

The grading channel needs node1 to reach node2's root account by key (it then
sets up a dedicated `rhcsactl` grading account automatically). Set this up once:

**On node1** (as root) — create a key and print it:

```bash
[ -f /root/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f /root/.ssh/id_ed25519
cat /root/.ssh/id_ed25519.pub
```

**On node2** (as root) — trust that key:

```bash
mkdir -p /root/.ssh && chmod 700 /root/.ssh
echo 'PASTE-node1-root-public-key-here' >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
restorecon -RF /root/.ssh 2>/dev/null
```

**Back on node1**, confirm it works with no password prompt:

```bash
ssh root@192.168.100.11 hostname     # should print node2's hostname, no password
```

*(Key-based root login is allowed by default on RHEL 9 — you do **not** need to
change `PermitRootLogin`.)*

## Step 3 — Install the simulator on both VMs

On **each** VM (DVD attached), as root:

```bash
sudo ./install.sh          # installs the 'rhcsa-sim' CLI + configures the offline DVD repo
```

## Step 4 — Pair the two nodes

Declare each VM's role and its peer's IP. Run **on both**:

```bash
# on node1  (peer = node2's IP)
sudo rhcsa-sim node-setup --role node1 --peer 192.168.100.11

# on node2  (peer = node1's IP)
sudo rhcsa-sim node-setup --role node2 --peer 192.168.100.10
```

This sets each hostname (`node1.example.com` / `node2.example.com`), writes the
`/etc/hosts` entries, and creates the `rhcsactl` grading account.

## Step 5 — Verify

Run **on both** — everything must be **GREEN**:

```bash
sudo rhcsa-sim doctor
```

On node1 you should see **`controller channel to node2 works`**. If not, see
[Troubleshooting](#troubleshooting).

---

## Step 6 — Start a two-node exam (from node1)

Everything is driven from **node1**:

```bash
sudo rhcsa-sim start exam-2node-01    # seeds BOTH nodes (node1 locally, node2 over SSH)
```

Pick any two-node paper with `rhcsa-sim list` (`exam-2node-01` … `exam-2node-08`).

## Step 7 — Open the paper and do the tasks

```bash
sudo rhcsa-sim tui        # browser "Test Exam" view (add --text for the terminal view)
```

The paper shows **both nodes' task groups**.

- Do **node1** tasks on node1.
- For **node2** tasks, connect to node2 and become root:
  ```bash
  ssh student@node2.example.com
  sudo -i
  ```
  *(node2's first task is usually recovering its own lost root password — do that
  on node2's **console**, not over SSH.)*
- The browser's **VM control** panel manages node2 (status / reboot / console /
  rebuild), like the real exam's VM manager.

## Step 8 — Grade

From **node1**, grade both nodes at once:

```bash
sudo rhcsa-sim grade --reboot     # reboots + grades both, then prints one combined /300 score
```

`--reboot` is the persistence test (like the real exam). For a quick check
without rebooting, use `sudo rhcsa-sim grade`. See the full breakdown with
`sudo rhcsa-sim report --combined`.

## Step 9 — Reset between attempts

```bash
sudo rhcsa-sim reset      # on node1 — wipes changes on BOTH nodes back to clean
```

Or revert both VMs' snapshots from the hypervisor (the most reliable reset). A
**shut-off** node2 must be powered back on from the hypervisor before you grade.

---

## Troubleshooting

- **`controller channel to node2 ... not set up`** — re-run `node-setup` on
  **both** VMs, then re-check Step 2 (from node1, `ssh root@<node2-ip> hostname`
  must work with no password). Re-run `sudo rhcsa-sim doctor`.
- **`peer node2 not reachable`** — the VMs can't see each other. Check they're on
  the same network and `ping 192.168.100.11` works from node1.
- **Storage tasks can't find a disk** — attach a blank spare disk to each VM
  (the real exam provides `/dev/vdb`).
- **Package tasks fail offline** — the DVD isn't mounted as the repo; run
  `sudo rhcsa-sim local-repo` on that VM.
- **node2 won't power on from the browser** — a guest can't start a shut-off peer;
  power it on from your hypervisor (`virsh start node2`).
