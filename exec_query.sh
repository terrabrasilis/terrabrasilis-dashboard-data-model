#!/bin/bash
user="$1"
host="$2"
port="$3"
database="$4"
Query="$5"

echo "\timing" > ~/.psqlrc

# Used to provide the collected time by psql to each query.
psql -U $user -h $host -p $port -d $database << EOF
$Query
EOF