#!/bin/bash

source ../../../../nimbus_eae_venv/bin/activate

utilsdir="../../../utils/"
datadir="./raw_data"
#datadir="./example_data"
tmpdatadir=$(mktemp -d tmpdir.XXXX)

for i in $(find -type f -wholename "*${datadir}/*osu_latency*.o*"); do
    cat $i | grep '^[0-9]* *[0-9]*\.[0-9]*' > $(mktemp ${tmpdatadir}/tmpout.XXXX)
done

python ${utilsdir}/stat_plot.py -m "Nimbus" -d "${tmpdatadir}" -o "$(pwd)"
rm -rf ${tmpdatadir}
