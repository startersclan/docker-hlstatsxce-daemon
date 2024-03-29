FROM ubuntu:16.04

# Get hlstatsxce perl daemon scripts and set permissions
RUN apt-get update && apt-get install git -y \
    && git clone https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition.git /hlstatsx-community-edition \
    && cd /hlstatsx-community-edition \
    && git checkout 11cac08de8c01b7a07897562596e59b7f0f86230 \
    && mv /hlstatsx-community-edition/scripts /app \
    && find /app -type d -exec chmod 750 {} \; \
    && find /app -type f -exec chmod 640 {} \; \
    && find /app -type f -name '*.sh' -exec chmod 750 {} \; \
    && find /app -type f -name '*.pl' -exec chmod 750 {} \; \
    && find /app -type f -name 'run_*' -exec chmod 750 {} \; \
    && rm -rf /hlstatsx-community-edition \
    && apt-get purge --auto-remove -y git \
    && rm -rf /var/lib/apt/lists/*

# Download the GeoIP binary. Maxmind discontinued distributing the GeoLite Legacy databases. See: https://support.maxmind.com/geolite-legacy-discontinuation-notice/
# So let's download it from our fork of GeoLiteCity.dat
RUN apt-get update && apt-get install -y ca-certificates wget \
    && rm -rf /var/lib/apt/lists/* \
    && cd /app/GeoLiteCity \
    && wget -qO- https://github.com/startersclan/GeoLiteCity-data/raw/c14d99c42446f586e3ca9c89fe13714474921d65/GeoLiteCity.dat > GeoLiteCity.dat \
    && chmod 666 GeoLiteCity.dat \
    && ls -l

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

# Install modules for perl GeoIP
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && cpanm \
        Geo::IP::PurePerl \
    && apt-get purge --auto-remove -y \
        build-essential  \
        cpanminus \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/

# Install modules for perl GeoIP2
RUN set -eux \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && apt-get update && apt-get install -y \
        libnet-ssleay-perl \
        #libio-socket-ssl-perl \
        #libwww-perl \
        #libdatetime-perl \
    # Install older version of Test::Without::Module, since Test::Without::Module@0.21 seems to fail tests randomly. See: https://metacpan.org/release/CORION/Test-Without-Module-0.21
    && cpanm \
        Test::Without::Module@0.20 \
    && cpanm \
        MaxMind::DB::Reader \
    && cpanm \
        GeoIP2 \
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
    && apt-get update && apt-get install -y \
        software-properties-common \
    && add-apt-repository -y ppa:maxmind/ppa \
    && apt-get update \
    && apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
    && cpanm \
        MaxMind::DB::Reader::XS \
    && apt-get purge --auto-remove -y \
        build-essential \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/

# Install modules for perl-based email
RUN apt-get update \
    && apt-get install -y \
        libnet-ssleay-perl \
        libio-socket-ssl-perl \
        #libwww-perl \
        #libemail-sender-perl \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && cpanm \
        MIME::Base64 \
        Authen::SASL \
    && cpanm \
        Email::Sender::Simple \
    && apt-get purge --auto-remove -y \
        build-essential \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/

# Install basic tools for cron
RUN apt-get update \
    && apt-get install -y \
        curl \
        wget \
        openssl \
    && rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGINT

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]