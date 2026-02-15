function(tv2hv_target target)
	target_compile_definitions(${target} PRIVATE "$<$<CONFIG:DEBUG>:TV2HV_DEBUG>")
	#target_include_directories(${target} PRIVATE ${PROJECT_SOURCE_DIR})
	target_compile_features(${target} PRIVATE cxx_std_23)
	target_include_directories(${target} PRIVATE ${PROJECT_SOURCE_DIR}/src/lib ${CMAKE_CURRENT_BINARY_DIR})
endfunction()

function(_tv2hv_set_alternate_linker)
	find_program(LINKER_EXECUTABLE ld.${TV2HV_LINKER} ${TV2HV_LINKER})
	if(LINKER_EXECUTABLE)
		message(STATUS "Using ${TV2HV_LINKER} as linker")
	else()
		message(FATAL_ERROR "Linker ${TV2HV_LINKER} does not exist on your system. Please specify one which does or omit this option from your configure command.")
	endif()
endfunction()


# Set a default linker if the user never provided one.
# This defaults based on the detected compiler to the "best" linker possible
if(NOT TV2HV_LINKER AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	set(TV2HV_LINKER "lld")
elseif(NOT TV2HV_LINKER)
	set(TV2HV_LINKER "bfd")
endif()

# Do the magic
_tv2hv_set_alternate_linker()
