#!/bin/bash

echo "Passing parameters to data features..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

data=$("PRODES CERRADO", "PRODES AMAZON", "PRODES LEGAL AMAZON")

class="deforestation"

loi=$(1 2 3 4 5)

for i in "${data[@]}"; do
    for j in "${class[@]}"; do
        for k in "${loi[@]}"; do
            ./run-amazon-features.sh $user $password $host $port $database ${data[$i]} ${class[$j]} ${loi[$k]}

            ./run-legal-amazon-features.sh $user $password $host $port $database ${data[$i]} ${class[$j]} ${loi[$k]}

            ./run-cerrado-features.sh $user $password $host $port $database ${data[$i]} ${class[$j]} ${loi[$k]}
        done
    done
done




UPDATE features f SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography)/1000000;