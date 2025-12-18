#!/usr/bin/env bash

# Prioritize system binaries to prevent brew overriding things like dbus
# See: https://github.com/ublue-os/brew/blob/54b30cc07d3211fca65ca5cc724e9812c8c79b77/system_files/usr/lib/systemd/system/brew-upgrade.service#L17-L22
if [[ -d /home/linuxbrew/.linuxbrew && $- == *i* ]] ; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv | egrep -v '\bPATH=')"
  export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
fi
