cmake_minimum_required(VERSION 3.5)
project(xv6)

set(CMAKE_CXX_STANDARD 99)

file(GLOB SOURCE_FILES *.c *.h)

add_executable(xv6 ${SOURCE_FILES})
