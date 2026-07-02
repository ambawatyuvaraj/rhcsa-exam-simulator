#!/usr/bin/env bash
# Extract the gzip tar into $DEST.
mkdir -p "$DEST"
tar xzf "/root/$ARC.tar.gz" -C "$DEST"
