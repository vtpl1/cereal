FROM ubuntu:20.04

# deb http://in.archive.ubuntu.com/ubuntu/ or deb http://usa.archive.ubuntu.com/ubuntu/

# RUN printf "deb http://httpredir.debian.org/debian jessie-backports main non-free\ndeb-src http://httpredir.debian.org/debian jessie-backports main non-free" > /etc/apt/sources.list.d/backports.list

RUN apt clean \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
    wget lsb-release \
    software-properties-common gnupg ninja-build ccache \
    build-essential gdb pkg-config git software-properties-common \
    python3-tk python3-pip python3-setuptools \
    python3-dev python3-venv python3-jinja2 \
    curl zip unzip \
    autoconf autoconf-archive \
    graphviz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O cmake.sh https://github.com/Kitware/CMake/releases/download/v3.28.5/cmake-3.28.5-linux-x86_64.sh && \
    sh cmake.sh --prefix=/usr/local/ --exclude-subdir && rm -rf cmake.sh

ARG LLVM_VERSION=18
# RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh ${LLVM_VERSION} all && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ENV PATH="${PATH}:/usr/lib/llvm-${LLVM_VERSION}/bin"

RUN apt-get update \
    && apt-get install -y libx11-dev libxi-dev \
    libxft-dev libxext-dev libgtk-3-dev \
    libasound2 libc6 libc6-i386 libc6-x32 \
    libfreetype6 libxext6 libxi6 libxtst6 \
    libxrender1 \
    bison \
    nasm \
    bison cpio autoconf-archive autotools-dev automake libtool gperf \
    flex \
    libltdl-dev \
    libxtst-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ENV SHELL /bin/bash

RUN pip3 install -U pip jinja2 bump2version

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN groupmod --gid $USER_GID $USERNAME && \
    usermod --uid $USER_UID --gid $USER_GID $USERNAME && \
    chown -R $USER_UID:$USER_GID /home/$USERNAME

USER vscode