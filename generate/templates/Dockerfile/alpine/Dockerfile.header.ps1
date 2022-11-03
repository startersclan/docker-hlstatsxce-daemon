@"
FROM alpine:3.8

# Get hlstatsxce perl daemon scripts and set permissions
RUN apk add --no-cache git \
    && git clone https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition.git /hlstatsx-community-edition \
    && cd /hlstatsx-community-edition \
    && git checkout $( $PASS_VARIABLES['hlstatsxce_git_hash'] ) \
    && mv /hlstatsx-community-edition/scripts /app \
    && find /app -type d -exec chmod 750 {} \; \
    && find /app -type f -exec chmod 640 {} \; \
    && find /app -type f -name '*.sh' -exec chmod 750 {} \; \
    && find /app -type f -name '*.pl' -exec chmod 750 {} \; \
    && find /app -type f -name 'run_*' -exec chmod 750 {} \; \
    && rm -rf /hlstatsx-community-edition \
    && apk del git


"@

if ( 'geoip' -in $VARIANT['components'] ) {
#   @'
# # Download the GeoIP binary
# RUN apk add --no-cache ca-certificates wget \
#     && cd /app/GeoLiteCity \
#     && ls -l \
#     && sh ./install_binary.sh \
#     && chmod 666 GeoLiteCity.dat \
#     && rm -f GeoLiteCity.dat.gz \
#     && ls -l
# '@
    @"
# Download the GeoIP binary. Maxmind discontinued distributing the GeoLite Legacy databases. See: https://support.maxmind.com/geolite-legacy-discontinuation-notice/
# So let's download it from our fork of GeoLiteCity.dat
RUN apk add --no-cache ca-certificates wget \
    && rm -rf /var/lib/apt/lists/* \
    && cd /app/GeoLiteCity \
    && wget -qO- https://github.com/startersclan/GeoLiteCity-data/raw/c14d99c42446f586e3ca9c89fe13714474921d65/GeoLiteCity.dat > GeoLiteCity.dat \
    && chmod 666 GeoLiteCity.dat \
    && ls -l


"@
}

if ( 'geoip2' -in $VARIANT['components'] ) {
    @'
# Download the GeoIP2 binary. Maxmind discontinued distributing the GeoLite2 databases publicly, so a license key is needed. See: https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
# In order to obtain the secret MAXMIND_LICENSE_KEY, we assume we have a sidecar secrets-server which will serve the secret MAXMIND_LICENSE_KEY at: http://localhost:8000/MAXMIND_LICENSE_KEY
RUN apk add --no-cache ca-certificates curl \
    && cd /app/GeoLiteCity \
    && curl -sSLO https://cdn.jsdelivr.net/npm/geolite2-city@1.0.0/GeoLite2-City.mmdb.gz \
    && gzip -d GeoLite2-City.mmdb.gz \
    && chmod 666 GeoLite2-City.mmdb \
    && ls -al \
    && apk del curl


'@
}


@'
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
RUN apk add --no-cache \
        perl-dbi \
        perl-dbd-mysql
'@
