# RHCSA simulator — master task catalog (target: 200 distinct tasks)

Distinctness contract: every entry is a DIFFERENT scenario/objective — not a
parameter variant of another. `[HAVE]` = already built & validated. `[NEW]` = to
build. Before adding any task, check it is not a near-duplicate of one here.

## tools (24)
1. [HAVE] find-files — find files owned by a user, copy them
2. [HAVE] grep-string — copy literal-match lines to a file
3. [HAVE] grep-regex — copy ERE-match lines from /etc/passwd
4. [HAVE] tar-archive — gzip tar of /etc
5. [HAVE] tar-extract — extract a gzip archive to a dir
6. [HAVE] redirect-streams — append stdout, redirect stderr to files
7. [HAVE] file-ops — mkdir tree + create + copy files
8. [HAVE] links — make one hard link + one soft link
9. [HAVE] permissions-basic — set octal mode/owner on a file
10. [NEW] find-perm — find files under a dir with an exact permission, copy them
11. [NEW] find-size — find files within a size range, write paths to a file
12. [NEW] find-mtime — find files modified within N days, copy them
13. [NEW] find-name-type — find by name glob + type (f/d), write list
14. [NEW] tar-bzip2 — bzip2-compressed tar of a directory
15. [NEW] tar-xz — xz-compressed tar of a directory
16. [NEW] grep-count — write the COUNT of matching lines to a file
17. [NEW] grep-invert — write NON-matching lines to a file
18. [NEW] grep-context — write matches plus N lines of context to a file
19. [NEW] sed-replace — substitute a string throughout a copied file
20. [NEW] cut-fields — extract given colon-separated fields to a file
21. [NEW] sort-numeric — numerically sort a data file into a new file
22. [NEW] uniq-count — collapse + count duplicate lines into a file
23. [NEW] tr-transform — translate case/delete chars into a file
24. [NEW] head-tail-range — extract a specific line range to a file

## scripting (15)
25. [HAVE] script-finder — SUID/size finder script
26. [HAVE] script-conditional — if/else on numeric arg
27. [HAVE] script-loop — for-loop creating N files
28. [HAVE] script-args — echo positional args
29. [NEW] script-case — case statement branching on $1
30. [NEW] script-while-read — read a file line-by-line and act
31. [NEW] script-function — define and call a shell function
32. [NEW] script-exitstatus — branch on a command's exit status
33. [NEW] script-arith — arithmetic on two numeric args
34. [NEW] script-argcount — error+usage if wrong arg count
35. [NEW] script-userexists — report whether a given user exists
36. [NEW] script-filetest — report a path's type/permission via test
37. [NEW] script-sumloop — sum 1..N with a loop, print total
38. [NEW] script-readstdin — read a line from stdin and transform it
39. [NEW] script-backupdir — script that tars a directory passed as $1

## operate (25)
40. [HAVE] tuning-profile — apply the recommended tuned profile
41. [HAVE] root-password — reset the root password
42. [HAVE] boot-target — default boot to multi-user
43. [HAVE] kill-process — terminate a runaway process
44. [HAVE] process-nice — start a process at a given nice value
45. [HAVE] journald-persistent — make the journal persistent
46. [HAVE] journal-find — save a unit's journal to a file
47. [HAVE] service-enable — enable+start a service
48. [HAVE] secure-copy — securely copy a file locally
49. [NEW] service-disable — stop+disable a running service
50. [NEW] service-mask — mask a service so it cannot start
51. [NEW] service-restart — restart a service and confirm active
52. [NEW] default-target-graphical — set default target to graphical
53. [NEW] renice-running — renice an already-running process to N
54. [NEW] journal-priority — save err-priority journal entries to a file
55. [NEW] journal-grep — save journal lines matching a string to a file
56. [NEW] journal-vacuum — cap on-disk journal size (vacuum)
57. [NEW] tuned-specific — set a SPECIFIC named tuned profile (not recommended)
58. [NEW] scp-pull — pull a remote (localhost) file to a path via scp
59. [NEW] rsync-dir — sync a directory tree with rsync
60. [NEW] cpu-hog-find — record the top CPU-consuming process name
61. [NEW] mem-hog-find — record the top memory-consuming process name
62. [NEW] failed-units — write the list of failed systemd units to a file
63. [NEW] sysctl-set — set & persist a kernel parameter (sysctl)
64. [NEW] hostname-set — set the static hostname (no networking change)
65. [NEW] crash-kdump? -> replaced: list-timers — save enabled systemd timers to a file
## storage (20)
66. [HAVE] swap-partition — add a 512MiB swap partition
67. [HAVE] lvm-create — VG(16MiB PE)+LV(50 extents)+vfat+mount
68. [HAVE] lvm-resize — shrink/grow vo to 300MiB
69. [HAVE] partition-create — partition+ext4+persistent mount
70. [NEW] partition-mbr — create a partition on an MBR/msdos-labelled disk
71. [NEW] two-partitions — create two primary partitions of given sizes
72. [NEW] swap-by-label — add swap referenced by LABEL in fstab
73. [NEW] swap-priority — add swap with a specific priority (pri=)
74. [NEW] pv-create — create a physical volume on a partition
75. [NEW] vg-extend — extend a VG by adding a second PV
76. [NEW] lv-create-bysize — create an LV sized by -L (MiB), xfs
77. [NEW] lv-rename — rename an existing logical volume
78. [NEW] lv-reduce — shrink an ext4 LV safely to a smaller size
79. [NEW] lv-snapshot — create an LVM snapshot of an existing LV
80. [NEW] vdo? -> replaced: pv-move — move data off one PV (pvmove) then remove it
81. [NEW] stratis-pool? -> replaced: partition-resize — grow a partition + fs
82. [NEW] gpt-name — create a GPT partition with a partition name/label
83. [NEW] align-partition? -> replaced: swap-uuid — swap referenced by UUID
84. [NEW] vg-pe-size — create a VG with a non-default PE size and verify
85. [NEW] lv-fs-xfs-mount — LV formatted xfs, mounted by UUID persistently

