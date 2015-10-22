#!/usr/bin/env bash

set -euo pipefail

cp './src/configuration/haproxy.cfg.sample' './src/configuration/haproxy.cfg'

sed -i \
    -e 's/\(node01\) <IP>:<PORT>/\1 github.com:80/g' \
    -e 's/\(node02\) <IP>:<PORT>/\1 bitbucket.com:80/g' \
    './src/configuration/haproxy.cfg'

echo 'Using the following configuration to test haproxy.'
cat './src/configuration/haproxy.cfg'
echo '\n\n'

echo -n 'Starting haproxy container…'
docker run \
    --detach \
    --publish '80:80' \
    --volume "$(pwd)/src/configuration:/docker/configuration" \
    ianbytchek/haproxy > /dev/null
echo ' OK!'

sleep 5

echo -n 'Checking if haproxy is available via curl… '
curl --retry 10 --retry-delay 5 --silent 'http://localhost:80' > /dev/null
echo ' OK!'