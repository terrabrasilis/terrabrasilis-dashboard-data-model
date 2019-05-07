#!/bin/bash

# pass username, password, host and database name as parameter
echo "Inserting raw data..."

user="$1"
password="$2"
host="$3"
port="$4"
database="$5"
processing_filter="$6"

export PGPASSWORD=$password
PG_CON="-d $database -U $user -h $host -p $port"
BASE_PATH=`pwd`

IFS=', ' read -r -a filter <<< "$processing_filter"

cd raw-data-processing/

for d in */ ; do
    
    dtest="${d///}"

    if [[ " ${filter[@]} " =~ " ${dtest} " ]]; then

        cd $d

        name=${d%?}
        echo ------------------------------------- "$name"

        files=(`find . -type f -name "*.shp"`)
        
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

            time shp2pgsql -I -s 4674 $shapefile private.$data | psql $PG_CON -q

            Query="update private."$data" set geom = st_multi(st_collectionextract(st_makevalid(geom),3)) where st_isvalid(geom) = false;

            update private."$data" set geom = ST_SetSRID(geom, 4674) where ST_SRID(geom) <> 4674;
            
            CREATE TABLE private."$data"_subdivided AS SELECT gid || '_' || random() as fid, st_subdivide(geom) as geom FROM private."$data";

            CREATE INDEX "$data"_subdivided_geom_idx ON private."$data"_subdivided USING GIST (geom);"

            RESPONSE_QUERY=$($BASE_PATH/exec_query.sh $user $host $port $database "$Query")
            echo "PSQL Return: $RESPONSE_QUERY"

        done

        cd ../
    else
        echo "abort $d"
    fi
done