## filesystems (25)
86. [HAVE] autofs-nfs — automount an NFS home with autofs
87. [HAVE] nfs-mount — persistent NFS mount via fstab
88. [HAVE] mount-uuid — mount an existing fs by UUID
89. [HAVE] mkfs-xfs — make+mount XFS persistently
90. [HAVE] mkfs-ext4-label — ext4 with LABEL, mount by LABEL
91. [HAVE] lvm-extend — grow an LV+fs to a target size
92. [HAVE] collaborative-dir — set-GID collaborative directory
93. [HAVE] fix-permissions — repair a file's mode/owner
94. [NEW] mount-iso — loop-mount an ISO image persistently
95. [NEW] bind-mount — create a persistent bind mount
96. [NEW] xfs-grow — grow a mounted XFS filesystem (xfs_growfs)
97. [NEW] ext4-tune — set an ext4 filesystem label/reserved blocks
98. [NEW] autofs-indirect — autofs indirect map for multiple users
99. [NEW] autofs-direct — autofs direct map for a single mountpoint
100. [NEW] nfs-readonly — mount an NFS export read-only persistently
101. [NEW] fstab-nofail — add a resilient fstab entry (nofail) and mount
102. [NEW] sticky-dir — create a world-writable directory with the sticky bit
103. [NEW] setgid-existing — add set-GID to an existing shared directory
104. [NEW] acl-default — set DEFAULT ACLs on a directory (inheritance)
105. [NEW] acl-mask — adjust the ACL mask on a file
106. [NEW] acl-remove — remove a named ACL entry from a file
107. [NEW] diagnose-perms — fix a directory a user cannot access (perm bug)
108. [NEW] swap-file — add a swap FILE (not partition), persistent
109. [NEW] tmpfs-mount — mount a tmpfs of a given size persistently
110. [NEW] remount-options — remount a filesystem with new options
111. [NEW] label-fs — set a filesystem label and mount by it
112. [NEW] find-mountpoint — record a path's filesystem/mountpoint to a file
113. [NEW] disk-usage — write directory disk usage report (du) to a file

## deploy (25)
114. [HAVE] repo-config — configure the two default local repos
115. [HAVE] repo-add — add one extra local repo
116. [HAVE] cron-job — recurring cron job (every 3 min)
117. [HAVE] chrony-ntp — chrony NTP client
118. [HAVE] at-job — one-time at job
119. [HAVE] grub-timeout — set GRUB timeout + regenerate
120. [HAVE] timezone — set the system time zone
121. [HAVE] package-install — install a package
122. [NEW] cron-daily-time — cron job at a specific HH:MM daily
123. [NEW] cron-weekday — cron job on specific weekdays
124. [NEW] cron-deny — deny cron for a user via cron.deny
125. [NEW] cron-systemwide — add a job in /etc/cron.d
126. [NEW] package-remove — remove a specific package
127. [NEW] package-group — install a package group
128. [NEW] package-update-one — update a single package to latest
129. [NEW] package-version — install a specific package version
130. [NEW] dnf-module? -> replaced: package-info — write a package's info to a file
131. [NEW] grub-kernelarg — add a persistent kernel boot argument
132. [NEW] grub-default-kernel — set the default boot kernel/index
133. [NEW] chrony-makestep — configure chrony with makestep/iburst options
134. [NEW] timedatectl-ntp — enable NTP synchronization via timedatectl
135. [NEW] localectl-keymap — set the console keymap
136. [NEW] localectl-locale — set the system locale
137. [NEW] enable-service-boot — enable a service for boot WITHOUT starting now
138. [NEW] systemd-timer — create a systemd timer + unit that runs a job
139. [NEW] crontab-list-deny — verify/deny at access (at.deny)

