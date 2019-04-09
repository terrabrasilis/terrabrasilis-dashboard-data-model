#!/bin/bash

echo "Populating metadata..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

garbage_data=3
garbage_loi=2

cd local-of-interest-processing/

for d in */ ; do
    
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

        declare -a data
        ctl=-1
        while read -a row_data
        do
            if [ "$ctl" -gt 0 ]; then  
                data[ctl]="${row_data[0]}"
            fi
            let "ctl++"

        done < <(echo SELECT id FROM public.data WHERE name ILIKE \'%"$biome"%\' | psql "postgresql://$user:$password@$host:$port/$database" -q);

        echo "Acquiring loi identifier and biome...."

        # get length of $id_data        
        length_id_data=${#data[@]}
        length_id_data=$((length_id_data-garbage_data))
        echo "length_id_data: "$length_id_data

        for ((j=1; j<=$length_id_data; j++)); do

            id_data=${data[$j]}
            echo "data: "$id_data

            #    declare -a id_loi
            #    declare -a loi
            #    ctl=-1
            #    while read -a row
            #    do
            #        if [ "$ctl" -gt 0 ]; then                   
            #            id_loi[ctl]="${row[0]}"
            #            loi[ctl]="${row[2]}"
            #            echo ${id_loi[$ctl]}" "${loi[$ctl]}
            #        fi

            #        let "ctl++"
                    
            #    done < <(echo SELECT DISTINCT l.id, l.name FROM data_loi_loinames dll INNER JOIN data d ON \(dll.id_data = d.id AND d.id = "$id_data"\) INNER JOIN loi_loinames ll ON \(dll.id_loi_loinames = ll.id\) INNER JOIN loi l ON \(ll.id_loi = l.id\) ORDER BY l.id | psql "postgresql://$user:$password@$host:$port/$database" -q);

            declare -a id_loi
            ctl=-1
            while read -a row
            do

                if [ "$ctl" -gt 0 ]; then                   
                id_loi[ctl]="${row[0]}"     
                fi

                let "ctl++"
                    
            done < <(echo SELECT DISTINCT l.id FROM loi l WHERE l.name ILIKE \'%"$loi"%\'| psql "postgresql://$user:$password@$host:$port/$database" -q);
                
            ## get length of $distro array
            length_id_loi=${#id_loi[@]}
            length_id_loi=$((length_id_loi-garbage_loi))
            
            ## Use bash for loop 
            for (( k=1; k<=$length_id_loi; k++ )); do 
                
                echo "id_loi = "${id_loi[$k]}
                
                Query="SET client_min_messages TO WARNING;
                
                WITH rows AS (
                    INSERT INTO public.loinames (name, geom)
                    SELECT name, geom
                    FROM private."${biome}"_"${loi}"
                    RETURNING gid
                )

                INSERT INTO loi_loinames (gid_loinames) SELECT gid FROM rows RETURNING id;

                UPDATE loi_loinames SET id_loi = "${id_loi[$k]}" WHERE id_loi is null;"

                psql postgresql://$user:$password@$host:$port/$database << EOF
                    $Query
EOF

            done

            Query="SET client_min_messages TO WARNING;
                
            INSERT INTO public.data_loi_loinames (id_loi_loinames) SELECT ll.id FROM loi_loinames ll WHERE NOT EXISTS (SELECT dll.id_loi_loinames FROM data_loi_loinames dll WHERE ll.id = dll.id_loi_loinames);

            UPDATE data_loi_loinames SET id_data = "$id_data" WHERE id_data is null;"

            psql postgresql://$user:$password@$host:$port/$database << EOF
                $Query
EOF

        done 

    done

    cd ../

done

