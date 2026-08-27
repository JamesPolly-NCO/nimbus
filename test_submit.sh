#!/bin/bash
#SBATCH --job-name=james.polly.test
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --output=james.polly.test.%j.out
#SBATCH --error=james.polly.test.%j.err

set -eo pipefail

#module load mpi/openmpi-x86_64

#echo "Hello"
/home/james_polly_hpc_noaa_gov/repos/nimbus/get_vm_info.sh
