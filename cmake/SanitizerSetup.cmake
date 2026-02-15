set(_TV2HV_CORE_WANTED_SANITIZERS "")

if("asan" IN_LIST TV2HV_BUILD_FEATURES)
	# Error if someone's trying to mix asan and tsan together,
	# they aren't compatible.
	if("tsan" IN_LIST TV2HV_BUILD_FEATURES)
		message(FATAL_ERROR "ASAN and TSAN cannot be used together.")
	endif()

	message(STATUS "Enabling ASAN because it was in TV2HV_BUILD_FEATURES")
	list(APPEND _TV2HV_CORE_WANTED_SANITIZERS "address")
endif()

if("tsan" IN_LIST TV2HV_BUILD_FEATURES)
	if("asan" IN_LIST TV2HV_BUILD_FEATURES)
		message(FATAL_ERROR "ASAN and TSAN cannot be used together.")
	endif()

	message(STATUS "Enabling TSAN because it was in TV2HV_BUILD_FEATURES")
	list(APPEND _TV2HV_CORE_WANTED_SANITIZERS "thread")
endif()

if("ubsan" IN_LIST TV2HV_BUILD_FEATURES)
	message(STATUS "Enabling UBSAN because it was in TV2HV_BUILD_FEATURES")
	list(APPEND _TV2HV_CORE_WANTED_SANITIZERS "undefined")
endif()

list(LENGTH _TV2HV_CORE_WANTED_SANITIZERS _TV2HV_CORE_WANTED_SANITIZERS_LENGTH)
if(NOT _TV2HV_CORE_WANTED_SANITIZERS_LENGTH  EQUAL 0)
	list(JOIN _TV2HV_CORE_WANTED_SANITIZERS "," _TV2HV_CORE_WANTED_SANITIZERS_ARG)
	message(STATUS "Enabled sanitizers: ${_TV2HV_CORE_WANTED_SANITIZERS_ARG}")
	set(TV2HV_CORE_COMPILE_ARGS "${TV2HV_CORE_COMPILE_ARGS} -fsanitize=${_TV2HV_CORE_WANTED_SANITIZERS_ARG}")
	set(TV2HV_CORE_LINKER_ARGS "${TV2HV_CORE_LINKER_ARGS} -fsanitize=${_TV2HV_CORE_WANTED_SANITIZERS_ARG}")
endif()
