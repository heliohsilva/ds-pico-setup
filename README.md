# DS-Pico Setup Environment

## What is DS-Pico Setup?

The project **DS-Pico Setup** is a workflow to easily set up your DS-Pico flashcard and enjoy it.

DS-Pico project can be found ![here](https://github.com/LNH-team/dspico). It is an open source DS flashcard built with a raspberry pi pico 2040.

The project has a well-explained guide to set up the card (available ![here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md)), but it has so many steps, multiple different projects to clone and build, multiple files to put here and there, copy this, paste that... Well, it is very scary for a first-time user who bought or built a DS-Pico. 

I really think DS-Pico is a very nice and useful project, and I think more people deserve to have access to it. With that in mind, I brought to you **DS-Pico Setup**. You just have to get 3 files, paste them in an specific directory, and then run 1 script and everything is done.

## Files needed 

To build this project you have to get 3 files: 

- <ins>**WRFU Tester v0.60: **</ins> This is a ROM used to test DSi wifi hardware. Some versions of it have an exploit used to "hack" your DSi and execute non-standard software on it. You can read more about the exploit ![here](https://github.com/LNH-team/dspico-wrfuxxed/blob/develop/wrfuxxed.md). For this porpose, is indispensable that the version be 0.60.

- <ins>**NDS Bios (biosnds7): **</ins> NDS bios file. 

- <ins>**NDSi Bios (biosdsi7): **</ins> NDSi bios file. 

To check if you have the right files in hand, run `sha1sum` on all of them and compare them to the sha-1 values bellow:

```bash
wrfu tester v0.60 (sha-1 2d65fb7a0c62a4f08954b98c95f42b804fccfd26)
biosnds7.rom (sha-1 24F67BDEA115A2C847C8813A262502EE1607B7DF)
biosdsi7.rom (sha-1 A3AA751EB6BDAAF8A827BA9E03576A6F1AB0F547 (incomplete) or C7C7570BFE51C3C7C5DA3B01331B94E7E7CB4F53 (complete))
```

## How to Run

Now you have the files, make a directory called misc here by running `mkdir misc`, then paste them there.

At this point, this directory should look like this:

```bash
.
├── docker-compose.yaml
├── Dockerfile
├── misc
│   ├── biosdsi7.rom
│   ├── biosnds7.rom
│   └── wrfu.rom
├── README.md
└── run

```
> [!NOTE]
> The files in ./misc don't necessarily need to have those names.

### Executing

Now, you can execute the setup workflow by typing:

```bash
sudo chmod +x ./run && ./run
```

Now, you can go make a cup of coffee and drink it until everything is done.

### Finishing

When everything is finished, the container and image will automatically be removed from your machine. This directory should look like this by now:

```bash
.
├── docker-compose.yaml
├── Dockerfile
├── firmware
│   └── DSpico.uf2
├── misc
│   ├── biosdsi7.rom
│   ├── biosnds7.rom
│   └── wrfu.rom
├── README.md
├── run
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


Note that 2 new directories were added: `firmware` and `setup`. You will use the file in `firmware` to set up your DS-Pico flashcard as described ![here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md#6-flashing-the-dspico).

After setting up your sd-card following the steps described ![here](https://github.com/LNH-team/dspico/blob/develop/GUIDE.md#9-prepare-the-micro-sd-card), you can copy the contents of `setup` and paste them onto the sd card. 

Last, but not least, paste your game roms inside `roms` subdirectory and enjoy!







