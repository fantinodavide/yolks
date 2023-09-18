# Base image
FROM --platform=$TARGETOS/$TARGETARCH node:20-bullseye-slim

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=container HOME=/home/container

# Install dependencies and MongoDB
RUN apt update -y \
    && apt install -y netcat iproute2 mongodb ffmpeg git sqlite3 libsqlite3-dev python3 python3-dev ca-certificates dnsutils tzdata zip tar curl build-essential libtool iputils-ping libnss3 \
    && useradd -d /home/container -m container -s /bin/bash \
    && npm install npm@latest typescript ts-node @types/node --location=global

# Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh

# Workdir and CMD
WORKDIR /home/container
USER container
CMD ["/bin/bash", "/entrypoint.sh"]
