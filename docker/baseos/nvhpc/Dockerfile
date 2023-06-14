# -------------------------------------------------------------------------------------------
#
# Ubuntu/nvidia HPC xSDK baseOS docker container for building ELM gpu-capable version
# AMD64
#
# -------------------------------------------------------------------------------------------
#
# nvidia HPC xSDK container. See https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nvhpc

FROM nvcr.io/nvidia/nvhpc:23.5-devel-cuda_multi-ubuntu20.04

# already included in above: gcc-9.4.0, openmpi-4.1.5rc2

LABEL maintainer.name="F.-M. Yuan" \
      maintainer.email="yuanf@ornl.gov" \
      author.name="Fengming Yuan" \
      author.email="yuanf@ornl.gov" \
      description="Nvidia HPC xSDK based image loaded with necessary dependencies for building ELM images"

# Update the system and install initial dependencies
RUN apt-get update -y \
    && apt-get install -y \
    subversion \
    bzip2 \
    libgmp3-dev \
    m4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libxml2 \
    libxml2-dev \
    libxml-libxml-perl \
    libxml2-utils \
    csh \
    liblapack-dev \
    libblas-dev \
    vim \
    libudunits2-0 \
    libudunits2-dev \
    udunits-bin \
    python3 \
    python3-dev \
    python3-pip \
    apt-utils \
    ftp \
    apt-transport-https \
    libssl-dev \
    openssl \
    libsqlite3-dev \
    gsl-bin \
    libgsl-dev \
    flex \
    nco \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean all

# Add symlink 'python' to python3
RUN ln -sf /usr/bin/python3 /usr/bin/python

## Install program to configure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen
## Set default locale for the environment
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

## check locales
#RUN locale -a

# Set a few variables that can be used to control the docker build
ARG EXPAT_VERSION=2.4.7
ARG HDF5_VERSION_MAJOR=1.12
ARG HDF5_VERSION_STRING=1.12.2
ARG NETCDF_C_VERSION=4.9.2
ARG NETCDF_FORTRAN_VERSION=4.6.1
ARG NETCDF_CXX_VERSION=4.3.1

## Compile Expat XML parser
RUN cd / \
    && wget https://github.com/libexpat/libexpat/releases/download/R_2_4_7/expat-2.4.7.tar.bz2 \
    && tar -xvjf expat-2.4.7.tar.bz2 \
    && cd expat-2.4.7 \
    && ./configure \
    && make \
    && make install \
    && export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
    && cd / \
    && rm -r expat-2.4.7 \
    && rm expat-2.4.7.tar.bz2

## HDF5 - use alternative source since main HDF5 source doesnt have useful download links
#https://support.hdfgroup.org/ftp/HDF5/releases/
RUN cd / \
    && mkdir -p /usr/local/hdf5 \
    && export HDF5_DIR=/usr/local/hdf5 \
    && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION_MAJOR/hdf5-$HDF5_VERSION_STRING/src/hdf5-$HDF5_VERSION_STRING.tar.gz \
    && tar -zxvf hdf5-$HDF5_VERSION_STRING.tar.gz \
    && cd hdf5-$HDF5_VERSION_STRING \
    && mkdir -p build \
    && cd build \
    && cmake -DCMAKE_C_COMPILER=`which mpicc` -DHDF5_BUILD_FORTRAN=ON -DHDF5_ENABLE_Z_LIB_SUPPORT=ON -DZLIB_LIBRARY=/usr/lib/x86_64-linux-gnu/libz.so -DCMAKE_INSTALL_PREFIX=$HDF5_DIR -DHDF5_ENABLE_PARALLEL=ON .. \
    && make -j2 install \
    && export PATH=$HDF5_DIR/bin:$PATH \
    && export LD_LIBRARY_PATH=$HDF5_DIR/lib:$LD_LIBRARY_PATH \
    && cd / \
    && rm -rf hdf5-$HDF5_VERSION_STRING \
    && rm hdf5-$HDF5_VERSION_STRING.tar.gz


## netCDF4 C & netCDF-Fortran
RUN cd / \
    && mkdir -p /usr/local/netcdf \
    && export NCDIR=/usr/local/netcdf \
    && wget https://downloads.unidata.ucar.edu/netcdf-c/$NETCDF_C_VERSION/netcdf-c-$NETCDF_C_VERSION.tar.gz \
    && tar -zxvf netcdf-c-$NETCDF_C_VERSION.tar.gz \
    && cd netcdf-c-$NETCDF_C_VERSION \
    && CC=mpicc CPP=cpp CPPFLAGS=-I${HDF5_DIR}/include LDFLAGS=-L${HDF5_DIR}/lib ./configure --enable-parallel-tests --prefix=${NCDIR} \
    && make \
    && make install \
    && export PATH=$NCDIR/bin:$PATH \
    && export LD_LIBRARY_PATH=$NCDIR/lib:$LD_LIBRARY_PATH \
    && cd / \
    && rm -r netcdf-c-$NETCDF_C_VERSION \
    && rm netcdf-c-$NETCDF_C_VERSION.tar.gz

RUN wget https://downloads.unidata.ucar.edu/netcdf-fortran/$NETCDF_FORTRAN_VERSION/netcdf-fortran-$NETCDF_FORTRAN_VERSION.tar.gz \
    && tar -zxvf netcdf-fortran-$NETCDF_FORTRAN_VERSION.tar.gz \
    && cd netcdf-fortran-$NETCDF_FORTRAN_VERSION \
    && export NFDIR=/usr/local/netcdf \
    && CC=mpicc FC=mpif90 CPP=cpp FCFLAGS=-fPIC =-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR} --enable-parallel-tests \
    && make \
    && make install \
    && cd / \
    && rm -r netcdf-fortran-$NETCDF_FORTRAN_VERSION \
    && rm netcdf-fortran-$NETCDF_FORTRAN_VERSION.tar.gz

## Install python libraries for OLMT
RUN pip3 install wheel
RUN pip3 install numpy scipy cftime netCDF4 h5py
RUN pip3 install configparser
RUN pip3 install proj rasterio
RUN pip3 install Dask
RUN CFLAGS=-noswitcherror install mpi4py

### EOF
