#!/bin/bash

# pass username, password, host and database name as parameter
echo "Initializing private data model schema..."

user="$1"
password="$2"
host="$3"
port=$4
database="$5"

psql -h "$host" -d "$database" -U "$user" -p $port -a -w -f private-data-model.sql	