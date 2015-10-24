#!/usr/bin/env sh

set -euo pipefail
cd $(dirname $0)

# Install apk packages and remove apk cache when finished.

echo -n 'Updating apk and installing haproxy…'
apk --update add haproxy > /dev/null
echo ' OK!'

echo -e "\n$(haproxy -vv)\n"

echo -n 'Configuring entrypoint…'
mv '/docker/script/entrypoint.sh' '/'
echo ' OK!'

echo -n 'Cleaning up container…'
rm -rf '/docker'
rm -rf '/etc/haproxy/'*
rm -rf '/var/cache/apk'
echo ' OK!'