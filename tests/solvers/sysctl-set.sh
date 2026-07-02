echo "$KEY = $VAL" > /etc/sysctl.d/99-rhcsa.conf
sysctl -w "$KEY=$VAL"
