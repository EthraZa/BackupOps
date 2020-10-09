#!/bin/bash
set -e

bops_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}
bops_note() {
	bops_log Note "$@"
}
bops_warn() {
	bops_log Warn "$@" >&2
}

# usage: docker_process_init_files [file [file [...]]]
#    ie: docker_process_init_files /always-initdb.d/*
# process initializer files, based on file extensions
docker_process_init_files() {
	echo
	local f
	for f; do
		case "$f" in
			*.sh)
				if [ -x "$f" ]; then
					bops_note "$0: running $f"
					"$f"
				else
					bops_note "$0: sourcing $f"
					. "$f"
				fi
				;;
			*.bin)
				if [ -x "$f" ]; then
					bops_note "$0: running $f"
					"$f"
				fi
				;;
            *.env)
				bops_note "$0: sourcing $f"
				. "$f"
				;;
			*)  bops_warn "$0: ignoring $f" ;;
		esac
		echo
	done
}

if [ ! -z "${SAILOR_PASSWORD}" ]; then
    bops_note "$0: setting sailor password"
    echo "${SAILOR_PASSWORD}" | chpasswd
fi

# For user convenience.
# Bind mount /docker-entrypoint.d directory with you own addon init .sh, .bin or .env files.
if [ -d "/docker-entrypoint.d" ]; then
    docker_process_init_files /docker-entrypoint.d/*
fi

if [ ! -z "${BOPS_SSH}" ]; then
    bops_note "$0: running sshd"
    mkdir -p /run/sshd
	
	if [ -z "${BOPS_SSH_OPT}" ]; then
    	/usr/sbin/sshd -e -D
	else
		/usr/sbin/sshd ${BOPS_SSH_OPT}
	fi
fi

if [ ! -z "${BOPS_KEEP_RUNNING}" ]; then
	tail -f /dev/null
fi
