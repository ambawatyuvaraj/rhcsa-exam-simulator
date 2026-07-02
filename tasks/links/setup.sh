#!/usr/bin/env bash
echo "link target content" > /root/linksrc.txt
rm -f "/root/$HL" "/root/$SL"
echo "links: created /root/linksrc.txt; cleared /root/$HL and /root/$SL"
exit 0
