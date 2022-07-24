#!/bin/bash

# create the riscv tools/esp tools binaries
# passed in as <riscv-tools or esp-tools>

# turn echo on and error on earliest command
set -ex

# get shared variables
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/defaults.sh

if [ ! -d "$LOCAL_CHIPYARD_DIR/$1-install" ]; then
    cd $LOCAL_CHIPYARD_DIR

    # init all submodules including the tools
    # TODO: Is this better than hard coding it to CI_MAKE_NPROC?
    NPROC=$(($(nproc) + 1)) ./scripts/build-toolchains.sh $1

    # de-init the toolchain area to save on space (forced to ignore local changes)
    git -C $LOCAL_CHIPYARD_DIR submodule deinit --force toolchains/$1
fi
