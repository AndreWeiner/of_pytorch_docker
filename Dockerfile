FROM ubuntu:18.04
# install dependencies to compile OpenFOAM
RUN apt-get update && apt-get install -y build-essential flex bison cmake zlib1g-dev \
    libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin gnuplot \
    libreadline-dev libncurses-dev libxt-dev wget unzip vim
# copy OpenFOAM sources to the image
COPY OpenFOAM-v1906.tgz /opt/
# extract sources and prepare compilation
RUN mkdir /opt/OpenFOAM && \
    tar -xzf /opt/OpenFOAM-v1906.tgz -C /opt/OpenFOAM && \
    rm /opt/*.tgz
# set default shell to bash to source OpenFOAM specific environment variables
SHELL ["/bin/bash", "-c"]
# change installation directory to /opt/OpenFOAM and add default compilation flag -D_GLIBCXX_USE_CXX11_ABI=0
WORKDIR /opt/OpenFOAM/OpenFOAM-v1906
RUN sed -i '/projectDir=\"\$HOME\/OpenFOAM\/OpenFOAM-\$WM_PROJECT_VERSION\"/c\projectDir=\"\/opt\/OpenFOAM\/OpenFOAM-\$WM_PROJECT_VERSION\"' /opt/OpenFOAM/OpenFOAM-v1906/etc/bashrc && \
    sed -i '/CC          = g++ -std=c++11/c\CC          = g++ -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0' /opt/OpenFOAM/OpenFOAM-v1906/wmake/rules/General/Gcc/c++ && \
    source /opt/OpenFOAM/OpenFOAM-v1906/etc/bashrc && ./Allwmake -j 8
# get libtorch and set enironment variable with installation folder
WORKDIR /opt
RUN wget --no-check-certificate https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-latest.zip && \
    unzip libtorch-shared-with-deps-latest.zip && \
    rm libtorch*.zip
ENV TORCH_LIBRARIES /opt/libtorch

