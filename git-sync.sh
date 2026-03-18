#!/bin/sh

set -e

TARGET_DIR="/data/files"

cd "${TARGET_DIR}" || exit 1

if [ ! -d ".git" ]; then
    echo "Directory is empty. Cloning ${GIT_REPO}"
    git clone "${GIT_REPO}" . || exit 1
else
    exho "Pulling updates from ${GIT_REPO}"
    git pull --quiet || exit 1
fi

chown -R nginx:nginx "${TARGET_DIR}"
chmod -R 777 "${TARGET_DIR}"
chmod -R 644 "${TARGET_DIR}"/* "${TARGET_DIR}"/.htpassws 2>/dev/null || true

echo "Sync completed at $(date)"