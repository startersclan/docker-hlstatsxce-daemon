# hlstatsxce-perl
Docker image for the HLStatsX:CE perl daemon.

Modules included in default installation:
- DBI
- DBD::mysql
- Geo::IP::PurePerl

## Variants

Each variant contains additional modules.

`:geoip2`

- MaxMind::DB::Reader and dependencies
- MaxMind::DB::Reader::XS and dependencies

`geoip2-email-sender`

- MaxMind::DB::Reader and dependencies
- MaxMind::DB::Reader::XS and dependencies
- Email::Sender::Simple and dependencies

## Steps
1. Mount the `hlxce/scripts` folder on `/app`
2. Run the container. If no errors are shown, all should be good.

## Example

```
docker run -d \
    -v /path/to/hlxce/scripts:/app \
    -v /path/to/hlstats.conf:/app/hlstats.conf \
    wonderous/hlstatsxce-perl
```

## Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `DAEMON_PORT` | 27500 | Sets the port the daemon will run on |


## FAQ

#### How to use GeoIP2 with the perl daemon?
 - As of `hlxce 1.6.19`, the perl daemon scripts has no support for GeoIP2. It was written only for GeoIP. You will have to change a bit of the code yourself to use the GeoIP2 API.

#### How long will this Docker Image be supported?
 - As long as the repository is not marked deprecated, which should not happen.

#### Why is the source code of the perl daemon not included in the image?
 - It well could be. But for something with few updates, it would be easier to use the image as the environment, and mount the perl scripts on top of it.
 - Also, the source code of `hlxce` is a tight bundle including all the files for the various stacks (gameserver, web frontend, perl backend). To separate out the components would be great, but would require the community does so.