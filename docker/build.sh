#!/bin/sh

# Import ambitorio_eds, ambitorio_ipfs and ambitorio_sync_ipfs repositories and
# build docker images for the three of them
#
# Also, if ipfs user and $EDS_BASE_PATH don't exist, create them

. ./settings.sh

if [[ ! -d '.git' ]];then
    cd ..
fi

if [ "$1" == "setup" ]; then
    id -u ipfs 2>/dev/null >/dev/null
    if [ "$?" -ne 0 ]; then
        if [ "$EUID" -ne 0 ]; then
            echo "We need to create the ipfs user and group, but we're not running as root"
            exit 1
        fi
        useradd -r -d "$EDS_BASE_DIR" ipfs
        if [ "$?" -ne 0 ]; then
            echo "Unable to create ipfs user"
            exit 1
        fi
    fi

    if [ ! -e "$EDS_BASE_DIR" ] || [ ! -e "$IPFS_DATA_DIR" ]; then
        if [ "$EUID" -ne 0 ]; then
            echo "We need to create $EDS_BASE_DIR and set its ownership, but we're not running as root"
            exit 1
        fi
        for d in "$EDS_BASE_DIR" "$IPFS_DATA_DIR"; do
            mkdir -p "$d"
        done
        chmod 700 "$EDS_BASE_DIR"
        chown ipfs.ipfs "$EDS_BASE_DIR" -R
        if [ "$?" -ne 0 ]; then
            echo "Unable to chown ownership of IPFS directory"
            exit 1
        fi
    fi
    exit 0
fi

git pull
if [[ "$?" != "0" ]];then
    echo ARGH!
    exit 1
fi

# Import ambitorio_ipfs and build
if [ ! -e ambitorio_ipfs ]; then
    git clone git@bitbucket.org:jdieter/ambitorio_ipfs.git
    if [ "$?" -ne 0 ]; then
        exit 1
    fi
fi
cd ambitorio_ipfs
docker/build.sh
if [ "$?" -ne 0 ]; then
    exit 1
fi
cd ..

# Import ambitorio_sync_ipfs and build
if [ ! -e ambitorio_sync_ipfs ]; then
    git clone git@bitbucket.org:jdieter/ambitorio_sync_ipfs.git
    if [ "$?" -ne 0 ]; then
        exit 1
    fi
fi
cd ambitorio_sync_ipfs
docker/build.sh
if [ "$?" -ne 0 ]; then
    exit 1
fi
cd ..
