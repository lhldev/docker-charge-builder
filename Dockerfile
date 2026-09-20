FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Map APT sources to the correct architecture domains
RUN echo "Types: deb\n\
URIs: http://archive.ubuntu.com/ubuntu/\n\
Suites: noble noble-updates noble-backports\n\
Components: main universe restricted multiverse\n\
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n\
Architectures: amd64\n\
\n\
Types: deb\n\
URIs: http://security.ubuntu.com/ubuntu/\n\
Suites: noble-security\n\
Components: main universe restricted multiverse\n\
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n\
Architectures: amd64\n\
\n\
Types: deb\n\
URIs: http://ports.ubuntu.com/ubuntu-ports/\n\
Suites: noble noble-updates noble-backports noble-security\n\
Components: main universe restricted multiverse\n\
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n\
Architectures: arm64" > /etc/apt/sources.list.d/ubuntu.sources

RUN dpkg --add-architecture amd64 && dpkg --add-architecture arm64

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget tar zip unzip xz-utils pkg-config ca-certificates\
    libx11-dev:amd64 libxrandr-dev:amd64 libxinerama-dev:amd64 libxcursor-dev:amd64 libxi-dev:amd64 libgl-dev:amd64 libssl-dev:amd64 \
    libx11-dev:arm64 libxrandr-dev:arm64 libxinerama-dev:arm64 libxcursor-dev:arm64 libxi-dev:arm64 libgl-dev:arm64 libssl-dev:arm64 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(uname -m) && \
    wget "https://ziglang.org/download/0.16.0/zig-${ARCH}-linux-0.16.0.tar.xz" -O zig.tar.xz --no-check-certificate && \
    tar -xf zig.tar.xz && \
    mv "zig-${ARCH}-linux-0.16.0" /usr/local/zig && \
    ln -s /usr/local/zig/zig /usr/local/bin/zig && \
    rm zig.tar.xz

WORKDIR /app
