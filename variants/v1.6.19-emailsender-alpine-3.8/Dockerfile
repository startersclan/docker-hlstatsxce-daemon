FROM alpine:3.8

# Get hlstatsxce perl daemon scripts and set permissions
RUN apk add --no-cache git \
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
    && apk del git

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

# Install modules for perl-based email (SMTPS)
RUN apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && apk add --no-cache \
        perl-net-ssleay \
        perl-io-socket-ssl \
    # Email::Sender::Simple requires these dependencies
    && cpanm \
        MIME::Base64 \
        Authen::SASL \
    && cpanm \
        Email::Sender::Simple \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGINT

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]