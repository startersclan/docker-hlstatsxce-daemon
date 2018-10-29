@'
FROM alpine:3.8

COPY hlstatsx-community-edition/scripts /app

# Set permissions
RUN find /app -type d -exec chmod 750 {} \; \
    && find /app -type f -exec chmod 640 {} \; \
    && find /app -type f -name '*.sh' -exec chmod 750 {} \; \
    && find /app -type f -name '*.pl' -exec chmod 750 {} \; \
    && find /app -type f -name 'run_*' -exec chmod 750 {} \;

# Download the GeoIP binary
RUN apk update && apk add --no-cache wget \
    && rm -rf /var/cache/apk/* \
    && cd /app/GeoLiteCity \
    && ls -l \
    && ./install_binary.sh \
    && chmod 666 GeoLiteCity.dat \
    && rm -f GeoLiteCity.dat.gz \
    && ls -l

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
'@