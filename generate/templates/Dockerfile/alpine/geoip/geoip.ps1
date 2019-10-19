@'
# Install modules for perl GeoIP
RUN apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && cpanm \
        Geo::IP::PurePerl \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus
'@
