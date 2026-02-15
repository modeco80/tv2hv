
# Core compile arguments used for the whole native project

if(NOT TV2HV_LINKER)
	message(FATAL_ERROR "Somehow we got here without a set TV2HV_LINKER, bailing.")
endif()

# This isn't really the best place to put this, but it's probably the only one which makes sense.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# TODO: Use a list so that this isn't one giant line, and we can just append compile flags to it as needed
set(TV2HV_CORE_COMPILE_ARGS "-Wall -Wno-builtin-declaration-mismatch -Wformat=2 -fstrict-flex-arrays=3 -fstack-clash-protection -fstack-protector-strong")
set(TV2HV_CORE_LINKER_ARGS "-fuse-ld=${TV2HV_LINKER}")

if("${CMAKE_BUILD_TYPE}" STREQUAL "Release" OR "${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
	# Disable C assert() in release builds (needed since we wipe cmake core args) and enable FORTIFY_SOURCE
	set(TV2HV_CORE_COMPILE_ARGS "${TV2HV_CORE_COMPILE_ARGS} -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3 -DNDEBUG")

	# If on Release and we are prompted to use link-time optimizations do so
	if("lto" IN_LIST TV2HV_BUILD_FEATURES)
		# On clang we use ThinLTO for even better build performance.
		if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
			message(STATUS "CompilerFlags: Using LLVM ThinLTO")
			set(TV2HV_CORE_COMPILE_ARGS "${TV2HV_CORE_COMPILE_ARGS} -flto=thin")
			set(TV2HV_CORE_LINKER_ARGS "${TV2HV_CORE_LINKER_ARGS} -flto=thin")
		else()
			message(STATUS "CompilerFlags: Using LTO")
			set(TV2HV_CORE_COMPILE_ARGS "${TV2HV_CORE_COMPILE_ARGS} -flto")
			set(TV2HV_CORE_LINKER_ARGS "${TV2HV_CORE_LINKER_ARGS} -flto")
		endif()
	endif()
endif()

include(SanitizerSetup)

# Set core CMake toolchain variables so that they get applied to all projects.
# A bit nasty, but /shrug, this way our third party libraries can be mostly sanitized/etc as well.
#
# Note that -g3 in release flags is temporary, and will be removed once we don't need it

set(CMAKE_C_FLAGS "${TV2HV_CORE_COMPILE_ARGS}")
set(CMAKE_CXX_FLAGS "${TV2HV_CORE_COMPILE_ARGS}")

set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O3 -g3")

set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -g3")

set(CMAKE_EXE_LINKER_FLAGS "${TV2HV_CORE_LINKER_ARGS} -Wl,-z,noexecstack,-z,relro,-z,now")
