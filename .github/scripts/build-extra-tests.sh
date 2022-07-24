#!/bin/bash

# turn echo on and error on earliest command
set -ex

# get shared variables
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/defaults.sh

export RISCV="$GITHUB_WORKSPACE/riscv-tools-install"
export LD_LIBRARY_PATH="$RISCV/lib"
export PATH="$RISCV/bin:$PATH"

ls -alh $RISCV
ls -alh $RISCV/riscv64-unknown-elf/lib

make -C $LOCAL_CHIPYARD_DIR/tests clean
make -C $LOCAL_CHIPYARD_DIR/tests
