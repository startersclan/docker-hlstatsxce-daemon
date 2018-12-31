FROM ubuntu:16.04

# Get hlstatsxce perl daemon scripts and set permissions
RUN apt-get update \
    && apt-get install git -y \
    && git submodule add https://bitbucket.org/Maverick_of_UC/hlstatsx-community-edition.git hlstatsx-community-edition \
    && apt-get purge --auto-remove git \
    && mv hlstatsx-community-edition/scripts /app \
    && find /app -type d -exec chmod 750 {} \; \
    && find /app -type f -exec chmod 640 {} \; \
    && find /app -type f -name '*.sh' -exec chmod 750 {} \; \
    && find /app -type f -name '*.pl' -exec chmod 750 {} \; \
    && find /app -type f -name 'run_*' -exec chmod 750 {} \;





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

STOPSIGNAL SIGKILL

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]