## network (16)
140. [HAVE] network-config — static IPv4 + hostname on a spare NIC
141. [HAVE] network-ipv6 — static IPv6 on a spare NIC
142. [HAVE] hosts-entry — /etc/hosts static resolution
143. [HAVE] firewall-port — open a TCP port permanently
144. [HAVE] firewall-service — allow a service permanently
145. [NEW] network-dns — set DNS servers on a connection
146. [NEW] network-route — add a static route on a connection
147. [NEW] network-secondary-ip — add a second IPv4 address to a connection
148. [NEW] network-gateway — set the default gateway on a connection
149. [NEW] firewall-richrule — add a firewalld rich rule (source-based)
150. [NEW] firewall-zone — assign an interface to a firewalld zone
151. [NEW] firewall-portforward — configure a port-forward/masquerade
152. [NEW] firewall-remove — remove an existing allowed service
153. [NEW] nmcli-autoconnect — set a connection to NOT autoconnect
154. [NEW] hostname-pretty — set a transient/pretty hostname
155. [NEW] resolv-search — set a DNS search domain on a connection

## users (20)
156. [HAVE] users-groups — group + secondary members + nologin user
157. [HAVE] user-uid — user with a specific UID
158. [HAVE] sudo-nopasswd — passwordless sudo for a group
159. [HAVE] acl-permissions — user/named ACLs on a file
160. [HAVE] password-aging — set max password age
161. [NEW] user-create-comment — create a user with a GECOS comment
162. [NEW] user-shell-change — change a user's login shell
163. [NEW] user-home-custom — create a user with a non-default home dir
164. [NEW] user-lock — lock (disable) a user account
165. [NEW] user-expire-date — set an account expiry date
166. [NEW] user-supplementary — add an existing user to supplementary groups
167. [NEW] user-primary-group — change a user's primary group
168. [NEW] user-delete-keep? -> replaced: user-delete — delete a user and their home
169. [NEW] group-gid — create a group with a specific GID
170. [NEW] password-minage — set minimum password age + warning days
171. [NEW] password-force-change — force a user to change password at next login
172. [NEW] sudo-user-cmd — grant a user sudo for ONE specific command
173. [NEW] sudo-group-passwd — grant a group full sudo (WITH password)
174. [NEW] skel-file — add a file to /etc/skel so new users get it
175. [NEW] umask-systemwide — set the system-wide default umask

## security (20)
176. [HAVE] selinux-port — allow httpd on a non-standard port (debug)
177. [HAVE] selinux-boolean — enable a SELinux boolean persistently
178. [HAVE] selinux-mode — set SELinux enforcing (now + persistent)
179. [HAVE] selinux-restorecon — restore a file's default context
180. [HAVE] selinux-fcontext — add a persistent fcontext rule + relabel
181. [HAVE] umask-default — per-user default umask
182. [HAVE] ssh-keyauth — key-based SSH for a user
183. [NEW] selinux-permissive — set SELinux to permissive (now + persistent)
184. [NEW] selinux-boolean-off — disable a SELinux boolean persistently
185. [NEW] selinux-fcontext-equal — fcontext equivalence (semanage fcontext -e)
186. [NEW] selinux-context-copy — preserve/cp -Z a correct context to a file
187. [NEW] selinux-user-map — map a Linux user to an SELinux user
188. [NEW] ssh-disable-root — disable SSH root login (sshd_config)
189. [NEW] ssh-port — change the sshd listening port (+SELinux port)
190. [NEW] sudo-defaults — set a sudoers Defaults option (e.g., timestamp)
191. [NEW] file-immutable — set the immutable attribute on a file (chattr)
192. [NEW] gpg-verify? -> replaced: setgid-binary — set the SUID/SGID bit on a binary copy
193. [NEW] firewalld-panic? -> replaced: pam-faillock — view/clear account lockout (faillock)
194. [NEW] password-hash — set a user's password from a known value & verify
195. [NEW] restrict-su — restrict su to a wheel group (pam)

## containers (11)
196. [HAVE] container-service — rootless container as a systemd user service
197. [HAVE] container-pull — load/pull an image
198. [HAVE] container-inspect — inspect an image, record a field
199. [HAVE] container-build — build an image from a Containerfile
200. [HAVE] container-run — run a detached container
201. [HAVE] container-port-env — run with env var + published port
202. [NEW] container-volume — run a container with a persistent named volume
203. [NEW] container-bindmount — run a container with a host bind mount
204. [NEW] container-exec — exec a command inside a running container, save output
205. [NEW] container-logs — capture a container's logs to a file
206. [NEW] container-stopstart — stop then start a container, confirm state

Count: this list intentionally runs slightly over 200 entries (a few [NEW]
ideas are spares marked "-> replaced"); the build target is exactly 200 distinct
shipped tasks. Final shipped set = the non-spare entries, trimmed to 200.
