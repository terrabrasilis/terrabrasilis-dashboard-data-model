#!/bin/bash

echo "Initializing CERRADO script..."

host="$2"
user="$3"
port="$4"
database="$5"

echo "Defining start date"
#start_date=("1988-08-01" "2000-08-01" "2002-08-01" "2004-08-01" "2006-08-01" "2008-08-01" "2010-08-01" "2012-08-01" "2013-08-01" "2014-08-01" "2015-08-01" "2016-08-01" "2017-08-01")
start_date=("2018-08-01")

echo "Defining end date"
#end_date=("2000-07-31" "2002-07-31" "2004-07-31" "2006-07-31" "2008-07-31" "2010-07-31" "2012-07-31" "2013-07-31" "2014-07-31" "2015-07-31" "2016-07-31" "2017-07-31" "2018-07-31")
end_date=("2019-07-31")

echo "Defining data name"
data="PRODES CERRADO"

echo "Defining class"
class="deforestation"

echo "Defining loi"
loi=$1

echo "Defining years"
#years=("2002" "2004" "2006" "2008" "2010" "2012" "2013" "2014" "2015" "2016" "2017" "2018")
years=("2019")

length=1

echo "Processing for loi_id=$loi" >> output_cerrado.log
echo "==========================" >> output_cerrado.log

for ((i=0; i<$length; ++i));
do

    #TB_EXISTS="SELECT 'YES' WHERE (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'private' AND table_name = 'prodes_cerrado_deforestation_d${years[$i]}_subdivided' ));"
    #HAS_TABLE=($(psql -p $port -d $database -U $user -h $host -t -c "$TB_EXISTS"))
    # If table no exists, continue to next.
    #if [[ "$HAS_TABLE" = "YES" ]]; then

        Query="INSERT INTO features (id_period, id_data_loi_loinames, id_data_class, created_at, gid_polygon, geom) SELECT (SELECT per.id FROM period as per INNER JOIN data ON (per.start_date = '${start_date[$i]}' AND per.end_date = '${end_date[$i]}' AND data.id = per.id_data AND data.name = '$data')) as id_period, dll.id as id_data_loi_loinames, (SELECT dc.id FROM data_class as dc INNER JOIN class ON (class.id = dc.id_class AND class.name = '$class') INNER JOIN data ON (data.id = dc.id_data AND data.name = '$data')) as id_data_class, now() as created_at, mask.fid as gid_polygon, CASE WHEN ST_CoveredBy(mask.geom, l.geom) THEN ST_Multi(ST_MakeValid(mask.geom)) ELSE ST_Multi(ST_CollectionExtract(ST_Intersection(mask.geom, l.geom), 3)) END AS geom FROM private.prodes_cerrado_deforestation_d${years[$i]}_subdivided AS mask INNER JOIN loinames l ON (ST_Intersects(mask.geom, l.geom)) INNER JOIN loi_loinames ll ON (l.gid = ll.gid_loinames AND ll.id_loi = $loi) INNER JOIN data_loi_loinames dll ON (dll.id_loi_loinames = ll.id);"
        echo $Query
        RESPONSE_QUERY=$(../exec_query.sh $user $host $port $database "$Query")
        echo "PSQL Return: $RESPONSE_QUERY"
        
    #else
    #    echo "Abort because input table (prodes_cerrado_deforestation_d${years[$i]}_subdivided) not exists!"
    #fi

done >> output_cerrado.log
