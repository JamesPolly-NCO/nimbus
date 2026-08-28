#!/bin/bash
module purge
source /opt/intel/oneapi/mpi/2021.18/env/vars.sh
ccloc=$(which mpicc)
# /opt/intel/oneapi/mpi/2021.18/bin/mpicc 
cxxloc=$(which mpicxx)
# /opt/intel/oneapi/mpi/2021.18/bin/mpicxx 

wget --no-check-certificate https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.5.2.tar.gz
tar xf osu-micro-benchmarks-7.5.2.tar.gz
cd osu-micro-benchmarks-7.5.2
autoreconf -if
./configure CC=${ccloc} CXX=${cxxloc} --prefix=$(pwd)/build
make && make install
