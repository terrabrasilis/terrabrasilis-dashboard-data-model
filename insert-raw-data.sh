#!/bin/bash

# pass username, password, host and database name as parameter
echo "Inserting raw data..."

user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

cd raw-data-processing/

for d in */ ; do
    cd $d

    name=${d%?}
    echo ------------------------------------- "$name"

    files=(`find . -type f -name "*.shp"`)
    
    length=${#files[@]}
    
    for ((i=0; i<$length; i++));
     do
        shapefile=${files[i]:2:${#files[i]}}
        echo ++++++++++++++++++++++++++++++++++ "data: " $shapefile
        data=${shapefile%.*}   

        time shp2pgsql -I -s 4674 $shapefile private.$data | psql "postgresql://$user:$password@$host:$port/$database" -q

        Query="update private."$data" set geom = st_multi(st_collectionextract(st_makevalid(geom),3)) where st_isvalid(geom) = false;

        update private."$data" set geom = ST_SetSRID(geom, 4674) where ST_SRID(geom) <> 4674;
        
        CREATE TABLE private."$data"_subdivided AS SELECT origin_gid || '_' || random() as fid, st_subdivide(geom) as geom FROM private."$data";

        CREATE INDEX "$data"_subdivided_geom_idx ON private."$data"_subdivided  USING GIST (geom);"

        psql postgresql://$user:$password@$host:$port/$database << EOF
         \timing
         $Query
EOF

    done

    cd ../
done