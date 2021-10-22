#!/bin/bash

Query="UPDATE features f SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography)/1000000
WHERE area_km2 IS NULL;"
echo $Query
RESPONSE_QUERY=$(./exec_query.sh $user $host $port $database "$Query")
echo "PSQL Return: $RESPONSE_QUERY"