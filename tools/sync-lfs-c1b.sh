#!/bin/bash
if [[ -z "$1" ]]; then
    echo "Error: No argument provided."
    exit 1
fi

# Parse args
case "$1" in
  -h|--help)
    echo "Usage: $0 [options]"
    echo "  -h, --help      Show help"
    echo "  -x, --transfer  Perform a non-dry-run transfer."
    exit 0
    ;;
  -x|--transfer)
    shift 1 # Move past the flag and its value, $2 becomes $1
    RSARGS="-avh"
    ;;
  *)
    RSARGS="-avhn"
    ;;
esac

HOME_DIR="/lfs/home/james_polly_hpc_noaa_gov/"
C1B_DIR="/lfs-c1b/home/james_polly_hpc_noaa_gov/"
SYNC_TARGET="/lfs/home/james_polly_hpc_noaa_gov/"$1
if [[ ! -e $SYNC_TARGET ]]; then
    echo "Cannot find specified file:"
    echo "$SYNC_TARGET"
    exit 1
fi

echo "##########################################"
echo "# Synchronizing across /lfs and /lfs-c1b #"
echo "##########################################"

rsync $RSARGS $SYNC_TARGET /lfs-c1b/home/james_polly_hpc_noaa_gov/.

echo "##########################################"
echo "# Sync complete.                         #"
echo "##########################################"

