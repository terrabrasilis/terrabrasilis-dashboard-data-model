#!/bin/bash

# pass username, password, host and database name as parameter
echo "Inserting raw data..."

PG_CON="-d $database -U $user -h $host -p $port"
BASE_PATH=`pwd`

IFS=', ' read -r -a filter <<< "$processing_filter"

cd raw-data-processing/

for d in */ ; do
    
    dtest="${d///}"

    if [[ " ${filter[@]} " =~ " ${dtest} " ]]; then

        # go to a feature's raw data directory
        cd $d

        name=${d%?}
        echo ------------------------------------- "$name"

        # load the years list from specific data directory configuration
        . ./${name}_config.sh

        length_years=${#years[@]}

        for ((j=0; j<$length_years; ++j));
        do

            files=(`find . -type f -name "*${years[$j]}*.shp"`)
            
            length=${#files[@]}
            
            for ((i=0; i<$length; i++)); do
                shapefile=${files[i]:2:${#files[i]}}
                echo ++++++++++++++++++++++++++++++++++ "data: " $shapefile
                data=${shapefile%.*}
                data=${data,,}

                DROP_OLD="DROP TABLE IF EXISTS private.$data CASCADE;"
                psql $PG_CON -c "$DROP_OLD"
                DROP_OLD="DROP TABLE IF EXISTS private."$data"_subdivided CASCADE;"
                psql $PG_CON -c "$DROP_OLD"

                shp2pgsql -I -s 4674 $shapefile private.$data | psql $PG_CON -q

                Query="UPDATE private."$data" SET geom = st_multi(st_collectionextract(st_makevalid(geom),3)) WHERE st_isvalid(geom) = false;

                UPDATE private."$data" SET geom = ST_SetSRID(geom, 4674) WHERE ST_SRID(geom) <> 4674;
                
                CREATE TABLE private."$data"_subdivided AS SELECT gid || '_' || gen_random_uuid() AS fid, st_subdivide(geom) AS geom FROM private."$data";

                CREATE INDEX "$data"_subdivided_geom_idx ON private."$data"_subdivided USING GIST (geom);"

                RESPONSE_QUERY=$($BASE_PATH/exec_query.sh $user $host $port $database "$Query")
                echo "PSQL Return: $RESPONSE_QUERY"

            done
        done # end loop in expected years

        cd ../
    else
        echo "abort $d"
    fi
done

# return to home directory outside of raw-data-processing/
cd ../