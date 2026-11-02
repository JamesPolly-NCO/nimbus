set -o vi

PS1="\u@\h:\W> "

# eval needed because dircolors only prints commands to stdout
#eval $(dircolors -b ~/.dircolors)

# module use /apps/ops/para/nco/modulefiles/core

pdy=$(date "+%Y%m%d")
pdym1=$(date "+%Y%m%d" -d "$pdy - 1 day")
pdym2=$(date "+%Y%m%d" -d "$pdy - 2 day")
pdym3=$(date "+%Y%m%d" -d "$pdy - 3 day")
pdym4=$(date "+%Y%m%d" -d "$pdy - 4 day")
pdym5=$(date "+%Y%m%d" -d "$pdy - 5 day")
pdym6=$(date "+%Y%m%d" -d "$pdy - 6 day")
pdym7=$(date "+%Y%m%d" -d "$pdy - 7 day")

alias gd="pushd"
alias pd="popd"
alias dirs="dirs -v"

alias lld="ls -lda"

qcd () {
	# accept 1 argument that is a string key, and perform a different
	# "pushd" operation for each key
	case "$1" in
		prodoutput)
                        pushd /lfs/h1/ops/prod/output/$pdy
			;;
		paraoutput)
                        pushd /lfs/h1/ops/para/output/$pdy
			;;
		*)
			#supplied arg not supported
			echo "qcd: unknown key '$1'"
			return 1
			;;
	esac
}
complete -W "ecflowlog noscrub longrun prodoutput paraoutput testoutput prodcom paracom testcom prodpackage parapackage testpackage prodruntime pararuntime testrrfscom testrrfshome pararrfshome pararrfscom noscrubrrfs" qcd

# TODO: add completion functionality for programs e.g.
# https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html
