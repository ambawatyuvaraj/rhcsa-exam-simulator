#!/usr/bin/env bash
# lib/nodes.sh — two-node (node1 / node2) support for the RHCSA simulator.
#
# A real RHCSA-style two-system setup: run node-setup on each VM, then each node
# runs its own role-tagged half of a two-node exam. Cross-node tasks reach the
# peer by the names node1.example.com / node2.example.com (written to /etc/hosts).
#
# Node identity is stored in $RHCSA_NODECONF (KEY=VALUE):
#   NODE_ROLE=node1|node2   PEER_ROLE=node2|node1
#   SELF_IP=...             PEER_IP=...

: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
RHCSA_NODECONF="$RHCSA_STATE/node.conf"

node_configured() { [[ -r "$RHCSA_NODECONF" ]]; }

# Load node identity into the environment (no-op if not configured).
load_node_conf() {
  [[ -r "$RHCSA_NODECONF" ]] || return 0
  set -a; . "$RHCSA_NODECONF"; set +a
}

# Best-effort detection of this host's primary IPv4.
_detect_self_ip() {
  local ip
  ip="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')"
  [[ -z "$ip" ]] && ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  echo "$ip"
}

# node_setup --role node1|node2 --peer <peer-ip> [--self <ip>]
# Sets hostname, writes /etc/hosts for both node names, persists node.conf.
node_setup() {
  local role="" peer_ip="" self_ip=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --role) role="$2"; shift 2;;
      --peer) peer_ip="$2"; shift 2;;
      --self) self_ip="$2"; shift 2;;
      *) shift;;
    esac
  done
  [[ "$role" == node1 || "$role" == node2 ]] || { echo "node-setup: --role must be node1 or node2" >&2; return 1; }
  [[ -n "$peer_ip" ]] || { echo "node-setup: --peer <peer-ip> is required" >&2; return 1; }
  [[ -n "$self_ip" ]] || self_ip="$(_detect_self_ip)"
  local peer_role; [[ "$role" == node1 ]] && peer_role=node2 || peer_role=node1

  mkdir -p "$RHCSA_STATE"
  hostnamectl set-hostname "$role.example.com" 2>/dev/null

  # /etc/hosts: refresh the two node entries (hosts-based name resolution — safe,
  # no NIC reconfiguration so SSH/DHCP are never disrupted).
  sed -i -E '/[[:space:]](node1|node2)\.example\.com([[:space:]]|$)/d' /etc/hosts 2>/dev/null
  printf '%s %s.example.com %s\n' "$self_ip" "$role"      "$role"      >> /etc/hosts
  printf '%s %s.example.com %s\n' "$peer_ip" "$peer_role" "$peer_role" >> /etc/hosts

  cat >"$RHCSA_NODECONF" <<EOF
NODE_ROLE=$role
PEER_ROLE=$peer_role
SELF_IP=$self_ip
PEER_IP=$peer_ip
EOF

  # Harden root's SSH directory: the two-node combined report SSHes root->peer,
  # so a wrong SELinux label on authorized_keys (e.g. default_t on a cloned VM)
  # would silently break key auth. Ensure the dir exists, is 700, and carries
  # the ssh_home_t context. Idempotent and safe to run on every node-setup.
  mkdir -p /root/.ssh && chmod 700 /root/.ssh
  [[ -f /root/.ssh/authorized_keys ]] && chmod 600 /root/.ssh/authorized_keys
  command -v restorecon >/dev/null 2>&1 && restorecon -RF /root/.ssh 2>/dev/null || true

  # Guarantee SSH survives the firewall reloads that the server tasks perform:
  # make ssh a PERMANENT firewall rule so a `firewall-cmd --reload` can never
  # drop port 22 (a real risk on cloned VMs where ssh is only a runtime rule).
  if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
    firewall-cmd --permanent --add-service=ssh >/dev/null 2>&1 || true
    firewall-cmd --reload >/dev/null 2>&1 || true
  fi

  ensure_rhcsactl

  echo "node-setup: this host is $role.example.com ($self_ip); peer $peer_role.example.com=$peer_ip"
  echo "  /etc/hosts updated; node.conf written. Now: rhcsa-sim start --role $role <two-node-exam>"
}

# Controller service account. The two-node controller drives the peer over SSH
# for ALL cross-node operations using THIS non-root sudo user instead of root,
# so exam tasks that harden root SSH (PermitRootLogin no) cannot break grading.
# Idempotent; safe to run on every node-setup.
ensure_rhcsactl() {
  id rhcsactl >/dev/null 2>&1 || useradd -m -s /bin/bash rhcsactl 2>/dev/null
  install -d -m 700 -o rhcsactl -g rhcsactl /home/rhcsactl/.ssh 2>/dev/null
  [[ -f /home/rhcsactl/.ssh/id_ed25519 ]] || \
    runuser -u rhcsactl -- ssh-keygen -t ed25519 -N '' -f /home/rhcsactl/.ssh/id_ed25519 -q 2>/dev/null
  touch /home/rhcsactl/.ssh/authorized_keys
  chown -R rhcsactl:rhcsactl /home/rhcsactl/.ssh 2>/dev/null
  chmod 600 /home/rhcsactl/.ssh/authorized_keys 2>/dev/null
  printf 'rhcsactl ALL=(ALL) NOPASSWD: ALL\n' >/etc/sudoers.d/rhcsactl
  chmod 440 /etc/sudoers.d/rhcsactl
  command -v restorecon >/dev/null 2>&1 && restorecon -RF /home/rhcsactl/.ssh 2>/dev/null || true
}

# Install a public key into rhcsactl's authorized_keys (used to grant the peer
# controller passwordless access to this node's rhcsactl).
rhcsactl_authorize() {  # rhcsactl_authorize "<ssh pubkey line>"
  ensure_rhcsactl
  local key="$1"
  [[ -n "$key" ]] || return 1
  grep -qF "$key" /home/rhcsactl/.ssh/authorized_keys 2>/dev/null || \
    printf '%s\n' "$key" >> /home/rhcsactl/.ssh/authorized_keys
  sort -u /home/rhcsactl/.ssh/authorized_keys -o /home/rhcsactl/.ssh/authorized_keys
  chown rhcsactl:rhcsactl /home/rhcsactl/.ssh/authorized_keys
  chmod 600 /home/rhcsactl/.ssh/authorized_keys
  command -v restorecon >/dev/null 2>&1 && restorecon -RF /home/rhcsactl/.ssh 2>/dev/null || true
}

# Read a two-node exam list, returning task ids for a given role.
# File: exams/<name>.2node.list with lines:  node1 <taskid>   |   node2 <taskid>
read_node_exam() {   # read_node_exam <exam-name> <role>
  local f="$RHCSA_EXAMS/$1.2node.list" role="$2"
  [[ -r "$f" ]] || return 1
  grep -vE '^\s*(#|$)' "$f" | awk -v r="$role" '$1==r{print $2}'
}

is_node_exam() { [[ -r "$RHCSA_EXAMS/$1.2node.list" ]]; }
