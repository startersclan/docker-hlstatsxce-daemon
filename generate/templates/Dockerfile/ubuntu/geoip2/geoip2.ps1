@'
# Install modules for perl GeoIP2
RUN set -eux \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        cpanminus \
    && apt-get update && apt-get install -y \
        libnet-ssleay-perl \
        #libio-socket-ssl-perl \
        #libwww-perl \
        #libdatetime-perl \
    # Install older version of Test::Without::Module, since Test::Without::Module@0.21 seems to fail tests randomly. See: https://metacpan.org/release/CORION/Test-Without-Module-0.21
    && cpanm \
        Test::Without::Module@0.20 \
    && cpanm \
        MaxMind::DB::Reader \
    && cpanm \
        GeoIP2 \
# Install maxmind DB::Reader::XS (faster than MaxMind::DB::Reader)
# See: https://github.com/maxmind/libmaxminddb
    && apt-get update && apt-get install -y \
        software-properties-common \
    && add-apt-repository -y ppa:maxmind/ppa \
    && apt-get update \
    && apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
    && cpanm \
        MaxMind::DB::Reader::XS \
    && apt-get purge --auto-remove -y \
        build-essential \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/* /root/.cpan/ /root/.cpanm/
'@
