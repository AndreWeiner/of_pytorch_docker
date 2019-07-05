# Docker + OpenFOAM&reg; + PyTorch

## Overview

The Dockerfile in this repository creates an image with [OpenFOAM-plus](https://openfoam.com/) and [PyTorch](https://pytorch.org/) support. The image is currently based on
- Ubuntu 18.04,
- OpenFOAM-v1906, and
- PyTorch 1.1 (without GPU support).

## How to build the image

To build the image yourself, copy this repository and navigate into the folder:
```
git clone https://github.com/AndreWeiner/of_pytorch_docker.git
cd of_pytorch_docker
```
Then, download the OpenFOAM-v1906 sources from Sourceforge [(link)](https://sourceforge.net/projects/openfoamplus/files/v1906/OpenFOAM-v1906.tgz/download), and save the archive in the same folder. To build the image, run:
```
docker build -t your_dockerhub/of_pytorch:your_tag .
```

## Dockerfile details and practical tips

OpenFOAM is installed system-wide in the */opt/OpenFOAM* folder. The only change compared to a regular compilation is the additional flag
```
-D_GLIBCXX_USE_CXX11_ABI=0
```
which is necessary to build OpenFOAM solvers and utilities including PyTorch code/libraries with the GNU compiler (the flag is related to backwards compatibility for standards older than C++11, [read more](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html)).

The PyTorch library files are located in */opt/libtorch*. The environment variable **TORCH_LIBRARIES** can be used to indicate the location of certain header and library files to the compiler and linker. To compile an OpenFOAM app with PyTorch, add
```
EXE_INC = \
... \
-I$(TORCH_LIBRARIES)/include \
-I$(TORCH_LIBRARIES)/include/torch/csrc/api/include
```
to the include paths, and
```
EXE_LIBS = \
...\
-rdynamic \
-Wl,-rpath,$(TORCH_LIBRARIES)/lib $(TORCH_LIBRARIES)/lib/libtorch.so $(TORCH_LIBRARIES)/lib/libc10.so \
-Wl,--no-as-needed,$(TORCH_LIBRARIES)/lib/libcaffe2.so \
-Wl,--as-needed $(TORCH_LIBRARIES)/lib/libc10.so \
-lpthread
```
to the library paths and linker flags.
