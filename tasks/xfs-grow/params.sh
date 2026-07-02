#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "VG=$(rand_choice growvg datavg xfsvg)"
echo "LV=$(rand_choice xfslv vol1 growlv)"
echo "MP=$(rand_choice xfsgrow growmnt biggervol)"
