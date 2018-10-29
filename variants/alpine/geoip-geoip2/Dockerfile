FROM alpine:3.8

COPY hlstatsx-community-edition/scripts /app

# Set permissions
RUN find /app -type d -exec chmod 750 {} \; \
        && find /app -type f -exec chmod 640 {} \; \
        && find /app -type f -name '*.sh' -exec chmod 750 {} \; \
        && find /app -type f -name '*.pl' -exec chmod 750 {} \; \
        && find /app -type f -name 'run_*' -exec chmod 750 {} \;

# Download the GeoIP binary
RUN cd /app/GeoLityCity \
    && ./install_binary.sh \
    && chmod 666 GeoLiteCity.dat \
    && rm -f GeoLiteCity.dat.gz

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

# Install modules for perl GeoIP
RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && cpanm \
        Geo::IP::PurePerl \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus /var/cache/apk/*

# Install modules for perl GeoIP2
# 11 dependencies missing for GeoIP2:
#   - 11 dependencies missing (Data::Validate::IP,LWP::Protocol::https,List::SomeUtils,MaxMind::DB::Metadata,MaxMind::DB::Reader,Moo,Moo::Role,Params::Validate,Path::Class,Throwable::Error,namespace::clean);
RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && apk add --no-cache \
        perl-datetime \
        perl-netaddr-ip \
        perl-libwww \
        perl-lwp-protocol-https \
        perl-list-someutils \
        perl-params-validate \
        perl-namespace-clean \
        perl-list-allutils \
        perl-path-class \
        #perl-moo \
        #perl-net-ip \
    && cpanm \
        GeoIP2 \
        MaxMind::DB::Reader \
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
# NOTE: Not working atm, tests fail at MAXMIND's Net::Works::Network
#
    # && apk add --no-cache \
    #     libmaxminddb \
    #     libmaxminddb-dev \
    # && cpanm \
    #     MaxMind::DB::Reader::XS \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus /var/cache/apk/*

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 27500/udp

STOPSIGNAL SIGINT

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["perl", "./hlstats.pl"]