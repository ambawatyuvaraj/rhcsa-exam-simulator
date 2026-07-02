#!/usr/bin/env bash
lvextend -r -L 512M "/dev/$VG/$LV" >/dev/null 2>&1
