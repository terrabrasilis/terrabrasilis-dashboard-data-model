#!/bin/bash

IFS=', ' read -r -a filter <<< "$processing_filter"

# Meaning of lois IDs(1=uf, 2=mun, 3=conservation units, 4=indigenous areas) *without pathrow
lois=(1 2 3 4)

for data_features in "${filter[@]}"; do
    echo "Processing features from $data_features" > "output_${data_features}.log"
    for loi in "${lois[@]}"; do
        . ./$data_features.sh "$loi"
    done
done