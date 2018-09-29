FROM ubuntu

MAINTAINER The Oh Brothers

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

#
# Perl modules
#

# Install perl modules through debian packages
RUN apt-get update \
    && \
    apt-get install -y \
        perl \
        build-essential \
        libdbi-perl \
        libdbd-mysql-perl \
    && \
    rm -rf /var/lib/apt/lists/* \
    ;
# Install modules for perl GeoIP
RUN perl -MCPAN -e 'install Geo::IP::PurePerl'

# Install modules for perl GeoIP2
RUN perl -MCPAN -e "install GeoIP2" && \
    perl -MCPAN -e 'install MaxMind::DB::Reader' \
    ;

# Install modules for perl GeoIP2 (faster db access)
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:maxmind/ppa && \
    apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
    && \
    perl -MCPAN -e 'install MaxMind::DB::Reader::XS' \
    ;

# Install modules for perl-based email
RUN apt-get update && \
    apt-get install -y \
        libio-socket-ssl-perl \
        libnet-ssleay-perl \
        libwww-perl \
    ;
RUN perl -MCPAN -e 'install Email::Sender::Simple'
    #perl -MCPAN -e 'install IO::Socket::SSL' && \
    #perl -MCPAN -e 'install Net-SSLeay' && \

# Cleanup
RUN rm -rf /var/lib/apt/lists/* \
    && \
    apt-get purge --auto-remove -y \
        build-essential  \
    && \
    rm -rf /root/.cpan/ \
    ;

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGINT

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]