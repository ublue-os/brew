#!/usr/bin/env bash

# Prioritize system binaries to prevent brew overriding things like dbus
# See: https://github.com/ublue-os/brew/blob/54b30cc07d3211fca65ca5cc724e9812c8c79b77/system_files/usr/lib/systemd/system/brew-upgrade.service#L17-L22
if [[ $- == *i* && -z "${HOMEBREW_PREFIX:-}" && -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv | grep -Ev '\bPATH=')"
  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}"
  export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
fi
