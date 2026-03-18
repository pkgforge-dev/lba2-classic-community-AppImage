#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    libdecor \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package libsmacker

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of lba2 community..."
echo "---------------------------------------------------------------"
REPO="https://github.com/LBALab/lba2-classic-community"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./lba2-community
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./lba2-community
mkdir -p build && cd build
cmake .. \
      -DSOUND_BACKEND=sdl \
      -DMVIDEO_BACKEND=smacker \
      -DCONSOLE_MODULE=ON
make -j$(nproc)
mv -v SOURCES/lba2 ../../AppDir/bin
