@'
# Install modules for perl-based email
RUN apt-get update \
    && apt-get install -y \
        libio-socket-ssl-perl \
        libnet-ssleay-perl \
        libwww-perl \
        libemail-sender-perl \
    #&& cpanm Email::Sender::Simple \
        #IO::Socket::SSL \
        #Net-SSLeay \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/
'@