#!/bin/sh
set -u

max_attempts=5
retry_delay_seconds=15
log_file=/tmp/apt-update.log

attempt=1
while :; do
    apt-get update 2>&1 | tee "$log_file"
    if ! grep -qE '^(W|E): Failed to fetch' "$log_file"; then
        rm -f "$log_file"
        exit 0
    fi
    if [ "$attempt" -ge "$max_attempts" ]; then
        echo "apt-get update failed to fetch some sources after $max_attempts attempts." >&2
        exit 1
    fi
    echo "Retrying apt-get update in $retry_delay_seconds seconds (attempt $attempt of $max_attempts failed)."
    attempt=$((attempt + 1))
    sleep "$retry_delay_seconds"
done
