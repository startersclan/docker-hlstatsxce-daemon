@'
# Install basic tools for cron
RUN apt-get update \
    && apt-get install -y \
        curl \
        wget \
        openssl \
    && rm -rf /var/lib/apt/lists/*
'@