FROM ubuntu:20.04

# avoid time zone configuration by tzdata
ARG DEBIAN_FRONTEND=noninteractive

# install basic utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils       \
    ca-certificates \
    cmake           \
    g++             \
    make            \
    sudo            \
    unzip           \
    vim-tiny        \
    wget

# add openfoam-plus repository
RUN wget -q -O - https://dl.openfoam.com/add-debian-repo.sh | bash

# install OpenFOAM via Debian package
ARG FOAM_PATH=/usr/lib/openfoam/openfoam2012
RUN apt-get update && apt-get install --no-install-recommends -y \
    openfoam2012-default && \
    echo ". ${FOAM_PATH}/etc/bashrc" >> /etc/bash.bashrc && \
    sed -i "s/-std=c++11/-std=c++14/g" ${FOAM_PATH}/wmake/rules/General/Gcc/c++ && \
    sed -i "s/-Wold-style-cast/-Wno-old-style-cast/g" ${FOAM_PATH}/wmake/rules/General/Gcc/c++


## download and extract the PyTorch C++ libraries (libtorch)
RUN wget -q -O libtorch.zip https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.7.1%2Bcpu.zip && \
    unzip libtorch.zip -d opt/ && \
    rm *.zip

## set libtorch enironment variable
ENV TORCH_LIBRARIES /opt/libtorch