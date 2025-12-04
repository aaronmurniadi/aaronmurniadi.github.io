---
date: 2025-12-01
last_modified_date: 2025-12-04
title: Building a Custom Debian ISO
layout: post
---

# Building a Custom Debian ISO

Every project must begin with definitions of need. For me, it was:

- Deploy a consistent Linux environment across multiple machines.
- Deployment must be possible where reliable internet access might not exist.
- The installation contains everything needed and pre-configured.
- The machine just need to be turned on and start the app and components automatically.
- As secure as possible.

This is the story of how I built it, the tools I used, and the headaches I suffered along the way.

## Research & Planning

_But how do you actually build a Linux ISO?_

I didn't want to build a new Linux Distro from scratch (Linux From Scratch was a bit too ambitious). I wanted a customized **Debian-based** distro which have the reputation to be stable. My research led me quickly to **Debian Live Build** (`live-build`). It's the standard tool used to build official Debian Live images. From initial reading, it's powerful, flexible, and the build process is straightforward.

The documentation around `live-build` itself is worth of praise. Detailed yet concise, and covered every aspect you need in structured manner:

- [https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)

## Implementation

First I need to install Debian 13 to use as host machine to build the Debian ISO, I got the ISO from [the Debian official site](https://www.debian.org/distrib/).

On the host machine, I need to install the `live-build` alongside some dependencies:

```shell
sudo apt-get update && \
sudo apt-get install -y \
    binfmt-support \
    debootstrap \
    live-build \
    squashfs-tools \
    xorriso \
    git
```

Next, prepare the project directory:

```shell
mkdir debian-iso
cd debian-iso
git init
```

_Yup, I learned the hard way to always use git versioning to save progress along the way._

Then, simply run `lb config`. This will create a directory structure for our build project, along with some scripts filled with default values.

```shell
.
├── auto/
│   ├── build
│   ├── clean
│   └── config
└── config/
    ├── archives/
    ├── bootloaders/
    ├── chroot/
    │   ├── hooks/
    │   ├── includes/
    │   └── local-packageslists/
    ├── common/
    ├── hooks/
    ├── includes.chroot/
    ├── package-lists/
    ├── preseed/
    ├── trailers/
    └── binary
```

I deleted the `auto` directory, I found it to be unnecessary for my needs.

Instead, I created a build script:

```shell
#!/bin/bash
set -e

# Clean previous build if exists
sudo lb clean

# Initialize configuration
lb config \
        --apt "apt" \
        --apt-options '--yes -o Acquire::https::Verify-Peer=false -o Acquire::https::Verify-Host=false -o APT::Get::AllowUnauthenticated=true' \
        --apt-indices false \
        --apt-recommends false \
        --architectures amd64 \
        --archive-areas "main contrib non-free non-free-firmware" \
        --backports false \
        --binary-images iso-hybrid \
        --bootloaders "grub-pc grub-efi" \
        --cache-packages true \
        --checksums md5 \
        --debian-installer live \
        --debian-installer-gui true \
        --distribution trixie \
        --proposed-updates false \
        --update false \

# Build the ISO
sudo lb build
```

This ensures every time I run this script, it'll cleanup left overs artifacts generated from the previous run.

Explanation about some of the arguments:

| Argument                                                                                                                                 | Description                                                                                                                                                                                             |
| ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--apt "apt"`                                                                                                                            | Use apt to manage the packages during installation                                                                                                                                                      |
| `--apt-options '--yes -o Acquire::https::Verify-Peer=false -o Acquire::https::Verify-Host=false -o APT::Get::AllowUnauthenticated=true'` | Disable SSL verification during building the ISO, because `ca-certificate` is not installed during build stage, any custom apt source using https will fail and prevent us from building the ISO image. |
| `--apt-indices false`<br>`--apt-recommends false`<br>`--backports false`<br>`--proposed-updates false`<br>`--update false`               | This make the ISO images smaller.                                                                                                                                                                       |
| `--binary-images iso-hybrid`                                                                                                             | Make the ISO able to be flashed to USB or burned to CD/DVDs.                                                                                                                                            |
| `--bootloaders "grub-pc grub-efi"`                                                                                                       | Use Grub and make sure it's compatible with both UEFI and BIOS systems.                                                                                                                                 |

## Customization Hooks & Packages

The real magic happens in the `config/` directory.

In `config/package-lists/pkgs.list.chroot`, I put the name of packages I needed to install (GNOME, Docker, etc.).

In the `config/includes.chroot/` directory, any files I put there are copied directly into the ISO's filesystem. This is where I put my custom wallpapers, configuration files, and the critical `autostart.sh`. The structure inside is directly related to the standard Linux system starting from the root `/` :

```shell
config/includes.chroot/
└── etc
    ├── default
    │   └── grub
    ├── gdm3
    │   └── daemon.conf
    ├── netplan
    │   └── 99-custom-netcfg.yaml
    ├── os-release
    └── skel
        └── <username>
            ├── autostart.sh
            └── compose.yaml
```

Note: `skel` directory is copied to `/home/<username>` during installation.

## The Offline Challenge

**The Problem:** The ISO needed to install fully offline. This meant I couldn't rely on `apt-get install docker-ce` during installation because the target machine might be air-gapped.

So, the docker package must be baked into the generated ISO file. Unfortunately `docker-ce` is not available in the default Debian repository. I need to add the custom Docker repository to APT's sources list. Easy enough:

```shell
config/includes.chroot/
└── archives
│   ├── docker.list
│   └── sources.list
└── package-lists
    ├── _packages.list.chroot
    └── docker.list.chroot
```

The contents of the files are as follows:

```shell
# docker.list
deb [arch=amd64 trusted=yes] https://download.docker.com/linux/debian trixie stable

# sources.list
deb http://mirror.sg.gs/debian/ trixie main non-free-firmware

# docker.list.chroot
docker-ce
docker-ce-cli
containerd.io
docker-buildx-plugin
docker-compose-plugin

# _packages.list.chroot
gdm3
gnome-core
... (any package you need here)
```

The Docker repository’s use of HTTPS breaks the build because SSL certificate verification fails. The `ca-certificates` package is required, but the build cannot install it since the sources must be updated first, creating a bootstrap deadlock.

This is why I used the `--apt-options '--yes -o Acquire::https::Verify-Peer=false -o Acquire::https::Verify-Host=false -o APT::Get::AllowUnauthenticated=true'` argument to the `lb config` command. This is unsafe to use in installed system, but okay for building ISO.

Finally, just run `lb build` and grab a cup of coffee. The build takes quite a long time and generated a lot of new files artifacts that is irrelevant and can be ignored in `.gitignore` file:

```shell
.build/
*.contents
*.files
*.iso
*.lock
*.log
*.modified_timestamps
*.packages
auto/
binary.deb/
binary.udeb/
binary/
cache/
chroot*
chroot/
installer_firmware_details.txt
output/
tmp/
unpacked-initrd/
```

## Conclusion

The result of this process will be generated in the root of the projcet, `live-image-amd64.hybrid.iso` a self-contained, automated installer that deploys a production-ready environment in minutes.

Cheers!
