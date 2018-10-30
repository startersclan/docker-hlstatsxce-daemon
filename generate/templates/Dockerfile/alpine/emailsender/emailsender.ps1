@'
# Install modules for perl-based email (SMTPS)
RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        build-base \
        perl-app-cpanminus \
    && apk add --no-cache \
        perl-net-ssleay \
    # Email::Sender::Simple requires these dependencies
    && cpanm \
        MIME::Base64 \
        Authen::SASL \
    && cpanm \
        Email::Sender::Simple \
    && apk del build-dependencies \
    && rm -rf /root/.cpan /root/.cpanminus /var/cache/apk/*
'@