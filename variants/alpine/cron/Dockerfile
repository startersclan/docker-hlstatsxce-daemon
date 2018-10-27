FROM alpine:3.8

# Install perl
RUN apk add --no-cache \
    wget \
    perl \
    perl-dev \
    perl-doc

#
# Perl modules
#

# Install DB perl modules through packages
RUN apk update \
    && apk add --no-cache \
        perl-dbi \
        perl-dbd-mysql \
    && rm -rf /var/cache/apk/*



COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGKILL

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]