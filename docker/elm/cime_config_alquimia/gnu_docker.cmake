if (COMP_NAME STREQUAL gptl)
  string(APPEND CPPDEFS " -DHAVE_VPRINTF -DHAVE_GETTIMEOFDAY -DHAVE_BACKTRACE")
endif()
if (NOT DEBUG)
  string(APPEND FFLAGS " -fno-unsafe-math-optimizations")
endif()
if (DEBUG)
  string(APPEND FFLAGS " -g -fbacktrace -fbounds-check -ffpe-trap=invalid,zero,overflow")
endif()
string(APPEND CXX_LIBS " -lstdc++")
string(APPEND SLIBS " -L$ENV{HDF5_HOME}/lib -lhdf5_fortran -lhdf5 -lhdf5_hl -lhdf5hl_fortran")
string(APPEND SLIBS " -L$ENV{NETCDF_PATH}/lib/ -lnetcdff -lnetcdf -lcurl -lblas -llapack")
set(HDF5_PATH "$ENV{HDF5_HOME}")
set(NETCDF_PATH "$ENV{NETCDF_PATH}")
set(ALQUIMIA_PATH "/REDOX-PFLOTRAN/alquimia/build/alquimia")