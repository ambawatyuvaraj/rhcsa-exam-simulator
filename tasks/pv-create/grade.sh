#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Disk-agnostic: accept the PV on whichever spare the candidate used. Require a VG-LESS
# spare-disk partition PV (the task says NOT to create a VG) so this does not falsely match
# a PV that another LVM task placed into a volume group.
_spare_pv_no_vg() {
  local pv vg
  while read -r pv vg; do
    case "$pv" in
      /dev/vd[b-z]*[0-9]|/dev/sd[b-z]*[0-9]|/dev/nvme*p[0-9]*) ;;
      *) continue ;;
    esac
    [ -z "$vg" ] && return 0
  done < <(pvs --noheadings -o pv_name,vg_name 2>/dev/null)
  return 1
}
ckpt_expr "a spare-disk partition is a VG-less LVM physical volume" 8 '_spare_pv_no_vg'
