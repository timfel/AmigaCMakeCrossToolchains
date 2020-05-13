set(TOOLCHAIN_OS AmigaOS)
set(TOOLCHAIN_SYSTEM_INFO_FILE Platform/${TOOLCHAIN_OS})

include(${TOOLCHAIN_SYSTEM_INFO_FILE} OPTIONAL RESULT_VARIABLE _TOOLCHAIN_SYSTEM_INFO_FILE)

if(NOT _TOOLCHAIN_SYSTEM_INFO_FILE)
	set(CMAKE_SYSTEM_NAME Generic)
else()
	set(CMAKE_SYSTEM_NAME ${TOOLCHAIN_OS})
endif()

set(CMAKE_SYSTEM_PROCESSOR m68k)

if(NOT TOOLCHAIN_PREFIX)
	string(TOLOWER ${CMAKE_SYSTEM_NAME} SYS_NAME)
	string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} SYS_CPU)
	set(TOOLCHAIN_PREFIX "${SYS_CPU}-${SYS_NAME}")
endif()
set(TOOLCHAIN_PREFIX_DASHED "${TOOLCHAIN_PREFIX}-")

set(AMIGA 1)
set(AMIGAOS3 1)

# CPU
set(M68K_CPU_TYPES "68000" "68010" "68020" "68040" "68060" "68080")
set(M68K_CPU "68000" CACHE STRING "Target CPU model")
set_property(CACHE M68K_CPU PROPERTY STRINGS ${M68K_CPU_TYPES})

# FPU
set(M68K_FPU_TYPES "soft" "hard")
set(M68K_FPU "soft" CACHE STRING "FPU type")
set_property(CACHE M68K_FPU PROPERTY STRINGS ${M68K_FPU_TYPES})

# CRT
set(MCRT_TYPES "nix20" "nix13" "clib2" "ixemul" "newlib")
set(MCRT "nix20" CACHE STRING "Target std lib")
set_property(CACHE MCRT PROPERTY STRINGS ${MCRT_TYPES})

# Extra flags
set(TOOLCHAIN_CFLAGS "${M68K_CFLAGS}" CACHE STRING "CFLAGS")
set(TOOLCHAIN_CXXFLAGS "${M68K_CXXFLAGS}" CACHE STRING "CXXFLAGS")
set(TOOLCHAIN_LDFLAGS "${M68K_LDFLAGS}" CACHE STRING "LDFLAGS")
set(TOOLCHAIN_COMMON "${M68K_COMMON}" CACHE STRING "Common FLAGS")

if(NOT M68K_TOOLCHAIN_PATH)
	set(TOOLCHAIN_PATH /opt/${TOOLCHAIN_PREFIX})
else()
	set(TOOLCHAIN_PATH ${M68K_TOOLCHAIN_PATH})
endif()

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PATH})
set(CMAKE_SYSROOT ${TOOLCHAIN_PATH})

set(CMAKE_PREFIX_PATH ${TOOLCHAIN_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_INSTALL_PREFIX "${CMAKE_PREFIX_PATH}/usr" CACHE PATH "Use PREFIX path" FORCE)

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
set(FLAGS_COMMON "${TOOLCHAIN_COMMON} -m${M68K_CPU} -m${M68K_FPU}-float -fomit-frame-pointer -mcrt=${MCRT}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FLAGS_COMMON} ${TOOLCHAIN_CFLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAGS_COMMON} ${TOOLCHAIN_CXXFLAGS}")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -m${M68K_CPU} -I${TOOLCHAIN_PATH}/m68k-amigaos/sys-include")
set(BUILD_SHARED_LIBS OFF)
unset(FLAGS_COMMON)

# Linker configuration
set(CMAKE_EXE_LINKER_FLAGS "-noixemul -Xlinker --allow-multiple-definition ${TOOLCHAIN_LDFLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -ldebug")
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
