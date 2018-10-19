@'
# Install modules for perl GeoIP2
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && apt-get update && apt-get install -y \
        libio-socket-ssl-perl \
        libnet-ssleay-perl \
        libwww-perl \
        libdatetime-perl \
    && cpanm \
        GeoIP2 \
        MaxMind::DB::Reader \
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
    && apt-get update && apt-get install -y \
        software-properties-common \
    && add-apt-repository -y ppa:maxmind/ppa \
    && apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
    && cpanm \
        MaxMind::DB::Reader::XS \
    && apt-get purge --auto-remove -y \
        build-essential  \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/
'@