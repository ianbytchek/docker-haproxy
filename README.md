# Docker HAProxy

[![Circle CI](https://circleci.com/gh/ianbytchek/docker-haproxy.svg?style=svg)](https://circleci.com/gh/ianbytchek/docker-haproxy)

Docker HAProxy image build on top of Alpine Linux micro OS with the final image size of 6.37 MB vs. 97.89 MB compared to the official [haproxy:latest](https://github.com/docker-library/haproxy/blob/master/1.5/Dockerfile).

## Running

Pull or build the image yourself and run it. Before you do that you'll need to get the configuration ready. Probably the most useful documentation on how to do that is at [cbonte.github.io/haproxy-dconv](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html) with a few examples available inside the `/configuration` folder. Configuration can be passed either via a mounted volume or baked right into the image during the build.

```
# Build
docker build -t ianbytchek/haproxy .

# Or pull
docker pull ianbytchek/haproxy

# Run
docker run -d -p 80:80 -p 443:443 --name haproxy ianbytchek/haproxy

# Run with a mounted volume
docker run -d -p 80:80 -p 443:443 -v $PATH:/docker/configuration --name haproxy ianbytchek/haproxy
```

Using mounted volume is very useful, you can edit the configuration and do `docker restart haproxy` for changes to take the effect.

## Bonus

```
# Connect to an existing container.
docker exec -i -t haproxy sh
 
# Remove exited containers.
docker ps -a | grep 'Exited' | awk '{print $1}' | xargs docker rm
 
# Remove intermediary and unused images.
docker rmi $(docker images -aq -f "dangling=true")
```