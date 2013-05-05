# Dwarf Fortress Bootstrap

Build your own Dwarf Fortress installation for Linux with no nonsense.

Installs:

    * Dwarf Fortress - latest version
    * dfhack - latest version
    * Dwarf Therapist - splinterz's fork
    * Soundsense - latest version

To be added someday:

    * Quick fort
    * ??

**Supported Distros**:

    * Fedora
    * Ubuntu (started, but not tested, please submit a bug report)

Help me add more! See Contributing section below.

# Usage 

## Quickstart

```bash
    $ git clone https://github.com/Ramblurr/df-bootstrap
    $ cd df-bootstrap
    $ ./src/prepare-YOUR_DISTRO.sh
    $ make
    $ ./df
```

## Advanced

At the top of the `Makefile` you can customize the versions to install.

# Contributing

To add a distro:

1. Create a `src/prepare-DISTRO.sh` that installs all the necessary packages.
2. Edit `Makefile`'s install-df section to do any post-install commands
3. Test! `make nuke-everything && ./src/prepare-DISTRO.sh && make`
4. Commit and send a pull request

# Issues

* splinterz isn't using tags in his DT repo, so there's no way to fetch the latest
release, as opposed to the most recent source code update.
* soundsense's latest version also cannot be easily determined

# Credits

* Dr. KillPatient - df_autoget script

