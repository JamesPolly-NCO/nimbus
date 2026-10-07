#!/bin/bash

part_group="compute-c1b"

set -eo pipefail
source /opt/intel/oneapi/compiler/2026.1/env/vars.sh
source /opt/intel/oneapi/mpi/2021.18/env/vars.sh
#export I_MPI_FABRICS=ofi
#export FI_PROVIDER="verbs;ofi_rxm"
#export FI_VERBS_INLINE_SIZE=39
#export FI_OFI_RXM_BUFFER_SIZE=4096
export FI_UNIVERSE_SIZE=$SLURM_NTASKS
#export FI_OFI_RXM_SAR_LIMIT=2147483648
#export I_MPI_PIN_DOMAIN=numa
export I_MPI_DEBUG=5
export I_MPI_PMI=pmi2
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi2.so
ulimit -l unlimited || true
ulimit -n 65535 || true


#PSM3 stuff
# libfabric logs
export FI_LOG_LEVEL=""
export FI_PROVIDER="psm3"

# Cloud RDMA
export IRDMA_SHARED_UD_CREDITS=64
export IRDMA_TRANSPARENT_UD_QD_OVERRIDE=1

# Intel MPI config defined in: https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-8/overview.html
export I_MPI_ADJUST_ALLREDUCE=4
export I_MPI_ADJUST_ALLTOALL=1
export I_MPI_ADJUST_BARRIER=7
export I_MPI_ADJUST_BCAST=4
export I_MPI_ADJUST_IALLTOALL=1
export I_MPI_ADJUST_IBCAST=1
export I_MPI_ADJUST_REDUCE=3
export I_MPI_FABRICS="shm:ofi"
export I_MPI_PIN_DOMAIN='omp'

# PSM3 config defined in: https://downloadmirror.intel.com/913765/632489_Intel_Ethernet_Fabric_Host_Software_User_Guide_v1.11.pdf
export PSM3_ALLOW_ROUTERS=1
export PSM3_ERRCHK_TIMEOUT="2000:2000"
export PSM3_FLOW_CREDITS=256
export PSM3_HAL="verbs"
export PSM3_IDENTIFY=1
export PSM3_MEMORY="large"
export PSM3_MQ_RNDV_NIC_THRESH=65536
export PSM3_MR_CACHE_MODE=1
export PSM3_MR_CACHE_SIZE=512
export PSM3_MTU="-1"
export PSM3_NUM_RECV_WQES=32767
export PSM3_NUM_RECV_CQES=65536
export PSM3_RDMA=1
export PSM3_RV_FR_PAGE_LIST_LEN=256
export PSM3_RV_MR_CACHE_SIZE=1024
export PSM3_SEND_REAP_THRESH=1

srun --mpi=pmi2 \
     --partition=$part_group \
     --nodes=1 \
     --ntasks-per-node=1 \
     --output=debug-${part_group}.o%j \
     lsmod | grep -E 'rv|iefs|psm3'
