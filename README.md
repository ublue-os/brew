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
# And enable
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /usr/bin/systemctl preset brew-setup.service && \
    /usr/bin/systemctl preset brew-update.timer && \
    /usr/bin/systemctl preset brew-upgrade.timer

```

This will:
1. Install the Homebrew tarball to `/usr/share/homebrew.tar.zst`
2. Install all systemd services and timers
3. Enable all systemd services and timers
4. Add shell integration scripts
5. Configure system limits and tmpfiles

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

## How do I override system binaries with homebrew ones?

As discussed [here](https://github.com/ublue-os/brew/pull/1), overriding system
provided binaries can lead to some unexpected issues, but it might still be
desirable to have a specific homebrew program that is also provided by the OS
to take precedence over the system one.

Make an alias!

```sh
alias git='/home/linuxbrew/.linuxbrew/bin/git'
```
