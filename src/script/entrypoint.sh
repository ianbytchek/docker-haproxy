#!/usr/bin/env sh

set -euo pipefail
cd "$(dirname $0)"

command="${1}"

if [ "${command}" == 'start' ] || [ "${command}" == 'check' ]; then

    # If we have haproxy.cfg available in our configuration directory, then we use it, otherwise use the standard haproxy.cfg.

    configuration_path='/etc/haproxy/haproxy.cfg'

    if [ -f "${configuration_path}" ] && [ "${command}" == 'start' ]; then
        echo "Starting haproxy with configuration at default location, ${configuration_path}."
        haproxy -f "${configuration_path}"
    elif [ -f "${configuration_path}" ] && [ "${command}" == 'check' ]; then
        echo "Checking haproxy with configuration at default location, ${configuration_path}."
        haproxy -c -f "${configuration_path}"
        exit 0
    fi

    configuration_command=''
    configuration_paths=''

    for file in '/etc/haproxy/'*'.cfg'; do
        [ "${#configuration_paths}" > 0 ] && configuration_paths="${configuration_paths}, "
        configuration_paths="${configuration_paths}${file}"
        configuration_command="${configuration_command} -f ${file}"
    done

    if [ -n "${configuration_command}" ] && [ "${command}" == 'start' ]; then
        echo "Starting haproxy with multiple configurations, ${configuration_paths}."
        eval "haproxy ${configuration_command}"
    elif [ -n "${configuration_command}" ] && [ "${command}" == 'check' ]; then
        echo "Checking haproxy with multiple configurations, ${configuration_paths}."
        eval "haproxy -c ${configuration_command}"
        exit 0
    fi

    cat <<-EOF

		****************************************************************************************************

		    You haven't provided any configuration files, see the README.md that came with the Dockerfile
		    to find out how to do that.

		****************************************************************************************************

	EOF

    exit 1
fi

exec "${@}"