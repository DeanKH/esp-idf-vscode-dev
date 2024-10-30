FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG ESP_IDF_TAG=v5.3.1
ARG ESP_IDF_TARGET_CHIP=esp32
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt update && apt install locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN \
    --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y \
    sudo \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-venv \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 \
    udev

# add sudo permission to user
# add serial device permission to user
RUN \
    useradd -m -s /bin/bash -u 1000 developer && \
    echo "developer:developer" | chpasswd && \
    usermod -aG sudo developer && \
    usermod -aG dialout developer

USER developer
WORKDIR /home/developer

RUN mkdir -p /home/developer

RUN \
    mkdir -p /home/developer/esp/${ESP_IDF_TAG} && \
    cd /home/developer/esp/${ESP_IDF_TAG} && git clone --recursive https://github.com/espressif/esp-idf.git -b ${ESP_IDF_TAG} && \
    cd /home/developer/esp/${ESP_IDF_TAG}/esp-idf && \
    ./install.sh ${ESP_IDF_TARGET_CHIP}

RUN /bin/bash -c "source /home/developer/esp/${ESP_IDF_TAG}/esp-idf/export.sh && \
    pip3 install jinja2"

RUN \
    mkdir -p /home/developer/components && \
    cd /home/developer/components && \
    git clone --recursive https://github.com/m5stack/M5Unified.git -b 0.1.13 && \
    git clone --recursive https://github.com/m5stack/M5GFX.git -b 0.1.10 && \
    git clone --recursive https://github.com/DeanKH/mros2-esp32.git -b develop

ENV MROS2_COMPONENTS_PATH=/home/developer/components

RUN mkdir /home/developer/.vscode-server

CMD ["/bin/bash"]
