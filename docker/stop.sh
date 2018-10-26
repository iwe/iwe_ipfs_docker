#!/bin/bash

. ./settings.sh

export IPFS_UID=$(id -u ipfs)
export IPFS_GID=$(id -g ipfs)
export DATA_DIR="$IPFS_DATA_DIR"
export FILELIST_URL="$FILELIST_URL"
export PUBLIC_KEY="$PUBLIC_KEY"
docker-compose down
