#!/bin/bash
user="$1"
password="$2"
host="$3"
port=$4
database="$5"
export PGPASSWORD=$password

processing_filter="$6"
IFS=', ' read -r -a filter <<< "$processing_filter"

# without pathrow
lois=(1 2 3 4)

for data_features in "${filter[@]}"; do
    echo "Processing features from $data_features" > output_$data_features.log
    for loi in "${lois[@]}"; do
        ./$data_features.sh "$loi" "$host" "$user" "$port" "$database"
    done
done