FROM ubuntu:24.04

WORKDIR /app

ARG USER=dspico
RUN useradd -m $USER

ENV MISC=/app/misc
RUN mkdir -p $MISC
COPY ./misc/* $MISC/

# # Setting up default configs and .NET 9.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib \
    && rm -rf /var/lib/apt/lists/* && \
    add-apt-repository ppa:dotnet/backports && \
    apt update > /dev/null 2>&1 && \
    apt install -y --no-install-recommends \ 
        cmake \
        gcc-arm-none-eabi \
        build-essential \
        git \
        expect \
        wget \
        dotnet-sdk-9.0 \
        aspnetcore-runtime-9.0 \
    && \
    rm -rf /var/lib/apt/lists/*


# Setting up wonderful pacman

ENV WONDERFUL_TOOLCHAIN=/opt/wonderful
ENV PATH=/opt/wonderful/bin:$PATH

ENV TERM=xterm
ENV WF_URL=https://wonderful.asie.pl/bootstrap/wf-installer.sh

RUN wget -O /tmp/wf-installer.sh "$WF_URL" && \
    chmod 777 /tmp/wf-installer.sh

RUN expect -c '\
        spawn /tmp/wf-installer.sh; \
        expect "Enter choice \[1-3\]:"; \
        send "1\r"; \
        expect "Enter choice \[1-4\]:"; \
        send "1\r"; \
        expect eof \
    '

# Setting up BlocksDS

RUN yes | wf-pacman -Syu && \
    yes | wf-pacman -S wf-tools && \
    wf-config repo enable blocksds && \
    yes | wf-pacman -Syu && \
    yes | wf-pacman -S blocksds-toolchain blocksds-docs && \
    ln -s $WONDERFUL_TOOLCHAIN/thirdparty/blocksds /opt/blocksds


## Running the workflow

COPY ./build_projects ./build_projects

RUN chmod +x ./build_projects

RUN ./build_projects