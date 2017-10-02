cmake_minimum_required (VERSION 3.6.0)
project(princomp)
enable_language(C)
enable_language(CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE Release)

if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang" OR
    ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif()

include_directories("include/")

find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)
find_package(MPI REQUIRED)

file(GLOB SOURCES src/*.cpp)

set(rsvd ${SOURCES} ${INCLUDE})
include_directories(SYSTEM ${MPI_INCLUDE_PATH})

add_executable(princomp ${SOURCES})
target_link_libraries(princomp ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} ${MPI_CXX_LIBRARIES})

install(TARGETS princomp DESTINATION bin)
