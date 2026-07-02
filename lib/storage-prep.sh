#!/usr/bin/env bash
# lib/storage-prep.sh — provide a "spare disk" for storage tasks.
# Sourced by storage task setup.sh / teardown.sh.
#
# ensure_spare_disk  -> prints a usable whole block device, persisting choice.
#   Preference: $RHCSA_DISK env > an unused whole disk > a loop-backed image.
# spare_cleanup      -> detach/remove a loop-backed spare (best-effort).
#
# NOTE: each storage task assumes SOLE use of the spare disk. Fixed exams
# include at most one storage task; the 'random' exam picks one per domain.

: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
SPARE_REC="$RHCSA_STATE/spare.dev"
SPARE_IMG="$RHCSA_STATE/disks/spare.img"

_install_loop_unit() {
  cat >/etc/systemd/system/rhcsa-loop.service <<UNIT
[Unit]
Description=RHCSA simulator loop-backed spare disk
DefaultDependencies=no
After=systemd-udev-settle.service
Before=local-fs-pre.target lvm2-activation-early.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/losetup -fP $SPARE_IMG
[Install]
WantedBy=local-fs-pre.target
UNIT
  systemctl daemon-reload 2>/dev/null
  systemctl enable rhcsa-loop.service >/dev/null 2>&1
}

