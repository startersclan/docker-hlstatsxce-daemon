@'
FROM alpine:3.8

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
'@