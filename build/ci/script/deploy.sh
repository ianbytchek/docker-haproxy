#!/usr/bin/env bash

set -euo pipefail

# Authenticate with docker and push the latest image.

docker login \
    --email "${DOCKER_HUB_EMAIL}" \
    --password "${DOCKER_HUB_PASSWORD}" \
    --username "${DOCKER_HUB_USER}"

docker push 'ianbytchek/haproxy'
docker logout