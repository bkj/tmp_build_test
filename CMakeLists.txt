cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(my_sssp_test LANGUAGES C CXX CUDA)
include(ExternalProject)
find_package(CUDA REQUIRED)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

set(ESSENTIALS_DIR ${CMAKE_CURRENT_BINARY_DIR}/essentials CACHE STRING "Path to RAFT repo")

ExternalProject_Add(essentials
  GIT_REPOSITORY    https://github.com/bkj/essentials.git
  GIT_TAG           5e5ffee47e4ae1a0861cdade766e5a5dbaa66f12
  PREFIX            ${ESSENTIALS_DIR}
  CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                    -DESSENTIALS_BUILD_EXAMPLES=OFF
  INSTALL_COMMAND   ""
)

set(ESSENTIALS_DIR "${ESSENTIALS_DIR}/src/essentials/")

add_executable(my_sssp_test)
add_dependencies(my_sssp_test essentials)
add_dependencies(my_sssp_test essentials/externals)

target_sources(my_sssp_test PRIVATE sssp.cu /home/ubuntu/projects/essentials/externals/mtx/mmio.cpp)
# Should be
# target_sources(my_sssp_test PRIVATE sssp.cu "${ESSENTIALS_DIR}/externals/mtx/mmio.cpp")

target_include_directories(
  my_sssp_test
  PRIVATE
  "${ESSENTIALS_DIR}/include"
  "${ESSENTIALS_DIR}/externals"
  "${ESSENTIALS_DIR}/externals/moderngpu/src"
  "${ESSENTIALS_DIR}/externals/rapidjson/include"
)

set_target_properties(my_sssp_test PROPERTIES PREFIX "")

# << Why do I need these?
set(CXX_FLAGS -std=c++17 -Wall -Wno-unused-local-typedefs -Wno-strict-aliasing -Wno-unused-function -Wno-format-security)
set(NVCC_FLAGS ${GENCODE} -DSM_TARGET=61 --expt-extended-lambda --expt-relaxed-constexpr --use_fast_math --ptxas-options -v)
target_compile_options(my_sssp_test PRIVATE 
    $<$<COMPILE_LANGUAGE:CXX>:${CXX_FLAGS}>
    $<$<COMPILE_LANGUAGE:CUDA>:${NVCC_FLAGS}>
)
# >>