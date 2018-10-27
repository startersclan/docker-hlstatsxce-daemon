@"
COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

$( if ( 'cron' -in $VARIANT['components']  ) {
    # This is for killing cron daemon
    'STOPSIGNAL SIGKILL'
}else {
    'STOPSIGNAL SIGINT'
} )

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]
"@