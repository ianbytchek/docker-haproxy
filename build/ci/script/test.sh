#!/usr/bin/env bash

set -euo pipefail

# Test running container with a single configuration file.

cat <<-EOL > './src/configuration/haproxy.cfg'
	defaults
	    mode tcp
	    timeout connect 5s
	    timeout client 1m
	    timeout server 1m

	frontend http
	    bind *:80
	    default_backend app

	backend app
	    balance roundrobin
	    server node01 github.com:80
	    server node02 bitbucket.com:80
EOL

echo 'Using the following configuration to test haproxy.'
cat './src/configuration/haproxy.cfg'
echo -e '\n'

echo -n 'Starting haproxy container…'
container_name=$(docker run \
    --detach \
    --publish '80:80' \
    --volume "$(pwd)/src/configuration:/etc/haproxy" \
    ianbytchek/haproxy)
echo ' OK!'

sleep 5

echo -n 'Checking if haproxy is available via curl…'
curl --retry 10 --retry-delay 5 --silent 'http://localhost:80' > /dev/null
echo ' OK!'

# Check if container starts as expected with multiple configuration files.

rm './src/configuration/haproxy.cfg'

cat <<-EOL > './src/configuration/defaults.cfg'
	defaults
	    mode tcp
	    timeout connect 5s
	    timeout client 1m
	    timeout server 1m
EOL

cat <<-EOL > './src/configuration/app.cfg'
	frontend http
	    bind *:80
	    default_backend app

	backend app
	    balance roundrobin
	    server node01 github.com:80
	    server node02 bitbucket.com:80
EOL

echo 'Using multiple configurations to test haproxy.'

echo -n 'Restarting haproxy container…'
docker restart "${container_name}" > /dev/null
echo ' OK!'

sleep 5

echo -n 'Checking if haproxy is available via curl…'
curl --retry 10 --retry-delay 5 --silent 'http://localhost:80' > /dev/null
echo ' OK!'

echo 'Below are haproxy docker logs:'
docker logs "${container_name}"
