set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR m68k)

# CPU
set(M68K_CPU_TYPES "68000" "68010" "68020" "68040" "68060")
set(M68K_CPU "68000" CACHE STRING "Target CPU model")
set_property(CACHE M68K_CPU PROPERTY STRINGS ${M68K_CPU_TYPES})

# FPU
set(M68K_FPU_TYPES "soft" "hard")
set(M68K_FPU "soft" CACHE STRING "FPU type")
set_property(CACHE M68K_FPU PROPERTY STRINGS ${M68K_FPU_TYPES})


if(NOT M68K_TOOLCHAIN_PATH)
	set(M68K_TOOLCHAIN_PATH /opt/m68k-amigaos)
endif()
set(CMAKE_SYSROOT ${M68K_TOOLCHAIN_PATH})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(AMIGA 1)
set(AMIGAOS3 1)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

set(CMAKE_C_COMPILER ${M68K_TOOLCHAIN_PATH}/bin/m68k-amigaos-gcc)
set(CMAKE_CXX_COMPILER ${M68K_TOOLCHAIN_PATH}/bin/m68k-amigaos-g++)
set(CMAKE_CPP_COMPILER ${M68K_TOOLCHAIN_PATH}/bin/m68k-amigaos-cpp)
set(CMAKE_PREFIX_PATH ${M68K_TOOLCHAIN_PATH})
if(WIN32)
	set(CMAKE_C_COMPILER ${CMAKE_C_COMPILER}.exe)
	set(CMAKE_CXX_COMPILER ${CMAKE_CXX_COMPILER}.exe)
	set(CMAKE_CPP_COMPILER ${CMAKE_CPP_COMPILER}.exe)
endif()

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -s -noixemul")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -s -noixemul")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -s -noixemul")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -fpermissive -fno-rtti -s -noixemul")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -fpermissive -fno-rtti -s -noixemul")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -m${M68K_CPU} -m${M68K_FPU}-float -Os -fomit-frame-pointer -fno-exceptions -fpermissive -fno-rtti -s -noixemul")
set(BUILD_SHARED_LIBS OFF)

# Linker configuration
set(CMAKE_EXE_LINKER_FLAGS "-noixemul -ldebug -s -Xlinker --allow-multiple-definition ")
