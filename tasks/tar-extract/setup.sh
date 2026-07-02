#!/usr/bin/env bash
src="/tmp/_src_$ARC"
rm -rf "$src" "$DEST" "/root/$ARC.tar.gz"
mkdir -p "$src"
echo "alpha content"   > "$src/file1"
echo "beta content"    > "$src/file2"
echo "gamma content"   > "$src/file3"
tar czf "/root/$ARC.tar.gz" -C "$src" .
rm -rf "$src"
echo "tar-extract: created /root/$ARC.tar.gz (file1,file2,file3); dest $DEST removed"
exit 0
