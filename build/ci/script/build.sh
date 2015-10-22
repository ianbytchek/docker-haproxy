#!/usr/bin/env bash

set -euo pipefail

docker build --tag 'ianbytchek/haproxy' './src'