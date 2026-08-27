#!/bin/bash
module reset
# get the craype c compilers
module load PrgEnv-intel
# link to the mpi libraries needed for compilation
module load cray-mpich/8.1.19

tar xf osu-micro-benchmarks-7.5.2.tar.gz
cd osu-micro-benchmarks-7.5.2
ccloc=$(which cc)
# /opt/cray/pe/craype/2.7.17/bin/cc
cxxloc=$(which CC)
# /opt/cray/pe/craype/2.7.17/bin/CC
autoreconf -if
./configure CC=${ccloc} CXX=${cxxloc} --prefix=$(pwd)/build
make && make install

