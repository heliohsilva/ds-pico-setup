FROM ubuntu:24.04

WORKDIR /app

ARG USER=dspico
RUN useradd -m $USER

ENV MISC=/app/misc
RUN mkdir -p $MISC
COPY ./misc/* $MISC/

# check if it has every necessary files

ENV WRFUSHA='2d65fb7a0c62a4f08954b98c95f42b804fccfd26'
ENV DS7SHA='24f67bdea115a2c847c8813a262502ee1607b7df'
ENV INCOMPDSI7SHA='a3aa751eb6bdaaf8a827ba9e03576a6f1ab0f547'
ENV COMPDSI7SHA='c7c7570bfe51c3c7c5da3b01331b94e7e7cb4f53'

RUN has_wrfr=0; \
    has_ds7=0; \
    has_dsi7=0; \
    for file in "$MISC"/*; do \
        if [ -f "$file" ]; then \
            hash="$(sha1sum "$file" | awk '{print $1}')"; \
            if [ "$hash" = $WRFUSHA ]; then \
                mv "$file" "$MISC/wrfu.rom"; \
                has_wrfr=1; \
            elif [ "$hash" = $DS7SHA ]; then \
                mv "$file" "$MISC/biosnds7.rom"; \
                has_ds7=1; \
            elif [ "$hash" = $INCOMPDSI7SHA ] || [ "$hash" = $COMPDSI7SHA ]; then \
                mv "$file" "$MISC/biosdsi7.rom"; \
                has_dsi7=1; \
            fi; \
        fi; \
    done;\
    if [ "$has_wrfr" = 0 ] || [ "$has_ds7" = 0 ] || [ "$has_dsi7" = 0 ]; then \
        echo "Some required file is missing. Check the docs"; \
        exit 1; \
    fi;

# Setting up default configs and .NET 9.0

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
ENV DLDITOOL=/opt/wonderful/thirdparty/blocksds/core/tools/dlditool/dlditool

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
    ln -s /opt/wonderful/thirdparty/blocksds /opt/blocksds


# Compiling pico-loader

RUN git clone --recursive https://github.com/LNH-team/pico-loader.git && cd pico-loader && \
    git submodule update --init && \
    make

# Compiling DLDI driver

RUN git clone --recursive https://github.com/LNH-team/dspico-dldi.git && cd dspico-dldi && \
    git submodule update --init && \
    make

# Compiling DSPico Bootloader

RUN git clone --recursive https://github.com/LNH-team/dspico-bootloader.git && cd dspico-bootloader && \
    git submodule update --init && \
    make

## Patch the bootloader
RUN $DLDITOOL /app/dspico-dldi/DSpico.dldi /app/dspico-bootloader/BOOTLOADER.nds

# Compiling DSRomEncrypton

RUN git clone --recursive https://github.com/Gericom/DSRomEncryptor.git && cd DSRomEncryptor && \
    git submodule update --init && \
    dotnet build

ENV EXEDIR=/app/DSRomEncryptor/DSRomEncryptor/bin/Debug/net9.0
ENV EXE=$EXEDIR/DSRomEncryptor

RUN cp $MISC/bios* $EXEDIR/
RUN $EXE /app/dspico-bootloader/BOOTLOADER.nds default.nds

# Setting up Wrfuxxed

RUN git clone --recursive https://github.com/LNH-team/dspico-wrfuxxed.git && cd dspico-wrfuxxed && \
    git submodule update --init && \
    make

RUN $DLDITOOL /app/dspico-dldi/DSpico.dldi /app/dspico-wrfuxxed/uartBufv060.bin


# Setting up dspico-firmware

ENV ROMS=/app/dspico-firmware/roms

RUN git clone https://github.com/LNH-team/dspico-firmware.git && \
    cd dspico-firmware && \
    git submodule update --init && \
    cd pico-sdk && \
    git submodule update --init && \
    cd .. && \
    mv /app/default.nds $ROMS/ 


RUN cp $MISC/wrfu.rom $ROMS/dsimode.nds && \
    cp /app/dspico-wrfuxxed/uartBufv060.bin /app/dspico-firmware/data/ && \
    sed -i '/^[[:space:]]*#DSPICO_ENABLE_WRFUXXED/s/#//' /app/dspico-firmware/CMakeLists.txt

RUN chmod +x /app/dspico-firmware/compile.sh && /app/dspico-firmware/compile.sh
    

# Setting up pico-launcher

RUN git clone --recursive https://github.com/LNH-team/pico-launcher.git && cd pico-launcher && \
    git submodule update --init && \
    make
