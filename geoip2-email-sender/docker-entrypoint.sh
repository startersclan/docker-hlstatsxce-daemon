#!/bin/sh

output() {
    echo "$( date --iso-8601=ns ) [ENTRYPOINT] $1";
}

# Note: As of hlxce 1.6.19, hlstats.pl's --configfile argument does not take effect.
# To fix this, find this line in hlstats.pl:
#    if ($configfile && -r $configfile) {
# Add this code line before it:
#   setOptionsConf(%copts);
# That should fix hlstats.pl's --configfile argument issue.
[ ! -z "${CONFIG_FILE}" ] && set "$@" "--configfile=${CONFIG_FILE}"
[ ! -z "${MODE}" ] && set "$@" "--db-host=${MODE}"
[ ! -z "${DB_HOST}" ] && set "$@" "--db-host=${DB_HOST}"
[ ! -z "${DB_NAME}" ] && set "$@" "--db-name=${DB_NAME}"
[ ! -z "${DB_USER}" ] && set "$@" "--db-username=${DB_USER}"
[ ! -z "${DB_PASSWORD}" ] && set "$@" "--db-password=${DB_PASSWORD}"
[ ! -z "${STDIN}" ] && set "$@" "--stdin"
[ ! -z "${STDIN_SERVER_IP}" ] && set "$@" "--server-ip=${STDIN_SERVER_IP}"
[ ! -z "${STDIN_SERVER_PORT}" ] && set "$@" "--server-port=${STDIN_SERVER_PORT}"
[ ! -z "${USE_DAEMON_TIMESTAMP}" ] && set "$@" "--notimestamp"
#[ ! -z "${EVENT_QUEUE_SIZE}" ] && set "$@" "--event-queue-size=${EVENT_QUEUE_SIZE}"
[ ! -z "${DEBUG_LOW}" ] && set "$@" "-d"
[ ! -z "${DEBUG_HIGH}" ] && set "$@" "-dd"
[ ! -z "${DEBUG_NONE}" ] && set "$@" "-nn"

if [ ! -z "${ECHO_ENVIRONMENT}" ]; then
    output "Environment: \n$( env )"
    commandline="$@"
    output "Command line: $commandline"
fi

# Download the GeoLite / GeoLite2 DB
#[ ! -f install_binary_GeoLite.sh ] && perl install_binary_GeoLite.sh
#[ ! -f install_binary_GeoLite2.sh ] && perl install_binary_GeoLite2.sh

output "Starting daemon..."

# Run script
exec "$@"