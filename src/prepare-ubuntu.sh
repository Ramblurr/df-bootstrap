#!/bin/bash

# This is untested, it's waiting for some kind soul
# to come along and make it work.

# basic development packages
sudo apt-get install build-essential

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get upgrade


# dfhack dependencies
sudo apt-get install \
    ia32-libs \
    ia32-libs-gtk \
    gcc-4.4-multilib \
    g++-4.4-multilib \
    libxml-libxml-perl \
    lib32z-dev \
    libxml-libxslt-perl

# dwarf therapist dependencies
sudo apt-get install \
    libqt4-dev \
    qt4-qmake
    # qt4-dev-tools \

# dwarf fortress dependencies
sudo apt-get install \
    libsdl-ttf2.0-0:i386 \
    ia32-libs-gtk \
    libsdl-image1.2:i386 \
    libopenal-dev:i386

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "fedora" > $SRC_DIR/distro
