@"
FROM ubuntu:16.04

# Get hlstatsxce perl daemon scripts and set permissions
RUN apt-get update && apt-get install git -y \
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
    && apt-get purge --auto-remove -y git \
    && rm -rf /var/lib/apt/lists/*


"@

if ( 'geoip' -in $VARIANT['components'] ) {
#   @'
# # Download the GeoIP binary
# RUN apt-get update && apt-get install -y ca-certificates wget \
#     && rm -rf /var/lib/apt/lists/* \
#     && cd /app/GeoLiteCity \
#     && ls -l \
#     && ./install_binary.sh \
#     && chmod 666 GeoLiteCity.dat \
#     && rm -f GeoLiteCity.dat.gz \
#     && ls -l
# '@
#
    @"
# Download the GeoIP binary. Maxmind discontinued distributing the GeoLite Legacy databases. See: https://support.maxmind.com/geolite-legacy-discontinuation-notice/
# So let's download it from our fork of GeoLiteCity.dat
RUN apt-get update && apt-get install -y ca-certificates wget \
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
RUN apt-get update && apt-get install -y ca-certificates curl \
    && cd /app/GeoLiteCity \
    && curl -sSLO https://cdn.jsdelivr.net/npm/geolite2-city@1.0.0/GeoLite2-City.mmdb.gz \
    && gzip -d GeoLite2-City.mmdb.gz \
    && chmod 666 GeoLite2-City.mmdb \
    && ls -al \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /var/lib/apt/lists/*


'@
}

@'
#
# Export these environment variables
#

# MCPAN non-interactive (silent). It makes perl automatically answer "yes" when CPAN asks "Would you like to configure as much as possible automatically? [yes]"
# Same as using:
#   export PERL_MM_USE_DEFAULT=1
ENV PERL_MM_USE_DEFAULT 1

# Perl module installation location
# Enable line(s) if entrypoint throws errors about missing modules in @INC
# Same as using:
#   export PERL_MM_OPT=/usr/share/perl5
#   export PERL_MB_OPT=/usr/share/perl5
#ENV PERL_MM_OPT /usr/share/perl5
#ENV PERL_MB_OPT /usr/share/perl5

# Perl @INC location
# Enable line(s) if entrypoint throws errors about missing modules in @INC
# Same as using:
#   export PERL5LIB=/usr/share/perl5
#ENV PERL5LIB /usr/share/perl5

# Install perl
RUN apt-get update \
    && apt-get install -y \
        perl \
    && rm -rf /var/lib/apt/lists/*

#
# Perl modules
#

# Install DB perl modules through packages
RUN apt-get update \
    && apt-get install -y \
        libdbi-perl \
        libdbd-mysql-perl \
    && rm -rf /var/lib/apt/lists/*
'@
