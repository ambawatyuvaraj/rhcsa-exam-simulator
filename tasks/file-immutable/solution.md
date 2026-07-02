# Reference solution — immutable file

```bash
chattr +i /root/<F>

# Verify:
lsattr /root/<F>      # shows ----i---------e-- (the 'i' flag)
```

To later allow changes: `chattr -i /root/<F>`.