# Per-task disk claims so several storage tasks can each own a distinct disk
# within one exam. RHCSA_TASK_ID is exported by the dispatcher; falls back to a
# single global record for backward compatibility when it is unset.
CLAIMS_DIR="$RHCSA_STATE/claims"
_claim_file() {
  if [[ -n "${RHCSA_TASK_ID:-}" ]]; then echo "$CLAIMS_DIR/$RHCSA_TASK_ID.dev"
  else echo "$SPARE_REC"; fi
}
# Disks currently claimed by OTHER tasks (so we don't hand the same one out twice).
_claimed_disks() { cat "$CLAIMS_DIR"/*.dev 2>/dev/null; }

# Find an unused whole disk: not root, no partitions/children, not mounted, and
# not already claimed by another task this session.
_find_unused_disk() {
  local rootsrc rootdisk name type kids mp claimed
  rootsrc="$(findmnt -no SOURCE / 2>/dev/null)"
  rootdisk="$(lsblk -no PKNAME "$rootsrc" 2>/dev/null | head -1)"
  claimed="$(_claimed_disks)"
  while read -r name type; do
    [[ "$type" == disk ]] || continue
    [[ "$name" == "$rootdisk" ]] && continue
    grep -qx "/dev/$name" <<<"$claimed" && continue
    kids="$(lsblk -no NAME "/dev/$name" 2>/dev/null | wc -l)"
    mp="$(lsblk -rno MOUNTPOINT "/dev/$name" 2>/dev/null | tr -d '[:space:]')"
    if [[ "$kids" -le 1 && -z "$mp" ]]; then echo "/dev/$name"; return 0; fi
  done < <(lsblk -dno NAME,TYPE 2>/dev/null)
  return 1
}

# Wipe a claimed spare disk back to BARE (remove partitions, fs/PV/swap sigs) so
# the next storage task can claim it. Without this, teardown leaves a partition
# behind; after a handful of storage tasks no disk is "bare" anymore and
# _find_unused_disk returns nothing -> later storage tasks can't seed (this is
# why a back-to-back `practice storage` re-run, or a full storage audit, fails).
# Hard guards: never touches a loop device, the root disk, or the 'rhel' VG.
_wipe_spare_disk() {
  local d="$1" rootsrc rootdisk pv vg sz
  [[ -b "$d" ]] || return 0
  case "$d" in /dev/loop*) return 0 ;; esac
  rootsrc="$(findmnt -no SOURCE / 2>/dev/null)"
  rootdisk="$(lsblk -no PKNAME "$rootsrc" 2>/dev/null | head -1)"
  [[ -n "$rootdisk" && "$d" == "/dev/$rootdisk" ]] && return 0
  # Tear down any LVM stack living on the disk or its partitions first.
  for pv in "$d" "$d"[0-9]* "$d"p[0-9]*; do
    [[ -b "$pv" ]] || continue
    vg="$(pvs --noheadings -o vg_name "$pv" 2>/dev/null | tr -d '[:space:]')"
    if [[ -n "$vg" && "$vg" != rhel ]]; then
      vgchange -an "$vg" >/dev/null 2>&1
      vgremove -f "$vg" >/dev/null 2>&1
    fi
    pvremove -ff -y "$pv" >/dev/null 2>&1
  done
  swapoff "$d" "$d"[0-9]* "$d"p[0-9]* 2>/dev/null
  wipefs -af "$d" "$d"[0-9]* "$d"p[0-9]* >/dev/null 2>&1
  dd if=/dev/zero of="$d" bs=1M count=10 >/dev/null 2>&1
  sz="$(blockdev --getsz "$d" 2>/dev/null)"
  [[ -n "$sz" && "$sz" -gt 8192 ]] && dd if=/dev/zero of="$d" bs=512 seek=$((sz-8192)) count=8192 >/dev/null 2>&1
  partprobe "$d" >/dev/null 2>&1
  return 0
}

ensure_spare_disk() {
  mkdir -p "$RHCSA_STATE/disks" "$CLAIMS_DIR"
  local rec; rec="$(_claim_file)"
  # 1) reuse this task's previously claimed REAL device
  if [[ -f "$rec" ]]; then
    local d; d="$(cat "$rec")"
    [[ -b "$d" ]] && { echo "$d"; return 0; }
  fi
  # 2) explicit override (only honoured if not already claimed by another task)
  if [[ -n "${RHCSA_DISK:-}" && -b "${RHCSA_DISK}" ]] && ! grep -qx "$RHCSA_DISK" <<<"$(_claimed_disks)"; then
    echo "$RHCSA_DISK" >"$rec"; echo "$RHCSA_DISK"; return 0
  fi
  # 3) an unused whole disk — the real-exam scenario (e.g. /dev/vdb). Boot-safe.
  local real; if real="$(_find_unused_disk)"; then
    echo "$real" >"$rec"; echo "$real"; return 0
  fi
  # 4) OPT-IN loop fallback. NOT reboot-safe: an fstab mount on a loop-backed
  #    LV can drop the system to emergency mode at boot (the device isn't ready
  #    before local-fs.target). Only used when the user explicitly accepts this
  #    by setting RHCSA_ALLOW_LOOP=1.
  if [[ "${RHCSA_ALLOW_LOOP:-0}" == "1" ]]; then
    [[ -f "$SPARE_IMG" ]] || fallocate -l 2G "$SPARE_IMG" 2>/dev/null || \
      dd if=/dev/zero of="$SPARE_IMG" bs=1M count=2048 status=none 2>/dev/null
    local dev; dev="$(losetup -fP --show "$SPARE_IMG" 2>/dev/null)"
    if [[ -n "$dev" ]]; then
      echo "$dev" >"$rec"; _install_loop_unit; echo "$dev"; return 0
    fi
  fi
  # No spare disk available.
  cat >&2 <<MSG
[storage] No unused spare disk found.
  RHCSA storage tasks need a blank second disk (the real exam provides /dev/vdb).
  Attach one to this VM, e.g. from the hypervisor host:

    qemu-img create -f qcow2 /var/lib/libvirt/images/<vm>-spare.qcow2 3G
    virsh attach-disk <vm> /var/lib/libvirt/images/<vm>-spare.qcow2 vdb \\
          --subdriver qcow2 --targetbus virtio --persistent

  Then re-run 'rhcsa-sim start'. (Advanced/last resort, NOT reboot-safe:
  export RHCSA_ALLOW_LOOP=1 to use a loop-backed image instead.)
MSG
  return 1
}

# Claim ONE disk shared by a GROUP of tasks — e.g. a swap partition AND an LVM
# partition on the SAME disk (like /dev/vdb part3=swap + part2=LVM in some exam
# papers). Every task calling this with the same GROUP gets the SAME disk; the
# candidate then creates separate partitions on it. The shared record is a *.dev
# claim under CLAIMS_DIR, so reset/start deep-clean wipes the disk + drops it.
ensure_shared_disk() {
  local group="${1:?ensure_shared_disk: group name required}"
  mkdir -p "$CLAIMS_DIR"
  local rec="$CLAIMS_DIR/shared-$group.dev"
  if [[ -s "$rec" ]]; then local d; d="$(cat "$rec")"; [[ -b "$d" ]] && { echo "$d"; return 0; }; fi
  local d; d="$(_find_unused_disk)" || return 1
  echo "$d" >"$rec"; echo "$d"; return 0
}
shared_cleanup() {   # $1=group : wipe the shared disk back to bare + drop the claim
  local group="${1:?shared_cleanup: group required}"; local rec="$CLAIMS_DIR/shared-$group.dev"
  [[ -s "$rec" ]] && _wipe_spare_disk "$(cat "$rec")"
  rm -f "$rec" 2>/dev/null
}

spare_cleanup() {
  local rec; rec="$(_claim_file)"
  if [[ -f "$rec" ]]; then
    local d; d="$(cat "$rec")"
    case "$d" in
      /dev/loop*) losetup -d "$d" 2>/dev/null ;;
      *) _wipe_spare_disk "$d" ;;   # return the real disk to bare for reuse
    esac
  fi
  rm -f "$rec" 2>/dev/null
  # Only tear down the loop image/unit when no claims remain.
  if [[ -z "$(_claimed_disks)" ]]; then
    systemctl disable --now rhcsa-loop.service 2>/dev/null
    rm -f /etc/systemd/system/rhcsa-loop.service 2>/dev/null
    systemctl daemon-reload 2>/dev/null
    rm -f "$SPARE_IMG" 2>/dev/null
  fi
}
