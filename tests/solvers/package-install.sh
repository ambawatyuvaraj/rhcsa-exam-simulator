#!/usr/bin/env bash
# Install the requested package.
rpm -q "$PKG" >/dev/null 2>&1 || dnf install -y "$PKG" >/dev/null 2>&1
