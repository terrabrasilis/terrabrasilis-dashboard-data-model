#!/bin/bash

# pass username, password, host and database name as parameter
echo "Inserting local of interests..."

user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

cd local-of-interest-processing/

for d in */ ; do
    cd $d

    name=${d%?}
    echo ------------------------------------- "$name"

    files=(`find . -type f -name "*.shp"`)
    
    length=${#files[@]}
    
    for ((i=0; i<$length; i++));
     do
        shapefile=${files[i]:2:${#files[i]}}
        echo ++++++++++++++++++++++++++++++++++ "loi: " $shapefile
        loi=${shapefile%.*}
        
        time shp2pgsql -I -s 4674 -W "UTF-8" $shapefile private.$name"_"${loi} --quiet | psql "postgresql://$user:$password@$host:$port/$database" -q

        Query="update private."$name"_"${loi}" set geom = st_multi(st_collectionextract(st_makevalid(geom),3)) where st_isvalid(geom) = false;

        update private."$name"_"${loi}" set geom = ST_SetSRID(geom, 4674)  where ST_SRID(geom) <> 4674;"

        psql postgresql://$user:$password@$host:$port/$database << EOF
         \timing
         $Query
EOF

    done

    cd ../
done