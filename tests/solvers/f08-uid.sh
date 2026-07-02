#!/usr/bin/env bash
id jean >/dev/null 2>&1 || useradd -u 4332 jean
echo ratencot | passwd --stdin jean >/dev/null 2>&1
