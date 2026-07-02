systemctl enable --now "${SVC:-chronyd}"
systemctl restart "${SVC:-chronyd}"
