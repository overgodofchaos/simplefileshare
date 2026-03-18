#!/bin/sh

set -e

TARGET_DIR="/data/files"

cd "${TARGET_DIR}" || exit 1

if [ ! -d ".git" ]; then
    echo "Directory is empty. Cloning ${GIT_REPO}"
    git clone "${GIT_REPO}" . || exit 1
else
    echo "Pulling updates from ${GIT_REPO}"
    git pull --quiet || exit 1
fi

chown -R nginx:nginx "${TARGET_DIR}" || true
find "${TARGET_DIR}" -type d -exec chmod 755 {} \;
find "${TARGET_DIR}" -type f -exec chmod 644 {} \;
chmod 644 "${TARGET_DIR}"/.htpasswd 2>/dev/null || true

echo "Sync completed at $(date)"