#!/bin/bash
#SBATCH --job-name=osu_latency
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:00:00
#SBATCH --output=osu_latency.%j.out
#SBATCH --error=osu_latency.%j.err

set -eo pipefail

source /opt/intel/oneapi/compiler/2026.1/env/vars.sh
source /opt/intel/oneapi/mpi/2021.18/env/vars.sh

export I_MPI_FABRICS=ofi
export FI_PROVIDER="verbs;ofi_rxm"
export FI_VERBS_INLINE_SIZE=39
export FI_OFI_RXM_BUFFER_SIZE=4096
export FI_UNIVERSE_SIZE=$SLURM_NTASKS
export FI_OFI_RXM_SAR_LIMIT=2147483648
export I_MPI_PIN_DOMAIN=numa
export I_MPI_DEBUG=5

export I_MPI_PMI=pmi2
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi2.so

ulimit -l unlimited || true
ulimit -n 65535 || true

srun -n 2 --mpi=pmi2 /home/james_polly_hpc_noaa_gov/benchmarks/osu-micro-benchmarks-7.5.2/build/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

