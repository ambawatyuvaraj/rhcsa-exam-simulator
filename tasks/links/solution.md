# Reference solution — hard and symbolic links

```bash
# Hard link (no -s): shares the same inode as the target
ln /root/linksrc.txt /root/<HL>

# Symbolic (soft) link (-s): a separate file pointing at the path
ln -s /root/linksrc.txt /root/<SL>

ls -li /root/linksrc.txt /root/<HL> /root/<SL>
```

A hard link increases the target's link count and shares its inode; a symbolic
link is a small file containing the path to the target.
