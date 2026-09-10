# DS-Pico Setup Environment

## What is DS-Pico Setup?

The project **DS-Pico Setup** is a workflow to easily set up your DS-Pico flashcard and enjoy it ASAP.

If you find this project useful, please consider giving it a star! ⭐

DS-Pico project can be found [here](https://github.com/LNH-team/dspico). It is an open source DS flashcard built with a Raspberry Pi Pico (RP2040).

The project has a well-explained guide to set up the card (available [here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md)), but it has so many steps, multiple different projects to clone and build, multiple files to put here and there, copy this, paste that... Well, it is very scary for a first-time user who bought or built a DS-Pico. 

I really think DS-Pico is a very nice and useful project, and I think more people deserve to have access to it. With that in mind, I brought to you **DS-Pico Setup**. 

The workflow separates the container environment from the build workflow logic: the Docker container sets up the required toolchains and dependencies, while the build workflow is handled by a dedicated script (`build_projects`). You don't need to manually run builds or clone repositories inside the container anymore. Simply place your BIOS file(s) into the `misc` directory, type `make`, and all the magic will be done.

## Files needed 

Depending on your target console, the files you need differ:

- **DS / DS Lite only:** You only need the NDS BIOS file (`biosnds7.rom`). If you only want to play on a Nintendo DS or DS Lite, you do **not** need the DSi files.
- **DSi support:** If you want Nintendo DSi support, you must provide the 2 DSi files (`wrfu.rom` and `biosdsi7.rom`) in addition to `biosnds7.rom`.

### File Details

- <ins>**NDS Bios (biosnds7):**</ins> **[Required]** NDS ARM7 BIOS file. Required for all setups. If you only want to play on Nintendo DS or DS Lite, this is the only file you need!

- <ins>**WRFU Tester v0.60:**</ins> **[Optional - DSi support only]** This is a ROM used to test DSi wifi hardware. Some versions of it have an exploit used to "hack" your DSi and execute non-standard software on it. You can read more about the exploit [here](https://github.com/LNH-team/dspico-wrfuxxed/blob/develop/wrfuxxed.md). For this purpose, it is indispensable that the version be 0.60.

- <ins>**NDSi Bios (biosdsi7):**</ins> **[Optional - DSi support only]** NDSi ARM7 BIOS file.

To check if you have the right files in hand, run `sha1sum` on them and compare them to the SHA-1 values below:

```bash
# Required (DS / DS Lite & DSi):
biosnds7.rom (sha-1 24F67BDEA115A2C847C8813A262502EE1607B7DF)

# Optional (only needed if you want DSi support):
wrfu tester v0.60 (sha-1 2d65fb7a0c62a4f08954b98c95f42b804fccfd26)
biosdsi7.rom (sha-1 A3AA751EB6BDAAF8A827BA9E03576A6F1AB0F547 (incomplete) or C7C7570BFE51C3C7C5DA3B01331B94E7E7CB4F53 (complete))
```

## How to Run

> [!IMPORTANT]
> You will need `docker` and `make` installed. See [Docker documentation](https://docs.docker.com/get-started/get-docker/).

Now you have the files, make a directory called `misc` here by running `mkdir misc`, then paste them there.

At this point, this directory should look like this:

```bash
.
├── build_projects
├── docker-compose.yaml
├── Dockerfile
├── Makefile
├── misc
│   ├── biosnds7.rom
│   ├── biosdsi7.rom   # Optional (only if you want DSi support)
│   └── wrfu.rom       # Optional (only if you want DSi support)
├── README.md
└── script
    ├── copy
    └── run
```

> [!NOTE]
> The files in `./misc` don't necessarily need to have those exact names; the setup script automatically identifies them by their SHA-1 hash.

### Executing

Now, it is not necessary to build manually. You only need to type `make` and the magic will be done:

```bash
make
```

Now, you can go make a cup of coffee and drink it until everything is done.

### Finishing

When everything is finished, the container and image will automatically be removed from your machine. This directory should look like this by now:

```bash
.
├── build_projects
├── docker-compose.yaml
├── Dockerfile
├── firmware
│   └── DSpico.uf2
├── Makefile
├── misc
│   ├── biosnds7.rom
│   ├── biosdsi7.rom
│   └── wrfu.rom
├── README.md
├── script
│   ├── copy
│   └── run
└── setup
    ├── _pico
    │   ├── aplist.bin
    │   ├── picoLoader7.bin
    │   ├── picoLoader9.bin
    │   ├── savelist.bin
    │   └── themes
    │       ├── material
    │       │   └── theme.json
    │       └── raspberry
    │           ├── bannerListCell.bin
    │           ├── bannerListCellPltt.bin
    │           ├── bannerListCellSelected.bin
    │           ├── bannerListCellSelectedPltt.bin
    │           ├── bottombg.bin
    │           ├── gridcell.bin
    │           ├── gridcellPltt.bin
    │           ├── gridcellSelected.bin
    │           ├── gridcellSelectedPltt.bin
    │           ├── icon.bmp
    │           ├── preview.bin
    │           ├── scrim.bin
    │           ├── scrimPltt.bin
    │           ├── theme.json
    │           └── topbg.bin
    ├── _picoboot.nds
    └── roms
```

Note that 2 new directories were added: `firmware` and `setup`. You will use the file in `firmware` to set up your DS-Pico flashcard as described [here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md#6-flashing-the-dspico).

After setting up your sd-card following the steps described [here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md#9-prepare-the-micro-sd-card), you can copy the contents of `setup` and paste them onto the sd card. 

Last, but not least, paste your game roms inside `roms` subdirectory and enjoy!

### Cleaning Up

To remove the generated `firmware` and `setup` directories, you can run:

```bash
make clean
```
