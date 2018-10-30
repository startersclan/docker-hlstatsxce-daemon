@'
# Install modules for perl-based email
RUN apt-get update \
    && apt-get install -y \
        libnet-ssleay-perl \
        libio-socket-ssl-perl \
        #libwww-perl \
        #libemail-sender-perl \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && cpanm \
        MIME::Base64 \
        Authen::SASL \
    && cpanm \
        Email::Sender::Simple \
    && apt-get purge --auto-remove -y \
        build-essential \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/
'@