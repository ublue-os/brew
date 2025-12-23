> The best way to bring homebrew to your custom bootc image!

Repository for generating Homebrew tarballs for redistribution on image-based systems via an OCI image.
This includes general settings you'd want to use when using Homebrew on a `bootc` system, including a tarball and services for setting it up.

## Overview

This repository builds an OCI container image that packages:
- A pre-installed Homebrew tarball (`homebrew.tar.zst`)
- Systemd services for automated setup, updates, and upgrades
- Shell integration scripts (bash, fish)
- Security limits and tmpfiles configuration

The image is designed to be consumed by custom bootc-based container images.
## Dependencies

[See upstream Docs](https://docs.brew.sh/Homebrew-on-Linux)

## Using in Custom bootc Images

### Basic Example

To include Homebrew in your custom bootc image, copy the files from this repository's OCI image:

```dockerfile
# Copy Homebrew files from the brew image
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
```

This will:
1. Install the Homebrew tarball to `/usr/share/homebrew.tar.zst`
2. Install all systemd services and timers
3. Add shell integration scripts
4. Configure system limits and tmpfiles

On first boot, `brew-setup.service` will automatically:
1. Extract Homebrew to `/var/home/linuxbrew/.linuxbrew`
2. Set up proper permissions
3. Make Homebrew ready to use

## Systemd Services

### `brew-setup.service`
Runs on first boot to extract and configure Homebrew:
- Extracts tarball to `/var/home/linuxbrew/.linuxbrew`
- Sets appropriate ownership (UID 1000)
- Creates marker file to prevent re-running

### `brew-update.timer` & `brew-update.service`
Automatically keeps Homebrew up to date:
- Runs daily to update Homebrew itself
- Ensures formula database is current

### `brew-upgrade.timer` & `brew-upgrade.service`
Automatically upgrades installed packages:
- Runs on a regular schedule
- Keeps installed packages up to date

### Shell Integration
- **Bash**: `/etc/profile.d/brew.sh` - Automatically configures Homebrew environment
- **Fish**: `/usr/share/fish/vendor_conf.d/ublue-brew.fish` - Fish shell support
- **Bash Completion**: `/etc/profile.d/brew-bash-completion.sh`

### Configuration Files
- **Security Limits**: `/etc/security/limits.d/30-brew-limits.conf`
- **Tmpfiles**: `/usr/lib/tmpfiles.d/homebrew.conf`
- **Systemd Presets**: `/usr/lib/systemd/system-preset/01-homebrew.preset`

