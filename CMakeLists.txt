cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(pygunrock LANGUAGES C CXX CUDA)
include(cmake/CPM.cmake)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# --
# User defined vars

set(ANACONDA_PATH $ENV{ANACONDA_PATH})
# set(PYTORCH_VERSION $ENV{PYTORCH_VERSION})

# --
# Include pytorch

set(CMAKE_PREFIX_PATH  ${ANACONDA_PATH}/lib/python3.7/site-packages/torch)
# set(CUDNN_LIBRARY_PATH "${ANACONDA_PATH}/pkgs/cudnn-8.0.0-cuda11.0_0/lib/libcudnn.so")
# set(CUDNN_INCLUDE_PATH "${ANACONDA_PATH}/pkgs/cudnn-8.0.0-cuda11.0_0/include")
set(PYTHON_INCLUDE_PATH ${ANACONDA_PATH}/include/python3.7m)
set(PYTHON_LIBRARIES    ${ANACONDA_PATH}/lib/libpython3.7m.so)

find_package(CUDA REQUIRED)
find_package(PythonInterp 3.7 REQUIRED)
find_package(PythonLibs 3.7 REQUIRED)

find_package(Torch REQUIRED)
message(${TORCH_INSTALL_PREFIX})
find_library(TORCH_PYTHON_LIBRARY torch_python PATHS ${TORCH_INSTALL_PREFIX}/lib)

include_directories(${PYTHON_INCLUDE_DIRS} ./pybind11/include)
link_directories(/usr/local/cuda/lib64)

# --
# Include essentials

# set(ESSENTIALS_DIR ${CMAKE_CURRENT_BINARY_DIR}/essentials CACHE STRING "Path to essentials repo")
CPMAddPackage(
  NAME              Essentials
  GITHUB_REPOSITORY gunrock/essentials
  GIT_TAG           master
  SOURCE_DIR        ${CMAKE_SOURCE_DIR}/externals/essentials
)

set(ESSENTIALS_DIR ${CMAKE_SOURCE_DIR}/externals/essentials)

# --
# Build executables

add_library(
  pygunrock 
  SHARED
  interface.cu 
  ${ESSENTIALS_DIR}/externals/mtx/mmio.cpp
)

target_include_directories(
  pygunrock
  PRIVATE
  ${TORCH_INCLUDE_DIRS}
)

target_link_libraries(
  pygunrock 
  essentials
  ${PYTHON_LIBRARIES}
  ${TORCH_LIBRARIES}
  ${TORCH_PYTHON_LIBRARY}
)

set_target_properties(pygunrock PROPERTIES PREFIX "")