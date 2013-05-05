#!/bin/bash
# DF Autoget v1.1 for Linux, by Dr. KillPatient
# Automatically downloads the latest Dwarf Fortress on Linux
# Can also, optionally, be used to manage older versions upon installing newer
# ones and to migrate old saves to new installations
set -e # Exit on error

function usage() {
cat >&2 <<EOF
$0: [options]

Download or upgrade Dwarf Fortress

Options:
    -v: version number, defaults to latest
    -d: directory to extract DF to, defaults to current dir
    -r: remove df archive after extraction, default is no

EOF
}


REMOVE_ARCHIVE=
DF_EXTRACT_DIR=`pwd`

while getopts "hv:d:r" OPT
do
    case $OPT in
        v)
            DF_VERSION_STRING=$OPTARG
            ;;
        d)
            DF_EXTRACT_DIR=$OPTARG
            ;;
        r)
            REMOVE_ARCHIVE=1
            ;;
        h)
            usage
            exit
            ;;
        ?)
            usage
            exit
            ;;
    esac
done

if [[ -z $DF_VERSION_STRING ]]; then
    # Figure out the latest version of DF by reading Toady's release feed
    DF_VERSION_STRING=`wget -q -O- "http://bay12games.com/dwarves/dev_release.rss" | grep 'Released' | awk -F"DF" '{split($2,a," ");print a[1]}'`
    printf 'Latest version of Dwarf Fortress is %s.\n\n' $DF_VERSION_STRING
else
    printf 'Downloading version %s.\n\n' $DF_VERSION_STRING
fi

# Figure out what file we need to download using the information we've gathered
DF_FILE="df_`echo $DF_VERSION_STRING | sed 's/\./_/g' | sed 's/0_//'`_linux.tar.bz2"
echo $DF_FILE

# Exit if we already have the latest DF downloaded.
if [ -f "$DF_FILE" ]; then
    printf "You seem to have the DF %s already, saved under the filename\n\
%s in this directory.\n\n" $DF_VERSION_STRING $DF_FILE

    read -p "Would you still like to install? The download step will be skipped. (Y/n): "
    if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ] || [ "$REPLY" == "" ]; then
        DF_SKIP_DOWNLOAD=true
    else
        exit 0
    fi
    printf '\n'
fi

# Get DF from the constructed URL and extract the contents
if [ "$DF_SKIP_DOWNLOAD" != "true" ]; then
    printf "Attempting to download Dwarf Fortress %s from\n\
http://www.bay12games.com/dwarves/%s...\n\n" $DF_VERSION_STRING $DF_FILE
    wget "http://www.bay12games.com/dwarves/$DF_FILE"
    printf "Download completed successfully.\n\n"
fi

