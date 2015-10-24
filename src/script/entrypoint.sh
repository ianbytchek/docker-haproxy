#!/usr/bin/env sh

set -euo pipefail
cd $(dirname $0)

if [ $1 = 'haproxy' ]; then

    # If we have haproxy.cfg available in our configuration directory, then we use it, otherwise use the standard haproxy.cfg.

    if [ -f '/etc/haproxy/haproxy.cfg' ]; then
        haproxy -f '/etc/haproxy/haproxy.cfg'
    else
        cat <<-EOF

			****************************************************************************************************

			    It looks like you haven't specified the haproxy.cfg file, the default one will be used, meaning
			    the HAProxy won't do anything useful. See the README.md that came with the Dockerfile.

			****************************************************************************************************

		EOF

        exit 1
    fi
fi