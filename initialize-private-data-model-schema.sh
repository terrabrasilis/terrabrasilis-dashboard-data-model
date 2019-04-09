#!/bin/bash

# pass username, password, host and database name as parameter
echo "Initializing private data model schema..."

user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

psql postgresql://$user:$password@$host:$port/$database << EOF
	/* create raw data schema */
	DROP SCHEMA private CASCADE;

	CREATE SCHEMA private;

	GRANT ALL ON SCHEMA private TO postgres;
EOF
	