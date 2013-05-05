# Dwarf Fortress Bootstrap (beta)

Build your own Dwarf Fortress installation from source with no nonsense. All the shit you need. It Just Works†

**Installs:**

* [Dwarf Fortress](http://www.bay12games.com/dwarves/)
* [dfhack](https://github.com/peterix/dfhack)
* [splinterz's Dwarf Therapist](https://code.google.com/r/splintermind-attributes/) fork
* [Soundsense](http://df.zweistein.cz/soundsense/)

**Supported Distros**:

* Fedora
* Ubuntu (started, but not tested, please test and submit an issue)

Help me add more! See Contributing section below.

    
#### **†** Might not just work yet, it's still in beta.

# Usage 

## Quickstart

*From nothing to a full blown install with (almost) all the fixins*.

```bash
    $ git clone https://github.com/Ramblurr/df-bootstrap
    $ cd df-bootstrap
    $ ./src/prepare-YOUR_DISTRO.sh
    $ make
```

Run your newly created DF install:
```bash
    $ ./DwarfTherapist
    $ ./SoundSense
    $ ./DwarfFortress
```

## Advanced

At the top of the `Makefile` you can customize the versions to install.

# Contributing

To add a distro:

1. Create a `src/prepare-DISTRO.sh` that installs all the necessary packages.
2. Edit `Makefile`'s install-df section to do any post-install commands
3. Test! `make nuke-everything && ./src/prepare-DISTRO.sh && make`
4. Commit and send a pull request


## Future Plans

To be added someday:

* Graphics sets bundles 
* Quick fort
* ??

# Issues

* splinterz isn't using tags in his DT repo, so there's no way to fetch the latest
release, as opposed to the most recent source code update.
* soundsense's latest version also cannot be easily determined

# Credits

* Dr. KillPatient - df_autoget script

