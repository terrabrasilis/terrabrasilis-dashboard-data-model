#!/bin/bash

echo "Populating loinames..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"
processing_filter="$6"

PG_CON="-d $database -U $user -h $host -p $port"
BASE_PATH=`pwd`

IFS=', ' read -r -a filter <<< "$processing_filter"

cd local-of-interest-processing/

for d in */ ; do

    dtest="${d///}"
    #echo " ${dtest} "
    #echo " ${filter[@]} "; read input
    
    if [[ " ${filter[@]} " =~ " ${dtest} " ]]; then
    
        cd $d

        biome=${d%?}
        echo "biome: "$biome

        files=(`find . -type f -name "*.shp"`)
        
        length=${#files[@]}
        
        for ((i=0; i<$length; i++)); do

                shapefile=${files[i]:2:${#files[i]}}
                loi=${shapefile%.*}
                echo "loi: "$loi
                
                echo "Acquiring data...."

                SQL_DATA="SELECT id FROM public.data WHERE name ILIKE '%"$biome"%';"
                data_id=($(psql $PG_CON -t -c "$SQL_DATA"))

                echo "|$data_id|"
                echo "Acquiring loi identifier and biome...."

                SQL_LOI="SELECT DISTINCT l.id FROM loi l WHERE l.name ILIKE '%"$loi"%';"
                loi_id=($(psql $PG_CON -t -c "$SQL_LOI"))

                echo "|$loi_id|"
                
                COLS="name, geom"
                if [[ "$loi_id" = "2" ]]; then
                    COLS="name, geom, codibge"
                fi

                Query="WITH rows AS (
                        INSERT INTO public.loinames (${COLS})
                        SELECT ${COLS}
                        FROM private."${biome}"_"${loi}"
                        RETURNING gid
                        )

                        INSERT INTO loi_loinames (gid_loinames) SELECT gid FROM rows RETURNING id;

                        UPDATE loi_loinames SET id_loi = "$loi_id" WHERE id_loi is null;"
                RESPONSE_QUERY=$($BASE_PATH/exec_query.sh $user $host $port $database "$Query")
                echo "PSQL Return: $RESPONSE_QUERY"

                
                Query="INSERT INTO public.data_loi_loinames (id_loi_loinames) SELECT ll.id FROM loi_loinames ll WHERE NOT EXISTS (SELECT dll.id_loi_loinames FROM data_loi_loinames dll WHERE ll.id = dll.id_loi_loinames);
                        UPDATE data_loi_loinames SET id_data = "$data_id" WHERE id_data is null;"
                RESPONSE_QUERY=$($BASE_PATH/exec_query.sh $user $host $port $database "$Query")
                echo "PSQL Return: $RESPONSE_QUERY"

        done

        cd ../
    else
        echo "abort $d"
    fi
done

