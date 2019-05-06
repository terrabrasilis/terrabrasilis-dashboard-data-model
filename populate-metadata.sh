#!/bin/bash

echo "Populating metadata..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

# if password has no exported yet, exporting here.
export PGPASSWORD=$password

psql -h $host -d $database -U $user -p $port -f metadata.sql