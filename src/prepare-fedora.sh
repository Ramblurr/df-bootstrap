#!/bin/bash

# basic development packages
sudo yum groupinstall 'Development Tools'

# ccache seems to cause problems with dfhack
sudo yum -y remove ccache

# dfhack dependencies
sudo yum install libgcc.i686 git cmake glibc-devel.i686 zlib-devel.i686 perl-XML-LibXSLT perl-XML-LibXML

# dwarf therapist dependencies
sudo yum install mercurial qt.i686 libgcc.i686 qt-devel

# dwarf fortress dependencies
sudo yum install \
    SDL.i686 \
    SDL_image.i686 \
    SDL_ttf.i686 \
    gtk2.i686 \
    mesa-libGLU.i686 \
    openal-soft.i686 \
    libsndfile.i686

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "fedora" > $SRC_DIR/distro
