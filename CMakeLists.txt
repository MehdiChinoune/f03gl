cmake_minimum_required( VERSION 3.13 )

project( f03gl Fortran )

set( CMAKE_CONFIGURATION_TYPES "Debug" "Release" "CodeCoverage" "Fast" )

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}" )

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE "Release" )
  message( STATUS "No CMAKE_BUILD_TYPE selected, default to ${CMAKE_BUILD_TYPE}" )
endif()


if( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "GNU" )
  if( CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 14.1 )
    set(_fstd f2023)
  else()
    set(_fstd f2018)
  endif()
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wall -Wimplicit-procedure -Wunused-parameter -std=${_fstd}" )
  set( CMAKE_Fortran_FLAGS_FAST "-Ofast" )
  set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -ftrivial-auto-var-init=pattern -finit-real=snan -finit-integer=-2147483648 -finit-logical=false -finit-character=127 -finit-derived -fcheck=all -ffpe-trap=zero,overflow,invalid -fbacktrace" )
  set( CMAKE_Fortran_FLAGS_CODECOVERAGE "--coverage -g -O0" )
elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Intel" OR "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "IntelLLVM" )
  if(WIN32)
    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} /warn:all /stand:f2023 -standard-semantics" )
    set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} /check:all -fpe-all=0 -traceback" )
  else()
    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -stand f2023 -standard-semantics" )
    set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -init=snan -init=arrays -check all -fpe-all=0 -traceback" )
  endif()
  set( CMAKE_Fortran_FLAGS_FAST "-Ofast" )
  set( CMAKE_Fortran_FLAGS_CODECOVERAGE "-prof-gen:srcpos -prof-dir=${CMAKE_BINARY_DIR}/prof/ -g -O0" )
elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "LLVMFlang" )
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=f2018 -fimplicit-none-ext" )
  set( CMAKE_Fortran_FLAGS_FAST "-O3 -ffast-math -fstack-arrays" )
  set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -pedantic -Wall" )
  if(APPLE)
    set(CMAKE_Fortran_CREATE_SHARED_LIBRARY
      "<CMAKE_Fortran_COMPILER> <CMAKE_SHARED_LIBRARY_Fortran_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> -shared -o <TARGET> -Wl,-install_name,@rpath/<TARGET_SONAME> <OBJECTS> <LINK_LIBRARIES>")
  endif()
elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "NVHPC" )
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Mallocatable=03 -Minform=warn -Mstandard" )
  set( CMAKE_Fortran_FLAGS_FAST "${CMAKE_Fortran_FLAGS} -fast" )
  set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -Minfo=all -Mneginfo=all -Kieee -C" )
endif()

add_compile_definitions( OPENGL )

add_subdirectory(src)

enable_testing()
add_subdirectory(examples)
