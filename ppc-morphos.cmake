set(TOOLCHAIN_OS MorphOS)
set(TOOLCHAIN_SYSTEM_INFO_FILE Platform/${TOOLCHAIN_OS})

include(${TOOLCHAIN_SYSTEM_INFO_FILE} OPTIONAL RESULT_VARIABLE _TOOLCHAIN_SYSTEM_INFO_FILE)

if(NOT _TOOLCHAIN_SYSTEM_INFO_FILE)
	set(CMAKE_SYSTEM_NAME Generic)
else()
	set(CMAKE_SYSTEM_NAME ${TOOLCHAIN_OS})
endif()

set(CMAKE_SYSTEM_PROCESSOR ppc)

if(NOT TOOLCHAIN_PREFIX)
	string(TOLOWER ${CMAKE_SYSTEM_NAME} SYS_NAME)
	string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} SYS_CPU)
	set(TOOLCHAIN_PREFIX "${SYS_CPU}-${SYS_NAME}")
endif()
set(TOOLCHAIN_PREFIX_DASHED "${TOOLCHAIN_PREFIX}-")

set(AMIGA 1)
set(MORPHOS 1)

# Extra flags
set(TOOLCHAIN_CFLAGS "${M68K_CFLAGS}" CACHE STRING "CFLAGS")
set(TOOLCHAIN_CXXFLAGS "${M68K_CXXFLAGS}" CACHE STRING "CXXFLAGS")
set(TOOLCHAIN_LDFLAGS "${M68K_LDFLAGS}" CACHE STRING "LDFLAGS")
set(TOOLCHAIN_COMMON "${M68K_COMMON}" CACHE STRING "Common FLAGS")

if(NOT TOOLCHAIN_PATH)
	set(TOOLCHAIN_PATH /opt/${TOOLCHAIN_PREFIX})
endif()

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PATH})
set(CMAKE_SYSROOT ${TOOLCHAIN_PATH})

set(CMAKE_PREFIX_PATH ${TOOLCHAIN_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_INSTALL_PREFIX "${CMAKE_PREFIX_PATH}/usr" CACHE PATH "Use PREFIX path")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX_DASHED}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX_DASHED}g++)
set(CMAKE_CPP_COMPILER ${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX_DASHED}cpp)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX_DASHED}gcc -c)

if(WIN32)
	set(CMAKE_C_COMPILER ${CMAKE_C_COMPILER}.exe)
	set(CMAKE_CXX_COMPILER ${CMAKE_CXX_COMPILER}.exe)
	set(CMAKE_CPP_COMPILER ${CMAKE_CPP_COMPILER}.exe)
	set(CMAKE_ASM_COMPILER ${CMAKE_ASM_COMPILER}.exe)
endif()

# Compiler flags
set(FLAGS_COMMON "${TOOLCHAIN_COMMON} -fomit-frame-pointer")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FLAGS_COMMON} ${TOOLCHAIN_CFLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAGS_COMMON} ${TOOLCHAIN_CXXFLAGS}")
set(BUILD_SHARED_LIBS OFF)
unset(FLAGS_COMMON)

# Linker configuration
set(CMAKE_EXE_LINKER_FLAGS "-lm -ldebug ${TOOLCHAIN_LDFLAGS}")
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
