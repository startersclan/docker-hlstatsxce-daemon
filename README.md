# docker-hlstatsxce-daemon

[![github-actions](https://github.com/startersclan/docker-hlstatsxce-daemon/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-hlstatsxce-daemon/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-hlstatsxce-daemon?style=flat-square)](https://github.com/startersclan/docker-hlstatsxce-daemon/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-hlstatsxce-daemon/latest)](https://hub.docker.com/r/startersclan/docker-hlstatsxce-daemon)

Dockerized [HLStatsX:CE](https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition/) perl daemon.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.6.19-emailsender-ubuntu-16.04` | [View](variants/v1.6.19-emailsender-ubuntu-16.04) |
| `:v1.6.19-geoip-ubuntu-16.04` | [View](variants/v1.6.19-geoip-ubuntu-16.04) |
| `:v1.6.19-geoip-geoip2-ubuntu-16.04` | [View](variants/v1.6.19-geoip-geoip2-ubuntu-16.04) |
| `:v1.6.19-geoip-geoip2-emailsender-ubuntu-16.04` | [View](variants/v1.6.19-geoip-geoip2-emailsender-ubuntu-16.04) |
| `:v1.6.19-emailsender-alpine-3.8` | [View](variants/v1.6.19-emailsender-alpine-3.8) |
| `:v1.6.19-geoip-alpine-3.8`, `:latest` | [View](variants/v1.6.19-geoip-alpine-3.8) |
| `:v1.6.19-geoip-geoip2-alpine-3.8` | [View](variants/v1.6.19-geoip-geoip2-alpine-3.8) |
| `:v1.6.19-geoip-geoip2-emailsender-alpine-3.8` | [View](variants/v1.6.19-geoip-geoip2-emailsender-alpine-3.8) |

Variants are based on `ubuntu:16.04` or `alpine:3.8`. All variants include `DBI` and `DBD::mysql` perl modules.

Variants may contain one or more additional Perl modules. E.g. `:geoip-geoip2-emailsender` contains the `geoip`, `geoip2`, and `emailsender` Perl modules.

| Tag component | Perl Modules |
|:-------:|:---------:|
| `geoip` | `Geo::IP::PurePerl`
| `geoip2` | `MaxMind::DB::Reader`<br> `MaxMind::DB::Reader::XS`
| `emailsender` | `Email::Sender::Simple`

## Usage

### Example

```sh
docker run -it \
    -p 27500:27500/udp \
    -e LOG_LEVEL=1 \
    -e MODE=Normal \
    -e DB_HOST=db \
    -e DB_NAME=hlstatsxce \
    -e DB_USER=hlstatsxce \
    -e DB_PASSWORD=hlstatsxce \
    startersclan/docker-hlstatsxce-daemon:v1.6.19-geoip-alpine-3.8

# Alternatively, if you prefer to use a config file instead of environment variables
docker run -it \
    -v /path/to/hlxce/scripts/hlstats.conf:/app/hlstats.conf \
    startersclan/docker-hlstatsxce-daemon:v1.6.19-geoip-alpine-3.8
```

### Example (Swarm Mode with Docker Secrets)

```sh
docker service create --name hlstatsxce-daemon \
    -p 27500:27500/udp \
    -e LOG_LEVEL=1 \
    -e MODE=Normal \
    -e DB_HOST=db \
    -e DB_NAME=DOCKER-SECRET:secret_db_name \
    -e DB_USER=DOCKER-SECRET:secret_db_user \
    -e DB_PASSWORD=DOCKER-SECRET:secret_db_password \
    --secret secret_db_name \
    --secret secret_db_user \
    --secret secret_db_password \
    startersclan/docker-hlstatsxce-daemon:v1.6.19-geoip-alpine-3.8
```

The entrypoint script takes care of expanding the environment variables `DB_NAME`, `DB_USER`, and `DB_PASSWORD` from the respective secret files `/run/secrets/secret_db_name`, `/run/secrets/secret_db_user`, and `/run/secrets/secret_db_password`. This is done by using the syntax `ENVVARIABLE=DOCKER-SECRET:docker_secret_name` (note the colon).

## Configuration

### Environment variables

In general, it is better to use environment variables than a config file, because it offers more configuration options. Use them only if:

1. not using a config file

2. using the config file `./hlstats.conf` in same directory as `hlstats.pl`, but want to override the config file's settings.

| Name | Default value (as in `hlstats.pl`) | Description | Corresponds to `hlstats.pl` argument |
|:-------:|:---------:|:---------:|:---------:|
| `CONFIG_FILE` | `"./hlstats.conf"` | Path to config file. May be absolute or relative | `-c,--configfile`
| `LOG_LEVEL` | `"1"` | Log level for debugging | 0 - `-n, --nodebug`<br /> 1 - `-d, --debug` <br />  2 - `-dd, --debug --debug`
| `MODE` | `"Normal"` | Player tracking mode (`Normal`, `LAN` or `NameTrack`) | `-m, --mode`
| `DB_HOST` | `"localhost"` | Database IP or hostname, in format `<ip>` or `<hostname>`. Port may be omitted, in which case it is `27500` by default. To use a custom port, use format `<ip>:<port>` or `<hostname>:<port>` specifed. | `--db-host`
| `DB_NAME` | `"hlstats"` | Database name | `--db-name`
| `DB_USER` | `""` | Database user | `--db-user`
| `DB_PASSWORD` | `""` | Database password | `--db-password`
| `DNS_RESOLVE_IP` | `"true"` | Resolve player IP addresses to hostnames (requires working DNS) | `--dns-resolveip`
| `DNS_RESOLVE_IP_TIMEOUT` | `"5"` | timeout DNS queries after SEC seconds | `--dns-timeout`
| `LISTEN_IP` | `""` | IP to listen on for UDP log data | `--ip`
| `LISTEN_PORT` | `"27500"` | Port to listen on for UDP log data | `--port`
| `RCON` | `"true"` | Enable rcon to gameservers | `--rcon`
| `STDIN` | `"false"` | Read log data from standard input, instead of from UDP socket. Must specify `STDIN_SERVER_IP` and `STDIN_SERVER_PORT` to indicate the generatorof the inputted log data (implies `--norcon`) | `-s, --stdin`
| `STDIN_SERVER_IP` | `""` | Data source IP address. Only required for `STDIN` | `--server-ip`
| `STDIN_SERVER_PORT` | `"27015"` | Data source port. Only required for `STDIN` | `--server-port`
| `USE_LOG_TIMESTAMP` | `"false"` for UDP; `"true"` for `STDIN` | Use the timestamp in the log data, instead of the current time on the daemon, when recording events | `-t, --timestamp`
<!-- | `EVENT_QUEUE_SIZE` | `"10"` | Event buffer size before flushing to the db (recommend 100+ for STDIN) | `--event-queue-size` -->

### Configuration file, Command line parameters, and Database options

Configuration options are applied the following order. Later options override the earlier options.

1. Default config file `./hlstats.conf` if it exists.
    - See [code](https://github.com/startersclan/hlstatsx-community-edition/blob/965453909e1d28aed3abfca7f93b6c1b27a7f75d/scripts/hlstats.pl#L1739-L1784)

2. Command line parameters (Also applies to environment variables above which simply generate a command line).
    - See [code](https://github.com/startersclan/hlstatsx-community-edition/blob/965453909e1d28aed3abfca7f93b6c1b27a7f75d/scripts/hlstats.pl#L1792-L1829)

3. (N.A. since bugged) Custom config file specified by command line parameter `--configfile`.
    - Doesn't work because of a bug explained [here](#warning-if-using-configfile-or---configfile)

4. Database configuration from `hlstats_options` table.

    - See [directives](https://github.com/startersclan/hlstatsx-community-edition/blob/965453909e1d28aed3abfca7f93b6c1b27a7f75d/scripts/hlstats.pl#L1755-L1781)

    - See [code](https://github.com/startersclan/hlstatsx-community-edition/blob/965453909e1d28aed3abfca7f93b6c1b27a7f75d/scripts/hlstats.pl#L1882)

The following database configuration options override config file or command line parameter configuration. Looking in [`install.sql`](https://github.com/startersclan/hlstatsx-community-edition/blob/11cac08de8c01b7a07897562596e59b7f0f86230/sql/install.sql#L3901):

- `--dns-resolveip` is enabled since parameter `DNSResolveIP` value is `1`
- `--dns-timeout` is `3` since parameter `DNSTimeout` value is `3`
- `--mode` is `Normal` since parameter `Mode` value is `Normal`
- `--rcon` is enabled since parameter `Rcon` value is `1`
- `--timestamp` is disabled since parameter `UseTimestamp` value is `0`

### Warning: If using `CONFIG_FILE` or `--configfile`

There is a bug in `hlstats.pl` that does not apply the command line parameter `--configfile=<configfile>` properly as configuration. To fix that, find the line in [`hlstats.pl`](https://github.com/startersclan/hlstatsx-community-edition/blob/11cac08de8c01b7a07897562596e59b7f0f86230/scripts/hlstats.pl#L1821) on line `1821`:

```perl
if ($configfile && -r $configfile) {
```

Add this code line before it:

```perl
setOptionsConf(%copts);
```

Save the file. That should fix hlstats.pl's `--configfile` argument issue.

## FAQ

### Q: Perl errors on startup?

A: This docker image runs `perl5`, but [`HLStatsX:CE 1.6.19`](https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition) might have been written for `perl4` or early `perl5` (not sure) and the project is no longer actively maintained. You will have to fix the compatibility errors, and rebuild a docker image based on this docker image.

From experience (of the author of this repo), there are quite a number of these kinds of bugs that can cause the daemon the crash. You might end up as a Perl Monk after having fixed them. :)

### Q: Error `Unable to execute query: Illegal mix of collations` (or similar)?

A: This error can happen when certain player names contain special characters (e.g. emoji or unicode).

The fix is to convert all default collations in the DB tables to `utf8mb4_unicode_ci`.

- If installing the first time, replace all instances of `DEFAULT CHARSET=utf8` with `DEFAULT CHARSET=utf8mb4` and `DEFAULT COLLATE=utf8` with `DEFAULT COLLATE=utf8mb4_unicode_ci` in [`HLStatsX:CE 1.6.19` `install.sql`](https://github.com/startersclan/hlstatsx-community-edition/blob/master/sql/install.sql), then install the DB using `install.sql`.
- If DB is already installed, use [`ALTER`](https://dev.mysql.com/doc/refman/5.7/en/alter-table.html) to convert all `TEXT` table columns to `DEFAULT CHARSET=utf8mb4` and `DEFAULT COLLATE=utf8mb4_unicode_ci`. See [here](https://stackoverflow.com/a/50264108) for more information.

Additionally, to ensure the daemon's character set matches the DB table's collation, use `default_character_set=utf8mb4` in the `mysqld` config file (e.g. `/etc/mysql/mysql.conf.d/mysqld.cnf`):

```cnf
[client]
default_character_set=utf8mb4
...

[mysql]
default_character_set=utf8mb4
...

[mysqldump]
default_character_set=utf8mb4
...
```

### Q: How to use GeoIP2 with the perl daemon?

A: As of [`HLStatsX:CE 1.6.19`](https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition/downloads/), the perl daemon scripts uses [GeoIP](https://metacpan.org/pod/Geo::IP::PurePerl), and not [GeoIP2](https://metacpan.org/pod/GeoIP2). You will have to change a bit of the code yourself to use the [GeoIP2 API](https://metacpan.org/release/GeoIP2).

### Q: How long will this Docker Image be supported?

A: As long as the repository is not marked deprecated, which should not happen.

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```
