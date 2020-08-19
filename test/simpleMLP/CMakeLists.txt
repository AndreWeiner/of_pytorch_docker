cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
project(pyTorchExample)

list(APPEND CMAKE_PREFIX_PATH $ENV{TORCH_LIBRARIES})
find_package(Torch REQUIRED)

set(CMAKE_VERBOSE_MAKEFILE ON)
add_executable(simpleMLP simpleMLP.C)
target_link_libraries(simpleMLP ${TORCH_LIBRARIES})
set_property(TARGET simpleMLP PROPERTY CXX_STANDARD 14)