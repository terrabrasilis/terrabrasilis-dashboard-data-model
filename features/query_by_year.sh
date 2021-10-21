#!/bin/bash

length=${#years[@]}

echo ""
echo "Processing for loi_id=$loi" >> "output_${data_features}.log"
echo "==========================" >> "output_${data_features}.log"

for ((i=0; i<$length; ++i));
do
  # define current table name for each year
  CURRENT_DATA_TABLE="${raw_data_table_prefix}${years[$i]}_subdivided"

  TB_EXISTS="SELECT 'YES' WHERE (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'private' AND table_name = '${CURRENT_DATA_TABLE}' ));"
  HAS_TABLE=($(psql -p $port -d $database -U $user -h $host -t -c "$TB_EXISTS"))
  # If table no exists, continue to next.
  if [[ "$HAS_TABLE" = "YES" ]]; then

      Query="INSERT INTO features (id_period, id_data_loi_loinames, id_data_class, created_at, gid_polygon, geom)
      SELECT
        ( SELECT per.id FROM period as per
        INNER JOIN data ON (per.start_date = '${start_date[$i]}'
        AND per.end_date = '${end_date[$i]}'
        AND data.id = per.id_data
        AND data.name = '$data') ) as id_period,
        dll.id as id_data_loi_loinames,
        ( SELECT dc.id FROM data_class as dc
        INNER JOIN class ON (class.id = dc.id_class AND class.name = '$class')
        INNER JOIN data ON (data.id = dc.id_data AND data.name = '$data') ) as id_data_class,
        now() as created_at,
        mask.fid as gid_polygon,
        CASE WHEN ST_CoveredBy(mask.geom, l.geom)
        THEN ST_Multi(ST_MakeValid(mask.geom))
        ELSE ST_Multi(ST_CollectionExtract(ST_Intersection(mask.geom, l.geom), 3))
        END AS geom
      FROM private.${CURRENT_DATA_TABLE} AS mask
      INNER JOIN loinames l ON ( (mask.geom && l.geom) AND ST_Intersects(mask.geom, l.geom) )
      INNER JOIN loi_loinames ll ON (l.gid = ll.gid_loinames AND ll.id_loi = $loi)
      INNER JOIN data_loi_loinames dll ON (dll.id_loi_loinames = ll.id)
      INNER JOIN data d ON (d.id = dll.id_data AND d.name = '$data');"
      echo $Query
      RESPONSE_QUERY=$(../exec_query.sh $user $host $port $database "$Query")
      echo "PSQL Return: $RESPONSE_QUERY"
      
  else
    echo "Abort because input table (${CURRENT_DATA_TABLE}) not exists!"
  fi

done >> "output_${data_features}.log"