firewall-cmd --permanent --add-rich-rule="rule family=\"ipv4\" source address=\"$FWSRC\" service name=\"ssh\" accept"
firewall-cmd --reload
