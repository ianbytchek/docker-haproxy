# Docker HAProxy

[![Circle CI](https://circleci.com/gh/ianbytchek/docker-haproxy.svg?style=svg)](https://circleci.com/gh/ianbytchek/docker-haproxy)

Docker HAProxy image is built on top of Alpine Linux micro OS with the final image size of 6.37 MB vs. 97.89 MB compared to the official [haproxy:latest](https://github.com/docker-library/haproxy/blob/master/1.5/Dockerfile). Allows to run haproxy with multiple configuration files if you prefer to keep things neat and separate.

## Running

Pull or build the image yourself and run it. Before you do that you'll need to get the configuration ready. Probably the most useful documentation on how to do that is at [cbonte.github.io/haproxy-dconv](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html) with a few examples available inside the `/configuration` folder. Configuration can be passed either via a mounted volume or baked right into the image during the build.

```sh
# Prepare configuration, you can use multiple files or a single file.

cat <<-EOL > '/configuration/defaults.cfg'
	defaults
	    mode tcp
	    timeout connect 5s
	    timeout client 1m
	    timeout server 1m
EOL

cat <<-EOL > '/configuration/git.cfg'
	frontend http
	    bind *:80
	    default_backend app

	backend app
	    balance roundrobin
	    server node01 github.com:80
	    server node02 bitbucket.com:80
EOL

# Build…
docker build -t ianbytchek/haproxy .

# Or pull…
docker pull ianbytchek/haproxy

# Run, configuration MUST be provided via a mounted volume.
docker run \
    --detach \
    --name 'haproxy' \
    --publish '80:80' \
    --publish '443:443' \
    --volume '/configuration:/etc/haproxy' \
    ianbytchek/haproxy
```

## Configuration

One thing to keep in mind, the container will first check if there's a `haproxy.cfg` file in `/etc/haproxy` and use that, even if there are other configuration files – that's in case when you want to use multiple configuration files. So, if you do, make sure you don't name any of them `haproxy.cfg`.
