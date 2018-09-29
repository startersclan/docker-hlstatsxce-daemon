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