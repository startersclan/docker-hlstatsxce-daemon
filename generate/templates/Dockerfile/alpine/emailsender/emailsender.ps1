@'
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
    && rm -rf /root/.cpan /root/.cpanm /root/.cpanminus
'@
