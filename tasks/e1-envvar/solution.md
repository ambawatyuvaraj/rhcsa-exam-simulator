# Reference solution — set and export a per-user environment variable

Add the assignment and an `export` to alies's login profile, `~/.bash_profile`,
so the variable is defined and exported every time alies logs in.

```bash
id alies 2>/dev/null || useradd -u 1326 alies

cat >> /home/alies/.bash_profile <<'EOF'
RHCSA="Welcome to Advantage Pro"
export RHCSA
EOF
chown alies:alies /home/alies/.bash_profile

runuser -l alies -c 'echo $RHCSA'    # verify -> Welcome to Advantage Pro
```

You can also write it on one line: `export RHCSA="Welcome to Advantage Pro"`.
