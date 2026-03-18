#!/bin/sh

set -e

git config --global --add safe.directory /data/files

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ -f /root/ssh/config ]; then
    cp /root/ssh/config /root/.ssh/config
    chmod 600 /root/.ssh/config
    chown root:root /root/.ssh/config
fi

if [ -f /root/ssh/key ]; then
    cp /root/ssh/key /root/.ssh/key
    chmod 600 /root/.ssh/key
    chown root:root /root/.ssh/key
fi

if [ "${GIT_ENABLED}" = "true" ] && [ -n "${GIT_REPO}" ]; then
    echo "Initial git sync..."
    /usr/local/bin/git-sync.sh
fi

if [ "${GIT_ENABLED}" = "true" ] && [ -n "${GIT_SYNC_INTERVAL}" ]; then
    echo "${GIT_SYNC_INTERVAL} /usr/local/bin/git-sync.sh >> /var/log/git-sync.log 2>&1" > /etc/crontabs/root
    echo "Cron scheduled: ${GIT_SYNC_INTERVAL}"
    crond -f -l 8 &
fi

exec nginx -g 'daemon off;'