#!/bin/bash
cd /home/container || exit 1

INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

MONGODB_DATA=/home/container/mongodb_data
MONGODB_DEFAULT_PORT=27017
MONGODB_READY_TIMEOUT_SECONDS=30

default_route_interface() {
    ip -o route show default | sed -n 's/.* dev \([^ ]*\).*/\1/p' | head -n 1
}

uses_host_network() {
    local interface
    interface=$(default_route_interface)
    [[ -n $interface ]] || return 1
    [[ $(cat "/sys/class/net/$interface/iflink") == $(cat "/sys/class/net/$interface/ifindex") ]]
}

wait_for_mongodb() {
    local seconds_waited=0
    until nc -z 127.0.0.1 "$MONGODB_PORT" 2>/dev/null; do
        if (( seconds_waited >= MONGODB_READY_TIMEOUT_SECONDS )); then
            echo "MongoDB did not accept connections on port $MONGODB_PORT within $MONGODB_READY_TIMEOUT_SECONDS seconds."
            return 1
        fi
        sleep 1
        seconds_waited=$((seconds_waited + 1))
    done
}

if uses_host_network; then
    MONGODB_PORT=$SERVER_PORT
    echo "Host network detected: MongoDB uses the server port $MONGODB_PORT."
else
    MONGODB_PORT=$MONGODB_DEFAULT_PORT
    echo "Bridge network detected: MongoDB uses the default port $MONGODB_PORT."
fi
export MONGODB_PORT
export MONGODB_URI="mongodb://127.0.0.1:$MONGODB_PORT"

[[ ${MONGODB_QUIET,,} == @(1|true) ]] && MONGODB_OUTPUT=/dev/null || MONGODB_OUTPUT=/dev/stdout

mkdir -p "$MONGODB_DATA"
mongod --bind_ip 127.0.0.1 --port "$MONGODB_PORT" --dbpath "$MONGODB_DATA" --quiet &> "$MONGODB_OUTPUT" &
wait_for_mongodb || exit 1

node -v

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

trap ':' INT TERM
eval ${MODIFIED_STARTUP}
app_exit_code=$?

echo "Stopping MongoDB..."
mongod --shutdown --dbpath "$MONGODB_DATA" &> "$MONGODB_OUTPUT"
exit $app_exit_code
