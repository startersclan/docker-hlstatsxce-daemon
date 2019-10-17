# docker-hlstatsxce-daemon

[![pipeline status](https://gitlab.com/startersclan/docker-hlstatsxce-daemon/badges/dev/pipeline.svg)](https://gitlab.com/startersclan/docker-hlstatsxce-daemon/commits/dev)

Docker image for the [HLStatsX:CE](https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition/) perl daemon.

## Variants

Each variant contains additional perl modules.

These below variants use `Ubuntu:16.04`. Variants with suffix `-alpine` use the `Alpine:3.8`

| Name | Perl Modules |
|:-------:|:---------:|
| `:cron` | `DBI`<br>`DBD::mysql`
| `:geoip` | `Geo::IP::PurePerl` and dependencies
| `:geoip2` | `MaxMind::DB::Reader` and dependencies<br> `MaxMind::DB::Reader::XS` and dependencies
| `:emailsender` | `Email::Sender::Simple` and dependencies

NOTE: Chained tags E.g. `:geoip-geoip2-emailsender` contain the `:geoip`, `:geoip2`, and `:emailsender` Perl modules.

## Example

```sh
docker run -d \
    -e DB_HOST=db
    -e DB_NAME=hlstatsxce
    -e DB_USER=hlstatsxce
    -e DB_PASSWORD=hlstatsxce
    -e DEBUG_LOW=1
    leojonathanoh/docker-hlstatsxce-daemon:geoip

# Alternatively, if you prefer to use a config file instead of environment variables
docker run -d \
    -v /path/to/hlxce/scripts/hlstats.conf:/app/hlstats.conf \
    leojonathanoh/docker-hlstatsxce-daemon:geoip
```

## Example (Swarm Mode with Docker Secrets):

```sh
docker service create --name hlstatsxce-daemon \
    -e MODE=Normal \
    -e DB_HOST=db \
    -e DB_NAME=DOCKER-SECRET:secret_db_name \
    -e DB_USER=DOCKER-SECRET:secret_db_user \
    -e DB_PASSWORD=DOCKER-SECRET:secret_db_password \
    -e DEBUG_LOW=1 \
    --secret secret_db_name \
    --secret secret_db_user \
    --secret secret_db_password \
    leojonathanoh/docker-hlstatsxce-daemon:geoip
```

The entrypoint script takes care of expanding the environment variables `DB_NAME`, `DB_USER`, and `DB_PASSWORD` from the respective secret files `/run/secrets/secret_db_name`, `/run/secrets/secret_db_user`, and `/run/secrets/secret_db_password`. This is done by using the syntax `ENVVARIABLE=DOCKER-SECRET:docker_secret_name` (note the colon).

## Environment variables (optional)

These environment variables are optional. Use them only if:
1. not using the config file `./hlstats.conf`
2. using the config file `./hlstats.conf` in same directory as `hlstats.pl`, but want to override the config file's settings.

| Name | Default value (as in `hlstats.pl`) | Description | Corresponds to `hlstats.pl` argument |
|:-------:|:---------:|:---------:|:---------:|
| `CONFIG_FILE` | `./hlstats.conf` | Path to config file. May be absolute or relative | `-c,--configfile`
| `MODE` | `Normal` | Player tracking mode (`Normal`, `LAN` or `NameTrack`) | `-m, --mode`
| `DB_HOST` | `localhost` | Database IP or hostname, in format `<ip>` or `<hostname>`. Port may be omitted, in which case it is `27500` by default. To use a custom port, use format `<ip>:<port>` or `<hostname>:<port>` specifed. | `--db-host`
| `DB_NAME` | `"hlstats"` | Database name | `--db-name`
| `DB_USER` | `""` | Database user | `--db-name`
| `DB_PASSWORD` | `""` | Database password | `--db-password`
| `STDIN` | `false` | Read log data from standard input, instead of from UDP socket. Must specify `STDIN_SERVER_IP` and `STDIN_SERVER_PORT` to indicate the generatorof the inputted log data (implies `--norcon`) | `-s, --stdin`
| `STDIN_SERVER_IP` | `""` | Data source IP address. Only required for `STDIN` | `--server-ip`
| `STDIN_SERVER_PORT` | `27015` | Data source port. Only required for `STDIN` | `--server-port`
| `USE_DAEMON_TIMESTAMP` | `false` for UDP; `true` for `STDIN` | Port the daemon will run on | `-t, --timestamp`
| `DEBUG_LOW` | `true` | Eable debugging output | `-d, --debug`
| `DEBUG_HIGH` | N.A. | Enable debugging output (verbose) | `-dd, --debug --debug`
| `DEBUG_NONE` | N.A. | Disable debugging output | `--nodebug`

## Warning: If using `CONFIG_FILE`

There is a bug in `hlstats.pl` that does not allow the passing of `--configfile=<configfile>` properly. To fix that, find the line in `hlstats.pl` on line `1821`:

```perl
if ($configfile && -r $configfile) {
```

Add this code line before it:

```perl
setOptionsConf(%copts);
```

Save the file. That should fix hlstats.pl's `--configfile` argument issue.


## FAQ

### How to use GeoIP2 with the perl daemon?

 - As of [`HLStatsX:CE 1.6.19`](https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition/downloads/), the perl daemon scripts uses [GeoIP](https://metacpan.org/pod/Geo::IP::PurePerl), and not [GeoIP2](https://metacpan.org/pod/GeoIP2). You will have to change a bit of the code yourself to use the [GeoIP2 API](https://metacpan.org/release/GeoIP2).

### How long will this Docker Image be supported?

 - As long as the repository is not marked deprecated, which should not happen.
