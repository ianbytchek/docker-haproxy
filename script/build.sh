#!/usr/bin/env sh

cd $(dirname $0)

# Install apk packages and remove apk cache when finished.

apk --update add \
    haproxy

rm -rf /var/cache/apk/*

# Move configuration into