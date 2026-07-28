#!/usr/bin/env bash
# install.sh — install the RHCSA simulator on a (disposable) RHEL 9 family host.
#
#   sudo ./install.sh            # install to /opt/rhcsa-sim + /usr/local/bin
#   sudo ./install.sh --no-deps  # skip dnf package installation
#   sudo ./install.sh --uninstall
set -euo pipefail

PREFIX=/opt/rhcsa-sim
BINLINK=/usr/local/bin/rhcsa-sim
# Also link into /usr/sbin: it is in sudo's default secure_path on every image,
# whereas /usr/local/bin is NOT on some minimal installs — so `sudo rhcsa-sim`
# works regardless. (rhcsa-sim requires root, so /usr/sbin is the right home.)
BINLINK2=/usr/sbin/rhcsa-sim
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

red(){ printf '\e[31m%s\e[0m\n' "$*"; }
grn(){ printf '\e[32m%s\e[0m\n' "$*"; }
yel(){ printf '\e[33m%s\e[0m\n' "$*"; }
inf(){ printf '\e[34m[*]\e[0m %s\n' "$*"; }

[[ ${EUID:-$(id -u)} -eq 0 ]] || { red "Run as root: sudo ./install.sh"; exit 1; }

if [[ "${1:-}" == "--uninstall" ]]; then
  inf "Uninstalling ..."
  rm -f "$BINLINK" "$BINLINK2"
  rm -rf "$PREFIX"
  yel "Left /var/lib/rhcsa-sim (state/reports) in place. Remove manually if desired."
  grn "Uninstalled."
  exit 0
fi

# ---- OS check + which RHCSA the exam content targets ------------------------
# Auto-detected, never asked: RHEL 10 -> RHCSA 10 content, RHEL 9.x -> RHCSA 9.
# Force with:  RHCSA_RHEL=10 ./install.sh
RHCSA_RHEL="${RHCSA_RHEL:-}"
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  case "${ID:-} ${ID_LIKE:-}" in
    *rhel*|*centos*|rocky*|almalinux*) :;;
    *) yel "WARNING: ${PRETTY_NAME:-unknown} is not a RHEL family release. Tasks assume RHEL 9/10.";;
  esac
  case "${VERSION_ID%%.*}" in
    10) : "${RHCSA_RHEL:=10}";;
    9)  : "${RHCSA_RHEL:=9}";;
    *)  : "${RHCSA_RHEL:=9}"
        yel "WARNING: version ${VERSION_ID:-?} is neither 9 nor 10 — installing the RHCSA $RHCSA_RHEL content set.";;
  esac
fi
: "${RHCSA_RHEL:=9}"
export RHCSA_RHEL
grn "Detected ${PRETTY_NAME:-unknown} -> installing the RHCSA ${RHCSA_RHEL} content set."
if command -v systemd-detect-virt >/dev/null 2>&1; then
  v="$(systemd-detect-virt || true)"
  [[ -n "$v" && "$v" != none ]] || yel "WARNING: could not confirm a VM. Use a DISPOSABLE machine — tasks are destructive."
fi

# ---- Dependencies ----------------------------------------------------------
DEPS=(python3 podman lvm2 nfs-utils autofs chrony httpd tuned acl \
      policycoreutils-python-utils firewalld createrepo_c util-linux parted \
      firefox xdg-utils)   # firefox + xdg-open: the browser exam view ('rhcsa-sim tui')
# Make dnf fail FAST on slow/unreachable mirrors BEFORE installing deps, so a bad
# default repo can't stall the install before the code is even deployed. Idempotent.
if [[ -f /etc/dnf/dnf.conf ]] && ! grep -q '^timeout=' /etc/dnf/dnf.conf; then
  { echo 'timeout=20'; echo 'retries=1'; echo 'minrate=100'; echo 'ip_resolve=4'; } >> /etc/dnf/dnf.conf
fi
if [[ "${1:-}" != "--no-deps" ]]; then
  if command -v dnf >/dev/null 2>&1; then
    inf "Installing dependencies via dnf (best-effort; the local-repo step below installs the core set)..."
    timeout 300 dnf -y install "${DEPS[@]}" 2>/dev/null \
      || yel "Some packages not installed now (offline/slow repo?) — local-repo installs the core set. Continuing."
  else
    yel "dnf not found; skipping dependency installation."
  fi
fi
systemctl enable --now firewalld >/dev/null 2>&1 || true

# ---- Copy files ------------------------------------------------------------
inf "Installing to $PREFIX ..."
mkdir -p "$PREFIX"
cp -a "$SRC"/{bin,lib,tui,report,exams,tasks,assets} "$PREFIX"/ 2>/dev/null || true
for d in README.md PRACTICE.md; do [[ -f "$SRC/$d" ]] && cp -a "$SRC/$d" "$PREFIX"/ || true; done
chmod +x "$PREFIX/bin/rhcsa-sim" "$PREFIX/bin/rhcsa-autoview" 2>/dev/null || true

ln -sf "$PREFIX/bin/rhcsa-sim" "$BINLINK"
ln -sf "$PREFIX/bin/rhcsa-sim" "$BINLINK2"
mkdir -p /var/lib/rhcsa-sim/{results,reports,disks}
chmod 755 /var/lib/rhcsa-sim 2>/dev/null || true   # student must read report.html/flag

# Browser exam report auto-opens after a reboot-grade: a GNOME autostart in the
# student's session runs rhcsa-autoview, which opens report.html once per grade.
if id student >/dev/null 2>&1; then
  shome="$(getent passwd student | cut -d: -f6)"
  if [[ -n "$shome" ]]; then
    install -d -o student -g student "$shome/.config/autostart" 2>/dev/null || true
    cat > "$shome/.config/autostart/rhcsa-report.desktop" <<DESK
