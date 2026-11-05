#!/bin/bash
# populate_homedir.sh: Populate wcoss2 home directory with contents of repository.
# James Polly 20250729
#
# To be executed from root of "nimbus" repo.

if [[ "/home/james_polly_hpc_noaa_gov/repos/nimbus" != "$(pwd)" ]]; then
    echo "Execute from root of "nimbus" repo; exiting." 
    echo "From root of repo, try: ./repo_tools/populate_homedir.sh"
    exit 0
fi


filelist=./repo_tools/rsync_files_from.tmp
[ -a "$filelist" ] && rm $filelist

cat << EOF > $filelist
.bashrc
.vimrc
tools/
EOF


rsync -avh --files-from=$filelist ./ /home/james_polly_hpc_noaa_gov/
rm $filelist
