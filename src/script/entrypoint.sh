#!/usr/bin/env sh

set -euo pipefail
cd "$(dirname $0)"

if [ "${1}" == 'haproxy' ]; then

    # If we have haproxy.cfg available in our configuration directory, then we use it, otherwise use the standard haproxy.cfg.

    configuration_path='/etc/haproxy/haproxy.cfg'

    if [ -f "${configuration_path}" ]; then
        echo "Starting haproxy with default configuration, ${configuration_path}."
        haproxy -f "${configuration_path}"
    fi

    configuration_command=''
    configuration_paths=''

    for file in '/etc/haproxy/'*'.cfg'; do
        [ "${#configuration_paths}" > 0 ] && configuration_paths="${configuration_paths}, "
        configuration_paths="${configuration_paths}${file}"
        configuration_command="${configuration_command} -f ${file}"
    done

    if [ -n "${configuration_command}" ]; then
        echo "Starting haproxy with multiple configurations, ${configuration_paths}."
        eval "haproxy ${configuration_command}"
    fi

    cat <<-EOF

		****************************************************************************************************

		    You haven't provided any configuration files, see the README.md that came with the Dockerfile
		    to find out how to do that.

		****************************************************************************************************

	EOF

    exit 1
fi