#!/bin/bash

PG_CON="-d $database -U $user -h $host -p $port"

# to define, look the shapefile name into raw-data-processing/ directory (Ex.: prodes_amazon_deforestation_d)
raw_data_table_prefix="${TARGET}_"

echo "Defining years"
# the temporal suffix of raw data table on private schema (from years configuration)
. ../raw-data-processing/${TARGET}/${TARGET}_config.sh

length=${#years[@]}

start_date=()
end_date=()

for ((i=0; i<$length; ++i));
do
    end_year=${years[$i]}
    SQL_DATA="SELECT start_date FROM public.period WHERE end_date='${end_year}-07-31'::date AND id_data=(SELECT id FROM public.data WHERE name ILIKE 'PRODES ${TARGET}%');"
    start=($(psql $PG_CON -t -c "$SQL_DATA"))

    start_date+=( "${start}" )
    end_date+=( "${end_year}-07-31" )
done

# uncomment to print year list
# for ((i=0; i<${#start_date[@]}; ++i));
# do
#     echo "${start_date[$i]} ${end_date[$i]}"
# done
# exit