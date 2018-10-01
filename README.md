# hlstatsxce-perl
Docker image for the HLStatsX:CE perl daemon.

Perl Modules included in `:latest`:
- DBI
- DBD::mysql
- Geo::IP::PurePerl


## Variants

Each variant contains additional perl modules.

| Name | Perl Modules |
|:-------:|:---------:|
| `:geoip2` | `MaxMind::DB::Reader` and dependencies<br> `MaxMind::DB::Reader::XS` and dependencies
| `:geoip2-email-sender` | `MaxMind::DB::Reader` and dependencies<br> `MaxMind::DB::Reader::XS` and dependencies<br> `Email::Sender::Simple` and dependencies
| `:alpine` | Same as `:latest`, but using `alpine`
| `:alpine-geoip2` | Same as `:geoip2`, but using `alpine`


## Steps

1. Mount the `hlxce/scripts` folder on `/app`
2. Run the container. If no errors are shown, all should be good.



## Example

```
docker run -d \
    -v /path/to/hlxce/scripts:/app \
    -v /path/to/hlxce/scripts/hlstats.conf:/app/hlstats.conf \
    wonderous/hlstatsxce-perl
```


## Environment variables (optional)

These environment variables are optional. Use them only if:
1) not using the config file `./hlstats.conf`
2) using the config file `./hlstats.conf` in same directory as `hlstats.pl`, but want to override the config file's settings.

| Name | Default value (as in `hlstats.pl`) | Description | Corresponds to `hlstats.pl` argument |
|:-------:|:---------:|:---------:|:---------:| --
| `CONFIG_FILE` | `./hlstats.conf` | Specific configfile to use, settings in this file can now path to config file. May be absolute or relative | `-c,--configfile`
| `MODE` | `Normal` | player tracking mode (`Normal`, `LAN` or `NameTrack`) | `-m, --mode`
| `DB_HOST` | `localhost` | database ip or ip:port | `--db-host`
| `DB_NAME` | `"hlstats"` | database name | `--db-name`
| `DB_USER` | `""` | database user | `--db-name`
| `DB_PASSWORD` | `""` | database password | `--db-password`
| `STDIN` | `false` | read log data from standard input, instead of from UDP socket. Must specify `STDIN_SERVER_IP` and `STDIN_SERVER_PORT` to indicate the generatorof the inputted log data (implies `--norcon`) | `-s, --stdin`
| `STDIN_SERVER_IP` | `""` | data source IP address. Only required for `STDIN` | `--server-ip`
| `STDIN_SERVER_PORT` | `27015` | data source port. Only required for `STDIN` | `--server-port`
| `USE_DAEMON_TIMESTAMP` | `false` for UDP; `true` for `STDIN` | port the daemon will run on | `-t, --timestamp`
| `DEBUG_LOW` | `true` | enable debugging output | `-d, --debug`
| `DEBUG_HIGH` | N.A. | enable debugging output (verbose) | `-dd, --debug --debug`
| `DEBUG_NONE` | N.A. | disables debugging output | `--nodebug`

#### Example (with environment variables):

```
docker run -d \
    -e CONFIGFILE=/hlstats.pl \
    -e MODE=Normal \
    -e DB_HOST=db \
    -e DB_NAME=hlstatsxce \
    -e DB_USER=user \
    -e DB_PASSWORD=pass \
    -e DEBUG_NONE=1 \
    -v /path/to/hlxce/scripts:/app \
    -v /path/to/hlxce/scripts/hlstats.conf:/app/hlstats.conf \
    wonderous/hlstatsxce-perl
```


## FAQ

#### How to use GeoIP2 with the perl daemon?
 - As of `hlxce 1.6.19`, the perl daemon scripts has no support for GeoIP2. It was written only for GeoIP. You will have to change a bit of the code yourself to use the GeoIP2 API.

#### How long will this Docker Image be supported?
 - As long as the repository is not marked deprecated, which should not happen.

#### Why is the source code of the perl daemon not included in the image?
 - It well could be. But for something with few updates, it would be easier to use the image as the environment, and mount the perl scripts on top of it.
 - Also, the source code of `hlxce` is a tight bundle including all the files for the various stacks (gameserver, web frontend, perl backend). To separate out the components would be great, but would require the community does so.