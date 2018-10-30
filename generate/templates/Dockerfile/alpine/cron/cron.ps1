@'
# Install basic tools for cron
RUN apk add --no-cache \
        curl \
        wget \
        openssl
'@