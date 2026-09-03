FROM ubuntu:24.04

WORKDIR /app

ARG USER=wonderful
RUN useradd -m $USER

COPY . .

# Setting up default configs and .NET 9.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && rm -rf /var/lib/apt/lists/* && \
    add-apt-repository ppa:dotnet/backports && \
    apt update > /dev/null 2>&1 && \
    apt install -y --no-install-recommends \ 
        cmake \
        gcc-arm-none-eabi \
        build-essential \
        git \
        dotnet-sdk-9.0 \
        aspnetcore-runtime-9.0 \
    && \
    rm -rf /var/lib/apt/lists/*


# Setting up wonderful pacman and BlockDS

ENV WONDERFUL_TOOLCHAIN=/opt/wonderful
ENV PATH=/opt/wonderful/bin:$PATH

RUN mkdir /opt/wonderful && \
    cd /opt/wonderful && tar xzvf /app/wf-bootstrap-x86_64.tar.gz -C . && \
    yes | wf-pacman -Syu && \
    yes | wf-pacman -S wf-tools && \
    wf-config repo enable blocksds && \
    yes | wf-pacman -Syu
    # yes | wf-pacman -S toolchain-gcc-arm-none-eabi toolchain-llvm-teak toolchain-gcc-xtensa-elf 


# Setting up BlockDS

# RUN cd /app/sdk && \
#     git clone --recurse-submodules https://codeberg.org/blocksds/sdk.git . && \
#     BLOCKSDS=$PWD make -j`nproc` && \
#     mkdir /opt/blocksds/ && \
#     chown $USER:$USER /opt/blocksds && \
#     mkdir /opt/blocksds/external && \
#     make install

# ENV DLDITOOL=/opt/wonderful/thirdparty/blocksds/core/tools/dlditool/dlditool
