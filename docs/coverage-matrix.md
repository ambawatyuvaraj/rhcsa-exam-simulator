# RHCSA EX200 objective → task coverage matrix

Legend: ✅ existing task (UNCHANGED) · ➕ new task to add · (param) = parameterized per run

NOTE: the existing 22 tasks are FROZEN — left exactly as validated (300/300).
Parameterization is opt-in (a task only uses it if it ships a `params.sh`), so the
"(param)" annotations below apply ONLY to the new ➕ tasks, never to existing ✅ ones.

## Understand and use essential tools
- redirection (>, >>, |, 2>) ➕ `redirect-streams` (param: words/paths)
- grep + regex ✅ `grep-string` (param: string/file) · ➕ `grep-regex`
- ssh remote / switch users — covered operationally; key-based in security
- tar/gzip/bzip2/xz ✅ `tar-archive` (param: src/format) · ➕ `tar-extract`
- create/edit/cp/mv/rm files ➕ `file-ops`
- hard & soft links ➕ `links`
- ugo/rwx permissions ➕ `permissions-basic` (param)
- man/info/doc — not graded (allowed during exam)

## Create simple shell scripts
- suid/size finder ✅ `script-finder` (param: size/perm)
- if/test conditional ➕ `script-conditional`
- for/while loop ➕ `script-loop`
- positional args $1/$2 ➕ `script-args`

## Operate running systems
- boot targets ✅ `boot-target` (param: target)
- interrupt boot / reset root pw ✅ `root-password` (param: pw)
- kill CPU/mem intensive process ➕ `kill-process`
- process scheduling nice/renice ➕ `process-nice`
- tuning profiles ✅ `tuning-profile`
- logs/journals ➕ `journal-find`
- preserve journals (persistent) ➕ `journald-persistent`
- start/stop/enable services ➕ `service-enable` (param: service)
- secure file transfer scp/rsync ➕ `secure-copy`

## Configure local storage
- partitions MBR/GPT ➕ `partition-create` (param: size/type)
- pv/vg/lv ✅ `lvm-create` (param: pe/extents/fs/mount)
- mount by UUID/label ➕ `mount-uuid`
- swap non-destructive ✅ `swap-partition` (param: size)

## Create and configure file systems
- vfat/ext4/xfs ✅ `lvm-create` · ➕ `mkfs-ext4`, `mkfs-xfs`
- NFS mount ➕ `nfs-mount`
- autofs ✅ `autofs-nfs` (param: user/path)
- extend LV ✅ `lvm-resize` (param: size) · ➕ `lvm-extend`
- set-GID collab dir ✅ `collaborative-dir` (param: group/dir)
- diagnose/correct permissions ➕ `fix-permissions`

## Deploy, configure, and maintain systems
- at & cron ✅ `cron-job` (param: schedule/cmd/user) · ➕ `at-job`
- services autostart — `service-enable`
- boot into specific target ✅ `boot-target`
- time service client ✅ `chrony-ntp` (param: server)
- install/update packages ➕ `package-install`
- modify bootloader ➕ `grub-config`

## Manage basic networking
- IPv4/IPv6 ✅ `network-config` (param: ip/gw/dns) · ➕ `network-ipv6`
- hostname resolution ➕ `hosts-entry`
- firewall ➕ `firewall-service`, `firewall-port`

## Manage users and groups
- create/delete/modify ✅ `users-groups`, `user-uid` (param: names/uid)
- password aging ➕ `password-aging` (param: days/user)
- groups/memberships ✅ `users-groups`
- superuser/sudo ✅ `sudo-nopasswd` (param: group)

## Manage security
- firewall ➕ `firewall-port`
- default file permissions / umask ➕ `umask-default` (param: perms/user)
- key-based SSH ➕ `ssh-keyauth`
- SELinux enforce/permissive ➕ `selinux-mode`
- list/identify context ➕ (covered) `selinux-fcontext`
- restore default contexts ➕ `selinux-restorecon`
- SELinux port labels ✅ `selinux-port` (param: port)
- SELinux booleans ➕ `selinux-boolean`
- diagnose SELinux violations ✅ `selinux-port`

## Manage containers
- find/pull image ➕ `container-pull`
- inspect image ➕ `container-inspect`
- build from Containerfile ➕ `container-build`
- run/start/stop/list ➕ `container-run`
- service in container / systemd ✅ `container-service` (param: name/dirs)
- persistent storage ✅ `container-service`
- ports / env vars ➕ `container-port-env`

Parameterization multiplies each (param) template into many concrete instances,
so the `random` exam draws unseen combinations every run.
