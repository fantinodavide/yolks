#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

[[ ! -e /home/container/mongodb_data ]] && mkdir /home/container/mongodb_data
# Start MongoDB bound to 127.0.0.1
mongod --bind_ip 127.0.0.1 --port ${MONGODB_INTERNAL_PORT} --dbpath /home/container/mongodb_data &

# Print Node.js Version
node -v

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
