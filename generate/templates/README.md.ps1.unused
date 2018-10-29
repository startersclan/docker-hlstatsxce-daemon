@"
# alpine-cron

Packages included: `curl`, `wget`

| Tags |
|:-------:| $( $VARIANTS | % {
"`n| ``:$( $_['tag'] )`` |"
})

"@ + @'

## Steps
1. Mount crontab on `/var/spool/cron/crontabs/<user>`
2. If the crons refer to any scripts, you may mount a folder containing those scripts on `/cronscripts` or whereever you want
3. Run the container. If no errors are shown, your cron should be ready.

## Example

```
docker run -d \
    -v /path/to/root:/var/spool/cron/crontabs/root \
    -v /path/to/cronscripts/:/cronscripts/ \
    wonderous/alpine-cron
```

## Environment variables

| Name | Default value | Description
|:-------:|:---------------:|:---------:|
| `CRON_USER` | `root` | Sets the user that the crontab will run under (E.g. for user `nobody`, the crontab should be mounted at `/var/spool/cron/crontabs/nobody`.). In most cases, you should just use `root`

## Notes
- By default, a `/etc/environment` file is created at the beginning of the entrypoint script, which makes environment variables available to everyone, including crond.
- The crontab at `/var/spool/cron/crontabs/<$CRON_USER>` is set to read-only permissions: `440`
- The mountpoint /cronscripts/ is recursively set to have executable permissions at entrypoint: `+x`

## FAQ

#### My cron is not running!
 - Ensure your mounted crontab's filename matches the $CRON_USER variable.
 - Ensure your crontab has a newline at the end of the file.
 - Use `docker logs` to check whether `crond` has spit out any messages about the syntax of your cron

'@