#!/bin/sh

set -e

if [ "${GIT_ENABLED}" = "true" ] && [ -n "${GIT_REPO}" ]; then
    echo "Initial git sync..."
    /usr/local/bin/git-sync.sh
fi

if [ "${GIT_ENABLED}" = "true" ] && [ -n "${GIT_SYNC_INTERVAL}" ]; then
    echo "${GIT_SYNC_INTERVAL} /usr/local/bin/git-sync.sh >> /var/log/git-sync.log 2>&1" > /etc/crontabs/root
    echo "Cron scheduled: ${GIT_SYNC_INTERVAL}"
    crond -f -l 8 &
fi

exec nginx -g 'daemon off:'