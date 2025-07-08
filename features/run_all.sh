#!/bin/bash

IFS=', ' read -r -a filter <<< "$processing_filter"

# Meaning of lois IDs(1=uf, 2=mun, 3=conservation units, 4=indigenous areas) *without pathrow
lois=(1 2 3 4)

# ###############################
echo "disable autovacuum to speed up the process"
DISABLE_VACCUM="ALTER TABLE public.features SET (autovacuum_enabled = off);"
psql -p $port -d $database -U $user -h $host -t -c "$DISABLE_VACCUM"
# ###############################

for data_features in "${filter[@]}"; do
    echo "Processing features from $data_features" > "output_${data_features}.log"
    for loi in "${lois[@]}"; do
        . ./$data_features.sh "$loi"
    done
done

# ###############################
echo "re-enable autovacuum"
ENABLE_VACCUM="ALTER TABLE public.features SET (autovacuum_enabled = on);"
psql -p $port -d $database -U $user -h $host -t -c "$ENABLE_VACCUM"
# ###############################