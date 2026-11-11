FROM --platform=$TARGETOS/$TARGETARCH mongo:5.0-focal

LABEL org.opencontainers.image.source="https://github.com/fantinodavide/yolks" \
      org.opencontainers.image.description="Node.js 20 and MongoDB 5.0 in one container for Pterodactyl and Pelican" \
      org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

COPY ./apt-update-with-retry.sh /usr/local/bin/apt-update-with-retry

RUN rm -f /etc/apt/sources.list.d/mongodb-org.list \
    && sh /usr/local/bin/apt-update-with-retry \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        dnsutils \
        ffmpeg \
        git \
        gnupg \
        iproute2 \
        iputils-ping \
        libnss3 \
        libsqlite3-dev \
        libtool \
        netcat-openbsd \
        python3 \
        python3-dev \
        sqlite3 \
        tar \
        tini \
        tzdata \
        zip \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && sh /usr/local/bin/apt-update-with-retry \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install --global typescript ts-node @types/node \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/* /tmp/* /usr/local/bin/apt-update-with-retry \
    && useradd -d /home/container -m container -s /bin/bash

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
