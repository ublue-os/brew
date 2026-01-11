FROM cgr.dev/chainguard/wolfi-base:latest AS builder
COPY depth1.diff /tmp

RUN apk add curl git zstd posix-libc-utils uutils gnutar grep bash-binsh patch && \
  curl --retry 3 -fsSLo "/tmp/brew-install" "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" && \
  touch /.dockerenv && \
  patch < /tmp/depth1.diff /tmp/brew-install && \
  env --ignore-environment "PATH=/usr/bin:/bin:/usr/sbin:/sbin" "HOME=/home/linuxbrew" "NONINTERACTIVE=1" /usr/bin/bash /tmp/brew-install && \
  mkdir -p /out && \
  tar --zstd -cvf "/out/homebrew.tar.zst" "/home/linuxbrew/.linuxbrew"

FROM scratch AS ctx
COPY system_files /system_files
COPY --from=builder /out/homebrew.tar.zst /system_files/usr/share/homebrew.tar.zst
