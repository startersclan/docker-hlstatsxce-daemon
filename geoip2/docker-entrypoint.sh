#!/bin/sh

output() {
    echo "$( date --iso-8601=ns ) [ENTRYPOINT] $1";
}

# Exit if daemon config is not found
[ ! -f "/app/hlstats.conf" ] && output "WARNING: Could not find the daemon config /app/hlstats.conf! Will use app defaults."

# Exit if port is invalid
[ -z "${DAEMON_PORT}" ] && DAEMON_PORT=27500
DAEMON_PORT=$( echo "${DAEMON_PORT}" | grep -P '^\d{1,5}$'  )
[ -z "${DAEMON_PORT}" ] && output "Environment variable \${DAEMON_PORT} must be an integer." && exit 1
( [ "${DAEMON_PORT}" -lt 1 ] || [ "${DAEMON_PORT}" -gt 65535 ] ) && output "Invalid Environment variable \${DAEMON_PORT} specified. It must be between 1 and 65535." && exit 1

[ -n "${DAEMON_PORT}" ] && output "Environment variable \${DAEMON_PORT} found! Will run the daemon on port ${DAEMON_PORT}"

###################
# Prepare the app #
###################

# Test GeoIP and GeoIP2 compatibility
cd /app/GeoLiteCity
if [ -f TestGeoLite.pl ]; then
    echo "[Entrypoint] Testing GeoIP ..."
    perl TestGeoLite.pl || exit 1
fi
if [ -f TestGeoLite2.pl ]; then
    echo "[Entrypoint] Testing GeoIP2 ..."
    perl TestGeoLite2.pl || exit 1
fi

# Download the GeoLite / GeoLite2 DB
#[ ! -f install_binary_GeoLite.sh ] && perl install_binary_GeoLite.sh
#[ ! -f install_binary_GeoLite2.sh ] && perl install_binary_GeoLite2.sh

# Run script
cd /app
exec "$@ --port=${DAEMON_PORT}"