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

## Quickstart

```bash
    $ git clone https://github.com/Ramblurr/df-bootstrap
    $ cd df-bootstrap
    $ make
    $ ./df
```

## Dependencies

TODO: write this
git
svn
hg

## Advanced

At the top of the `Makefile` you can customize the versions to install.

## Why?

Dwarf fortress packaging is a PITA. Most distros don't allow non-free binary
blobs in their packages, so getting DF included is not really possible. Even
then the multitude of other utilities can be a PITA to run as well.

## Issues

* splinterz isn't using tags in his repo, so there's no way to fetch the latest
release, as opposed to the most recent source code update.

## Credits

* Dr. KillPatient - df_autoget script

