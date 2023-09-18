#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# MongoDB
[[ ! -e /home/container/mongodb_data ]] && mkdir /home/container/mongodb_data
[[ $MONGODB_QUIET -eq 1 ]] && QUIET_OUT="/dev/null" || QUIET_OUT="/dev/stdout"
mongod --bind_ip 127.0.0.1 --port ${MONGODB_INTERNAL_PORT} --dbpath /home/container/mongodb_data --quiet &> $QUIET_OUT &

# Print Node.js Version
node -v

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
