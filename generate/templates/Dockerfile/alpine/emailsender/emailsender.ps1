@'
# Install modules for perl GeoIP
RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && cpanm \
        Email::Sender::Simple \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus /var/cache/apk/*
'@