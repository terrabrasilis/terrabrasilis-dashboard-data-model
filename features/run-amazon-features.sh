#!/bin/bash

echo "Populating data features..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"
data="$6"
class="$7"
loi="$8"
garbage=3

declare -a identifier
ctl=-1
while read -a row
do
    if [ "$ctl" -gt 0 ]; then        
        identifier[ctl]="${row[0]}"    
    fi

    let "ctl++"

done < <(echo SELECT identifier FROM public.application  | psql "postgresql://$user:$password@$host:$port/$database" -q);


let "end = $ctl - $garbage"

for i in $(seq 1 $end);
do
    aux=${identifier[i]//_/ }
    upper=${aux^^}
    echo "Defining data:" "$upper"
   
    Query="SELECT start_date, end_date FROM period p INNER JOIN data d ON (d.id = p.id_data) WHERE d.name = '"$upper"';";
    
    declare -a start_date
    declare -a end_date
    ctl=-1
    while read -a row;
    do
        if [ "$ctl" -gt 0 ]; then 
            start_date[ctl]="${row[0]}"
            end_date[ctl]="${row[2]}"
        fi

        let "ctl++"

    done < <(echo "${Query}" | psql "postgresql://$user:$password@$host:$port/$database" -q);

    let "end = $ctl - $garbage"

    for j in $(seq 1 $end);
    do
        echo "${start_date[j]}" "${end_date[j]}"

        Query="INSERT INTO features (id_period, id_data_loi_loinames, id_data_class, created_at, gid_polygon, geom) SELECT (SELECT per.id FROM period as per INNER JOIN data ON (per.start_date = '${start_date[$i]}' AND per.end_date = '${end_date[$i]}' AND data.id = per.id_data AND data.name = '${data[$i]}')) as id_period, dll.id as id_data_loi_loinames, (SELECT dc.id FROM data_class as dc INNER JOIN class ON (class.id = dc.id_class AND class.name = '${class[$i]}') INNER JOIN data ON (data.id = dc.id_data AND data.name = '${data[$i]}')) as id_data_class, now() as created_at, mask.fid as gid_polygon, CASE WHEN ST_CoveredBy(mask.geom, l.geom) THEN ST_Multi(ST_MakeValid(mask.geom)) ELSE ST_Multi(ST_CollectionExtract(ST_Intersection(mask.geom, l.geom), 3)) END AS geom FROM private.prodes_amazon_2013_2018_deforestation_d${years[$i]}_subdivided AS mask INNER JOIN loinames l ON (ST_Intersects(mask.geom, l.geom)) INNER JOIN loi_loinames ll ON (l.gid = ll.gid_loinames AND ll.id_loi = ${loi[$i]}) INNER JOIN data_loi_loinames dll ON (dll.id_loi_loinames = ll.id) INNER JOIN data d ON (d.id = dll.id_data AND d.name = '${data[$i]}');"
        psql postgresql://$user:$password@$host:$port/$database << EOF
          \timing
          $Query
EOF
                    


    done
    
done