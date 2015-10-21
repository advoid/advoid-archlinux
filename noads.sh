#!/bin/bash
cat >hosts <<EOF
#
# /etc/hosts: static lookup table for host names
#

#<ip-address> <hostname.domain.org> <hostname>
127.0.0.1 localhost.localdomain localhost
::1   localhost.localdomain localhost
#
EOF
rm data
echo "Checking Server 1/4"
wget -q -O - 'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext' > data
echo "Checking Server 2/4"
wget -q -O - 'http://hosts-file.net/ad_servers.txt' >> data
echo "Checking Server 3/4"
wget -q -O - 'http://winhelp2002.mvps.org/hosts.txt' >> data
echo "Checking Server 4/4"
wget -q -O - 'https://adaway.org/hosts.txt' >> data
echo "Downloading done; removing duplicates..."
cat data | grep -v "^#" | sed -e "s/^M//g"| sed "s/\t/ /g" | tr -s ' ' | cut -d' ' -f2 | grep -v "^localhost" | sort -u | sed '/^$/d' | sed 's/^/0.0.0.0 /' > data2
echo "done"
mv data2 data
cat data >> hosts
echo "$(pwd)/hosts is ready"
