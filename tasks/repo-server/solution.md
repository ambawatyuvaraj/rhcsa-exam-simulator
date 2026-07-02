# Reference solution — serve a yum repo over HTTP

Turn a directory of RPMs into a network repo: `createrepo_c` builds the repodata
metadata, httpd serves it, `restorecon` fixes the SELinux web context, and the
firewall is opened for HTTP. Clients then point a `.repo` baseurl at it.

Apache must be able to read and traverse the content, so make sure the perms are
world-readable (`chmod a+rX`) — otherwise the new `repodata/` can come out mode 700
under a restrictive umask and httpd returns **403 Forbidden**.

```bash
dnf -y install httpd createrepo_c
createrepo_c /var/www/html/pkgrepo      # generate repo metadata
chmod -R a+rX /var/www/html/pkgrepo     # apache must read/traverse (umask-safe)
restorecon -R /var/www/html/pkgrepo     # correct SELinux context for httpd
systemctl enable --now httpd
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
curl http://localhost/pkgrepo/repodata/repomd.xml   # confirm it is served
```
