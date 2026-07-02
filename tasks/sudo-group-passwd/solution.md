# Reference solution — full sudo for a group (password required)

```bash
echo '%<G> ALL=(ALL) ALL' >/etc/sudoers.d/<G>
chmod 0440 /etc/sudoers.d/<G>
visudo -c        # validate syntax
```

Notes:
- Do NOT add `NOPASSWD:` — the task requires a password prompt.
- `%<G>` applies the rule to all members of group `<G>`.
