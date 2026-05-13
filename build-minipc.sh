#!/bin/bash
set -e

git clone https://github.com/sterling5241/build --branch bpi-main --depth=1
cd build

curl -o config/boards/bigtreetech-cb1.conf \
  https://raw.githubusercontent.com/sterling5241/PC-CB1/main/build/config/boards%20/bigtreetech-cb1.conf

curl -o lib/functions/rootfs/distro-agnostic.sh \
  https://raw.githubusercontent.com/sterling5241/PC-CB1/main/lib/functions/rootfs/distro-agnostic.sh

./compile.sh \
  BOARD=bigtreetech-cb1 \
  BRANCH=current \
  RELEASE=trixie \
  BUILD_MINIMAL=yes \
  BUILD_DESKTOP=no \
  KERNEL_CONFIGURE=no \
  CONSOLE_AUTOLOGIN=yes \
  PACKAGE_LIST_ADDITIONAL="armbian-install"
