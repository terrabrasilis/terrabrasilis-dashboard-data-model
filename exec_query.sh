#!/bin/bash
user="$1"
host="$2"
port="$3"
database="$4"
Query="$5"
PG_CON="-d $database -U $user -h $host -p $port"

# Used to provide the collected time by psql to each query.
echo "\timing" > ~/.psqlrc

psql $PG_CON << EOF
$Query
EOF