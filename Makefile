#
## Versions of apps to be installed
#
#
DF_VERSION         = 0.34.11
DFHACK_VERSION     = 0.34.11-r3
SOUNDSENSE_VERSION = 41_181

# (dwarftherapist is always built from latest source)

###########################################################
.SILENT:


#
## qmake location
### detect qmake across distros
#

# most distros call it qmake, but a few call it qmake-qt4
QMAKE := $(shell which qmake 2> /dev/null)
ifeq ($(QMAKE),)
QMAKE := $(shell which qmake-qt4 2> /dev/null )
endif

ifeq ($(QMAKE),)
$(error qmake not found. Did you install the dependencies? See README.md)
endif

DISTRO = $(shell cat src/distro)

all: install-dfhack install-ss install-dt

#
## dfhack
#

src/dfhack/.dirstamp:
	git submodule update --init --recursive && \
	cd src/dfhack && git checkout $(DFHACK_VERSION) && \
	git submodule update --init --recursive && \
	touch .dirstamp

fetch-dfhack: src/dfhack/.dirstamp

build-dfhack: fetch-dfhack
	cd src/dfhack/build/ && \
	cmake .. -DCMAKE_BUILD_TYPE:string=Release -DCMAKE_INSTALL_PREFIX=$(CURDIR)/df_linux -DCMAKE_THREAD_PREFER_PTHREAD=true && \
	make -j4

install-dfhack: install-df build-dfhack
	cd src/dfhack/build && make install

clean-dfhack:
	cd src/dfhack/ && rm -rf build && git checkout build

distclean-dfhack:
	-rm -rf src/dfhack/
	git checkout src/dfhack

#
## Dwarf Therapist
#

src/dwarftherapist:
	hg clone https://code.google.com/r/splintermind-attributes/ src/dwarftherapist

src/dwarftherapist/.dirstamp: src/dwarftherapist
	touch src/dwarftherapist/.dirstamp

fetch-dt: src/dwarftherapist/.dirstamp

build-dt: fetch-dt
	cd src/dwarftherapist && \
	$(QMAKE) && \
	make -j4

install-dt: build-dt

clean-dt:
	cd src/dwarftherapist/ && make clean

distclean-dt:
	-rm -rf src/dwarftherapist

#
## Soundsense
#

src/soundsense:
	wget https://df-soundsense.googlecode.com/files/soundSense_$(SOUNDSENSE_VERSION).zip -O src/soundSense_$(SOUNDSENSE_VERSION).zip && \
	cd src && unzip soundSense_$(SOUNDSENSE_VERSION).zip

fetch-ss: src/soundsense

install-ss: fetch-ss
	cd src/soundsense/ && \
	sed -i 's|../gamelog.txt|../../df_linux/gamelog.txt|' configuration.xml

clean-ss:

distclean-ss:
	-rm src/soundSense_*.zip
	-rm -rf src/soundsense/

#
## Dwarf Fortress
#

df_linux:
	cd src/ && \
	./df_autoget.sh -v $(DF_VERSION) -d ../

fetch-df: df_linux

install-df: fetch-df
	touch df_linux/gamelog.txt

# Fedora specific post-install
ifeq ($(DISTRO), fedora)
		echo "Post-install for Fedora"
		# Use system libstdc
		-mv df_linux/libs/libstdc++.so.6 df_linux/libs/libstdc++.so.6.orig
		# symlink libopenal in place so DF can find it
		-ln -s /usr/lib/libopenal.so.1 df_linux/libs/libopenal.so
endif

# Ubuntu specific post-install
ifeq ($(DISTRO), ubuntu)
		echo "Post-install for Ubuntu"
		# TODO
endif

clean-df:

distclean-df:
	-rm src/df_*_linux.tar.bz2
	-rm -rf df_linux

# global

clean: clean-df clean-ss clean-dfhack clean-dt

distclean:
	echo
	echo "THIS WILL DELETE EVERYTHING"
	echo "INCLUDING YOUR SAVE GAMES"
	echo
	echo "If you really want to continue type: make nuke-everything"
	echo

nuke-everything: distclean-df distclean-ss distclean-dfhack distclean-dt

