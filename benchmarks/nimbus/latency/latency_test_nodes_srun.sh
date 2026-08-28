#!/bin/bash

set -eo pipefail

source /opt/intel/oneapi/compiler/2026.1/env/vars.sh
source /opt/intel/oneapi/mpi/2021.18/env/vars.sh

export I_MPI_FABRICS=ofi
export FI_PROVIDER="verbs;ofi_rxm"

#export FI_VERBS_INLINE_SIZE=39
#export FI_VERBS_INLINE_SIZE=64
export FI_VERBS_INLINE_SIZE=256
export FI_OFI_RXM_BUFFER_SIZE=4096
export FI_UNIVERSE_SIZE=$SLURM_NTASKS
export FI_OFI_RXM_SAR_LIMIT=2147483648

export FI_OFI_RXM_USE_SRX=0

#export I_MPI_DEBUG=5
export I_MPI_DEBUG=0
export I_MPI_WAIT_MODE=0
export I_MPI_ASYNC_PROGRESS=0

# 3. Strict Core Pinning (Crucial for latency)
export I_MPI_PIN=1
export I_MPI_PIN_DOMAIN=core
#export I_MPI_PIN_DOMAIN=numa
export I_MPI_PIN_PROCESSOR_LIST=0

export I_MPI_PMI=pmi2
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi2.so
ulimit -l unlimited || true
ulimit -n 65535 || true

osu_latency=$(realpath ../osu-micro-benchmarks-7.5.2/build/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency)

if [[ ! -f $osu_latency ]]; then
    echo "Cannot find executable $osu_latency"
    exit
fi

srun --mpi=pmi2 \
     --partition=compute \
     --nodes=2 \
     --nodelist=wcoss3-compute-01,wcoss3-compute-02 \
     --ntasks-per-node=1 \
     --cpu-bind=core \
     --exclusive \
     $osu_latency
#     $osu_latency -m 1:32 -x 10000 -i 100000
