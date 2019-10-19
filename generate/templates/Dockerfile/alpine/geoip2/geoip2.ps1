@'
# Install modules for perl GeoIP2
# 11 dependencies missing for GeoIP2:
#   - 11 dependencies missing (Data::Validate::IP,LWP::Protocol::https,List::SomeUtils,MaxMind::DB::Metadata,MaxMind::DB::Reader,Moo,Moo::Role,Params::Validate,Path::Class,Throwable::Error,namespace::clean);
RUN apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    #&& apk add --no-cache \
        #perl-datetime \
        #perl-path-class \
        perl-net-ssleay \
        #perl-libwww \
        #perl-lwp-protocol-https \
        #perl-netaddr-ip \
        #perl-list-someutils \
        #perl-params-validate \
        #perl-namespace-clean \
        #perl-list-allutils \
        #perl-moo \
        #perl-net-ip \
    && cpanm \
        MaxMind::DB::Reader \
        GeoIP2 \
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
    && rm -rf /root/.cpan /root/.cpanminus
'@
