cmake_minimum_required(VERSION 3.15)

# Block unsupported platforms immediately.
if(WIN32 OR APPLE OR BSD)
	message(FATAL_ERROR "tv2hv doesn't configure or build on these platforms.")
endif()


project(tv2hv
	LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(Policies)
include(Options)
include(ProjectFuncs)
include(CompilerFlags)

# required system dependencies
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# the source code
add_subdirectory(src)

