#!/bin/bash
user="$1"
password="$2"
host="$3"
port=$4
database="$5"
export PGPASSWORD=$password

Query="UPDATE features f SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography)/1000000 WHERE f.created_at::date=now()::date;"
echo $Query
RESPONSE_QUERY=$(./exec_query.sh $user $host $port $database "$Query")
echo "PSQL Return: $RESPONSE_QUERY"