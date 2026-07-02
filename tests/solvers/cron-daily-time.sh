echo "$M $H * * * /usr/bin/logger daily-$U" | crontab -u "$U" -