# Ask the user where to install (extract) DF
DF_INSTALLED=false
while [ $DF_INSTALLED == "false" ]; do

    # Default to current directory
    if [ "$DF_EXTRACT_DIR" == "" ]; then
        DF_EXTRACT_DIR=`pwd`
    fi

    if [ -d "$DF_EXTRACT_DIR" ]; then
        if [ -w "$DF_EXTRACT_DIR" ]; then
            # If it appears that DF has already been extracted here, ask the user what to do
            if [ -d "$DF_EXTRACT_DIR/df_linux" ]; then
                # Figure out the version of the already-present DF and inform the user
                # Be sure to truncate DOS-specific characters that would otherwise screw up the string
                DF_VERSION_STRING_OLD=`cat "$DF_EXTRACT_DIR"/df_linux/file\ changes.txt | tr -d '\015' | grep "Auxiliary file changes" | head -1 | awk '{print $5}' | sed 's/://'`
                printf "It appears that the directory \'df_linux\' already exists in the directory\n\
that you have chosen. \n\n"

                if [ "$DF_VERSION_STRING_OLD" != "$DF_VERSION_STRING" ]; then
                    printf "Its version seems to be %s. This differs from the version of the installation candidate, DF %s.\n" $DF_VERSION_STRING_OLD $DF_VERSION_STRING
                else
                    printf "It is of the same version as the installation candidate.\n"
                fi

                    COPY_OLD_SAVES=false
                    DF_OLD_FIXED=false   
                    DF_OLD_FILENAME="df_linux_"`echo $DF_VERSION_STRING_OLD | sed 's/\./_/g'`
                    
                    # Ask the user what to do with the preexisting df_linux folder
                while [ "$DF_OLD_FIXED" == "false" ]; do
                    printf "\nWhat do you want to do to the existing \'df_linux\' folder?\n"
                    printf "It contains DF version $DF_VERSION_STRING_OLD.\n\n"
                    printf "(1) Backup, renaming it to \'$DF_OLD_FILENAME\'. (default, recommended)\n"
                    printf "(2) Remove it. (This could cause you to lose data!)\n"
                    printf "(3) Leave it alone and abort the installation.\n\n"
                    read -p "Your choice: "

                    if [ "$REPLY" == "" ] || [ "$REPLY" == "1" ]; then
                        printf "Renaming %s/df_linux to \'%s\'...\n" $DF_EXTRACT_DIR $DF_OLD_FILENAME
                        mv "$DF_EXTRACT_DIR/df_linux" "$DF_EXTRACT_DIR/$DF_OLD_FILENAME"
                        printf "Done.\n\n"

                        # Offer to migrate old save files, if there are any
                        if [ -d "$DF_EXTRACT_DIR/$DF_OLD_FILENAME/data/save" ]; then
                            printf "The folder that you've just chosen to rename contains a 'save' folder.\n\
If this is a version of Dwarf Fortress that you have played before, it may\n\
contain your saved games. Would you like to copy these saves to the new\n\
version of Dwarf Fortress upon installation?\n"
                            read -p "(Y/n) "
                            echo
                            if [ "$REPLY" != "n" ] || [ "$REPLY" != "N" ]; then
                                COPY_OLD_SAVES=true
                            fi
                        fi
                        DF_OLD_FIXED=true
                    elif [ "$REPLY" == "2" ]; then
                        printf "Removing %s/df_linux...\n" $DF_EXTRACT_DIR
                        rm -r "$DF_EXTRACT_DIR/df_linux"
                        printf "Done.\n\n"
                        DF_OLD_FIXED=true
                    elif [ "$REPLY" == "3" ]; then
                        exit 0
                    else
                        printf "Invalid entry.\n\n"
                    fi
                done
            fi

            printf "%s is writable.\n" $DF_EXTRACT_DIR 
            printf "Installing to %s...\n\n" $DF_EXTRACT_DIR 
            tar jxf "$DF_FILE" -C "$DF_EXTRACT_DIR"

            # Copy over old saves, if the user chose to do so earlier
            if [ "$COPY_OLD_SAVES" == "true" ]; then
                printf "Copying saves to new installation from %s/%s...\n" $DF_EXTRACT_DIR $DF_OLD_FILENAME
                cp -r $DF_EXTRACT_DIR/$DF_OLD_FILENAME/data/save $DF_EXTRACT_DIR/df_linux/data/save
                printf "Done.\n"
            fi
            DF_INSTALLED=true
        else
            read -p "ERROR: Specified directory $DF_EXTRACT_DIR is not writable. Abort? (y/N): "
            if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
                exit 0
            else
                printf "Retrying...\n\n"
            fi
        fi
    else
        read -p "ERROR: Specified directory $DF_EXTRACT_DIR does not exist. Abort? (y/N): "
        if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
            exit 0
        else
            printf "Retrying...\n\n"
        fi
    fi
done
printf "DF %s installed to %s as df_linux.\n\n" $DF_VERSION_STRING $DF_EXTRACT_DIR
if [[ $REMOVE_ARCHIVE -eq 1 ]]; then
    rm "$DF_FILE"
fi
