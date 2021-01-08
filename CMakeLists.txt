cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(my_sssp_test LANGUAGES C CXX CUDA)
include(cmake/CPM.cmake)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# --
# Include essentials

set(ESSENTIALS_DIR ${CMAKE_CURRENT_BINARY_DIR}/essentials CACHE STRING "Path to essentials repo")
CPMAddPackage(
  NAME              Essentials
  GITHUB_REPOSITORY gunrock/essentials
  GIT_TAG           master
  SOURCE_DIR        ${CMAKE_SOURCE_DIR}/externals/essentials
)

set(ESSENTIALS_DIR ${CMAKE_SOURCE_DIR}/externals/essentials)

# --
# Build executables

add_executable(my_sssp_test)
target_sources(my_sssp_test 
  PRIVATE sssp.cu 
  PRIVATE ${ESSENTIALS_DIR}/externals/mtx/mmio.cpp)
target_link_libraries(my_sssp_test PRIVATE essentials)