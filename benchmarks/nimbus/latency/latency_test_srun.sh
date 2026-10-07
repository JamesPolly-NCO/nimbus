#!/bin/bash

part_group="compute-c1b"

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

osu_latency=$(realpath ../osu-micro-benchmarks-7.5.2/build/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency)

if [[ ! -f $osu_latency ]]; then
    echo "Cannot find executable $osu_latency"
    exit
fi

srun --mpi=pmi2 \
     --partition=$part_group \
     --nodes=2 \
     --ntasks-per-node=1 \
     --output=osu_latency-${part_group}.o%j \
     $osu_latency

