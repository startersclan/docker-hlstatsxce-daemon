FROM ubuntu:16.04

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
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && apt-get update && apt-get install -y \
        libio-socket-ssl-perl \
        libnet-ssleay-perl \
        libwww-perl \
        libdatetime-perl \
    && cpanm \
        GeoIP2 \
        MaxMind::DB::Reader \
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
    && apt-get update && apt-get install -y \
        software-properties-common \
    && add-apt-repository -y ppa:maxmind/ppa \
    && apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
    && cpanm \
        MaxMind::DB::Reader::XS \
    && apt-get purge --auto-remove -y \
        build-essential  \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGINT

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]