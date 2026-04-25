#!/usr/bin/fish
#shellcheck disable=all
if status --is-interactive
    if test -d /home/linuxbrew/.linuxbrew
        /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source

        # Prioritize system binaries to prevent brew overriding things like dbus
        fish_add_path --move --append --path (brew --prefix)/bin (brew --prefix)/sbin

        if test -d (brew --prefix)/share/fish/completions
            set -ga fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)/share/fish/vendor_completions.d
            set -ga fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
    end
end
