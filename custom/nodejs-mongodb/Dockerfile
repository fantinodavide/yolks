# Base image
FROM --platform=$TARGETOS/$TARGETARCH node:20-bullseye-slim

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=container HOME=/home/container

# Update package list
RUN apt update -y

# Install dependencies
RUN apt install -y netcat iproute2 ffmpeg git sqlite3 libsqlite3-dev python3 python3-dev ca-certificates dnsutils tzdata zip tar curl build-essential libtool iputils-ping libnss3

# Install MongoDB
RUN apt update -y && apt install -y gnupg wget \
    && wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
    && apt update -y \
    && apt install -y mongodb-org

# Create user and install Node.js packages
RUN useradd -d /home/container -m container -s /bin/bash \
    && npm install npm@latest typescript ts-node @types/node --location=global

# Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh

# Workdir and CMD
WORKDIR /home/container
USER container
CMD ["/bin/bash", "/entrypoint.sh"]