[Desktop Entry]
Type=Application
Name=RHCSA Exam Report
Comment=Open the exam report in the browser after a reboot-grade
Exec=bash $PREFIX/bin/rhcsa-autoview
X-GNOME-Autostart-enabled=true
NoDisplay=true
DESK
    chown student:student "$shome/.config/autostart/rhcsa-report.desktop" 2>/dev/null || true
  fi
fi

# Make dnf FAIL FAST instead of hanging when a mirror is slow/down — otherwise a
# single unreachable mirror would block a whole exam seed (many task setups
# dnf-install packages). Best-effort; tasks that can't install then fail
# gracefully (their `|| true`) instead of hanging forever.
if [[ -f /etc/dnf/dnf.conf ]] && ! grep -q '^timeout=' /etc/dnf/dnf.conf; then
  { echo 'timeout=20'; echo 'retries=1'; echo 'minrate=100'; echo 'ip_resolve=4'; } >> /etc/dnf/dnf.conf
fi

# Fix SELinux labels: files copied from the build location (e.g. /root) keep a
# context that systemd cannot exec from. Relabel the install tree to its
# /opt defaults so post-reboot grading and any systemd exec works.
#
# Also self-heal SSH home contexts: an .ssh/authorized_keys that carries the
# wrong type (default_t / user_home_dir_t instead of ssh_home_t — common on
# cloned/imaged VMs or files moved in from /tmp) makes sshd silently reject the
# key, breaking key-based login and the two-node combined report. Relabelling
# here means a fresh deploy fixes it once and it stays fixed across reboots.
if command -v restorecon >/dev/null 2>&1; then
  restorecon -RF "$PREFIX" 2>/dev/null || true
  for d in /root/.ssh /home/*/.ssh; do
    [[ -d "$d" ]] && restorecon -RF "$d" 2>/dev/null || true
  done
fi

# Guarantee SSH stays reachable. Several tasks (nfs-export, repo-server,
# ntp-server, firewall-*) run `firewall-cmd --reload`. If ssh is only a RUNTIME
# rule (not in the permanent config — true on some cloned/imaged VMs), the first
# reload drops it and locks the admin out of port 22. Make ssh PERMANENT once so
# every later reload is safe. Idempotent.
if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
  firewall-cmd --permanent --add-service=ssh >/dev/null 2>&1 || true
  firewall-cmd --reload >/dev/null 2>&1 || true
fi

# ---- Build the container image asset (best-effort) -------------------------
if command -v podman >/dev/null 2>&1 && [[ ! -f "$PREFIX/assets/rhcsa-app.tar" ]]; then
  inf "Building container image asset (localhost/rhcsa-app:latest)..."
  bdir="$(mktemp -d)"
  # Match the base image to the host release (ubi10 on RHEL 10) so the image the
  # container tasks run is the one the candidate would actually pull.
  cat >"$bdir/Containerfile" <<CF
FROM registry.access.redhat.com/ubi${RHCSA_RHEL}/ubi-minimal
CMD ["sleep", "infinity"]
CF
  if podman build -t localhost/rhcsa-app:latest "$bdir" >/dev/null 2>&1; then
    podman save -o "$PREFIX/assets/rhcsa-app.tar" localhost/rhcsa-app:latest >/dev/null 2>&1 \
      && grn "Container image asset saved." \
      || yel "Could not save image asset (the container task has a fallback)."
  else
    yel "Could not build image asset (offline / no base image). The container task has a fallback."
  fi
  rm -rf "$bdir"
fi

# ---- Offline DVD repo (real-exam model) + boot-mount service ----------------
# Configure it now if install media is attached, so offline package tasks work
# out of the box AND the boot-mount service is installed (keeps the repo mounted
# across the reboots students do to verify persistence). Idempotent.
if [[ -b /dev/sr0 ]] || lsblk -rno FSTYPE 2>/dev/null | grep -q iso9660; then
  inf "Install media detected — configuring the offline DVD repo + boot-mount service ..."
  "$PREFIX/bin/rhcsa-sim" local-repo >/dev/null 2>&1 \
    && grn "Offline DVD repo configured (survives reboot)." \
    || yel "Could not configure the DVD repo automatically — attach the ISO and run: rhcsa-sim local-repo"
else
  yel "No install DVD detected. Attach your distro's DVD ISO as a CD-ROM, then run: rhcsa-sim local-repo"
fi

grn "Installed. First, verify the environment:"
echo "    rhcsa-sim doctor              # preflight: SELinux, firewall, repos, spare disk, (peer)"
echo "    rhcsa-sim local-repo          # offline DVD repo + boot-mount service (if not auto-configured above)"
echo "  Note: 'practice storage' seeds one task per blank spare disk (reboot-safe);"
echo "        attach more spare disks to the VM for more storage tasks per session."
echo "  then:"
echo "    rhcsa-sim list"
echo "    rhcsa-sim start exam-01        # or: rhcsa-sim start random"
echo "    rhcsa-sim grade --reboot"
echo "    rhcsa-sim report --html"
echo
echo "  Two-node exams: install on TWO INDEPENDENT VMs (don't clone one that has"
echo "  already run an exam), then 'rhcsa-sim node-setup --role node1 --peer <ip>'"
echo "  on one and '--role node2 --peer <ip>' on the other, exchange root SSH keys,"
echo "  and run 'rhcsa-sim doctor' on each before starting."

# Final preflight so a fresh setup surfaces any remaining problem immediately.
if [[ "${RHCSA_SKIP_DOCTOR:-0}" != 1 ]]; then
  echo; "$PREFIX/bin/rhcsa-sim" doctor || yel "Address the doctor problems above before starting an exam."
fi
