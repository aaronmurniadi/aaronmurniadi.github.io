---
title: Building a Custom Debian ISO
layout: post
date: 2025-12-01
last_modified_date: 2025-12-04
---

# Building a Custom Debian ISO

Every project must begin with a concise requirements. For me, it was:

- Deploy a consistent Linux environment across multiple machines.
- Deployment must be possible where reliable internet access might not exist.
- The installation contains everything needed and pre-configured.
- The machine just need to be turned on and start the app and components
  automatically.
- As secure as possible.

This is the story of how I built it, the tools I used, and the headaches I
suffered along the way.

## Research & Planning

_But how do you actually build a Linux ISO?_

I didn't want to build a new Linux Distro from scratch (Linux From Scratch was a
bit too ambitious). I wanted a customized **Debian-based** distro which have the
reputation to be stable. My research led me quickly to **Debian Live Build**
(`live-build`). It's the standard tool used to build official Debian Live
images. From initial reading, it's powerful, flexible, and the build process is
straightforward.

The documentation around `live-build` itself is worth of praise. Detailed yet
concise, and covered every aspect you need in structured manner:

- [https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)

## Implementation

First I need to install Debian 13 to use as host machine to build the Debian
ISO, I got the ISO from [the Debian official
site](https://www.debian.org/distrib/).

On the host machine, I need to install the `live-build` alongside some
dependencies:

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

_Yup, I learned the hard way to always use git versioning to save progress along
the way._

Then, simply run `lb config`. This will create a directory structure for our
build project, along with some scripts filled with default values.

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

This ensures every time I run this script, it'll cleanup left overs artifacts
generated from the previous run.

Explanation about some of the arguments:

| Argument                                                                                                                                 | Description                                                                                                                                                                                             |
| ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--apt "apt"`                                                                                                                            | Use apt to manage the packages during installation                                                                                                                                                      |
| `--apt-options '--yes -o Acquire::https::Verify-Peer=false -o Acquire::https::Verify-Host=false -o APT::Get::AllowUnauthenticated=true'` | Disable SSL verification during building the ISO, because `ca-certificate` is not installed during build stage, any custom apt source using https will fail and prevent us from building the ISO image. |
| `--apt-indices false`<br>`--apt-recommends false`<br>`--backports false`<br>`--proposed-updates false`<br>`--update false`               | This make the ISO images smaller.                                                                                                                                                                       |
| `--binary-images iso-hybrid`                                                                                                             | Make the ISO able to be flashed to USB or burned to CD/DVDs.                                                                                                                                            |
| `--bootloaders "grub-pc grub-efi"`                                                                                                       | Use Grub and make sure it's compatible with both UEFI and BIOS systems.                                                                                                                                 |

## Customization Hooks & Packages

_The real magic happens in the `config/` directory._

In `config/package-lists/pkgs.list.chroot`, I put the name of packages I needed
to install (GNOME, Docker, etc.).

In the `config/includes.chroot/` directory, any files I put there are copied
directly into the ISO's filesystem. This is where I put my custom wallpapers,
configuration files, and the critical `autostart.sh`. The structure inside is
directly related to the standard Linux system starting from the root `/` :

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

Another important file is `config/includes.installer/preseed.cfg`. This is the
preseed file that is used to configure the system during installation. I put the
hostname, timezone, and other important settings there.

```shell
## https://www.debian.org/releases/trixie/amd64/apbs04.en.html
#### B.4.1. Localization
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us
d-i keyboard-configuration/variant select USA

#### B.4.3. Network configuration
# Disable network configuration entirely. This is useful for cdrom
# installations on non-networked devices where the network questions,
# warning and long timeouts are a nuisance.
d-i netcfg/enable boolean false
d-i netcfg/ipv6 boolean false
d-i netcfg/choose_interface select auto
d-i netcfg/disable_autoconfig boolean true

#### B.4.6. Account setup
d-i passwd/root-login boolean false
d-i passwd/user-fullname string <fullname>
d-i passwd/username string <username>
d-i passwd/user-password password <password>
d-i passwd/user-password-again password <password>
d-i passwd/user-default-groups string audio cdrom video sudo netdev plugdev docker

#### B.4.7. Clock and time zone setup
# Controls whether or not the hardware clock is set to UTC.
d-i clock-setup/utc boolean true
# Controls whether to use NTP to set the clock during the install
# Set to false because we don't have a network
d-i clock-setup/ntp boolean false

#### B.4.8. Partitioning
# Single partition using all available space + swap
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/confirm_write_new_label boolean true
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-basicfilesystems/choose_partition select finish
d-i partman-basicfilesystems/no_swap boolean false
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
# Request user confirmation before writing changes to disk
d-i partman/confirm boolean false
d-i partman/confirm_nooverwrite boolean false

#### B.4.9. Base system installation
d-i hw-detect/load_firmware boolean true
d-i base-installer/kernel/image string linux-image-amd64

#### B.4.10. Apt setup
d-i apt-setup/cdrom/set-first boolean false
d-i apt-setup/contrib boolean true
d-i apt-setup/non-free boolean true
d-i apt-setup/non-free-firmware boolean true
d-i apt-setup/disable-cdrom-entries boolean true
d-i apt-setup/use_mirror boolean false

#### B.4.11. Package selection
tasksel tasksel/first multiselect desktop, gnome-desktop, standard
d-i pkgsel/upgrade select none
popularity-contest popularity-contest/participate boolean false

#### B.4.12. Boot loader installation
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev string /dev/sda
```

## The Offline Challenge

**The Problem:** The ISO needed to install fully offline. This meant I couldn't
rely on `apt-get install docker-ce` during installation because the target
machine might be air-gapped.

So, the docker package must be baked into the generated ISO file. Unfortunately
`docker-ce` is not available in the default Debian repository. I need to add the
custom Docker repository to APT's sources list. Easy enough:

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

The Docker repository’s use of HTTPS breaks the build because SSL certificate
verification fails. The `ca-certificates` package is required, but the build
cannot install it since the sources must be updated first, creating a bootstrap
deadlock.

This is why I used this argument to the `lb config` command:

```shell
--apt-options '--yes -o Acquire::https::Verify-Peer=false -o Acquire::https::Verify-Host=false -o APT::Get::AllowUnauthenticated=true'`
```

This is unsafe to use in installed system, but okay for building ISO.

Finally, just run `lb build` and grab a cup of coffee. The build takes quite a
long time and generated a lot of new files artifacts that is irrelevant and can
be ignored in `.gitignore` file:

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

The result of this process will be generated in the root of the projcet,
`live-image-amd64.hybrid.iso` a self-contained, automated installer that deploys
a production-ready environment in minutes.

Cheers!
