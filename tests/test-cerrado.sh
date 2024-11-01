#!/bin/bash
source "../pg_config.sh"
loi="$1"
loiname="$2"
year="$3"
# pass username, password, host and database name as parameter
echo "CREATING CERRADO DATABASE TEST FOR SPECIFIC LOCAL OF INTEREST NAME AND YEAR..."

#user="$1"
#password="$2"
#host="$3"
#port="$4"
#database="$5"
#loi="$6"
#loiname="$7"
#year="$8"

Query="CREATE TABLE private.cerrado_${loiname} AS SELECT * FROM private.cerrado_${loi} WHERE name LIKE '${loiname}';

	CREATE TABLE private.intersection_${loiname} AS SELECT CASE WHEN ST_CoveredBy(mask.geom, l.geom) THEN ST_Multi(ST_MakeValid(mask.geom)) 
			ELSE ST_Multi(ST_CollectionExtract(ST_Intersection(mask.geom, l.geom), 3)) END AS geom 
			FROM private.prodes_cerrado_2000_2018_full_d_${year}_subdivided
			AS mask INNER JOIN private.cerrado_${loiname} l ON (ST_Intersects(mask.geom, l.geom));

	ALTER TABLE private.intersection_${loiname} ADD COLUMN area_km2 float;
																	
	UPDATE private.intersection_${loiname} f SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography)/1000000;

	SELECT SUM(area_km2) FROM private.intersection_${loiname};"

psql postgresql://$user:$password@$host:$port/$database << EOF
	$Query
EOF > output_cerrado_${loiname}.txt