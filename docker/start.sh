#!/bin/sh

# We use docker-compose to create three containers, ambitorio_eds,
# ambitorio_ipfs and ambitorio_sync_ipfs.
#
# ambitorio_ipfs contains the IPFS daemon that communicates with the other IPFS
# nodes.
#
# ambitorio_eds has an ipfs binary that communicates with the ipfs container
# over port 5001 (which is only open on the private docker network) and listens
# for /get, /put and /genkeypair requests on port 5000
#
# ambitorio_sync_ipfs checks $FILELIST_URL every minute to see which files to
# pin and which to unpin

. ./settings.sh

export IPFS_UID=$(id -u ipfs)
export IPFS_GID=$(id -g ipfs)
export DATA_DIR="$IPFS_DATA_DIR"
export FILELIST_URL="$FILELIST_URL"
export PUBLIC_KEY="$PUBLIC_KEY"
docker-compose up -d
if [ "$1" != "ansible" ]; then
    docker-compose logs -f --tail=10
fi
