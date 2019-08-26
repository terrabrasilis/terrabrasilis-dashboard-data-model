#!/bin/bash

HAS_ARGS=$#

if [[ "$HAS_ARGS" = "5" || "$HAS_ARGS" = "4" ]]; then
    # if has args, read then in that order: host user password database port
    host="$1"
    user="$2"
    password="$3"
    database="$4"
    port="$5"
else
    echo "No args was provided!"
    echo "Trying read configurations from config file pg_config.sh"
    # if no args, try read then from config file pg_config.sh
    PWD=`pwd`
    # has config file?
    if [ -f "$PWD/pg_config.sh" ]; then
        source "$PWD/pg_config.sh"
    else
        # not found configurations, abort
        echo "You should provide configurations to connect to database."
        echo "Aborting"
        exit
    fi
fi

if [[ "$user" = "" || "$password" = "" || "$host" = "" || "$database" = "" ]]; then
    # found configurations, but it's still incomplete, abort
    echo "You should provide all configurations to connect to database."
    echo "Options:"
    echo "- Call the script including args on that order (the port arg is optional): host user password database <port>"
    echo "- Edit or create one file called pg_config.sh in root directory and provide the database informations inside."
    echo "#!/bin/bash"
    echo "user='postgres'"
    echo "password='postgres'"
    echo "host='localhost'"
    echo "database='dashboard-data-model'"
    echo "port='5432'"
    echo ""
    echo "exiting..."
    exit
fi

export PGPASSWORD=$password

# -------------------------------------------------
# Start configurations
# -------------------------------------------------
# Use YES to enable or another word to NO
MODEL="YES"
DATA="YES"
METADATA="NO"
FEATURES="NO"
# -------------------------------------------------
# Example:
#
# For processing new data without remove the existing data
# use the DATA, METADATA and FEATURES options.
#
# MODEL="NO"
# DATA="YES"
# METADATA="YES"
# FEATURES="YES"
#
# And keep in the below "processing_filter" parameter only
# the new data names.
#
# -------------------------------------------------
# Configure what data you want processing. Only if DATA parameter is equal YES.
# Currently the complete list are: "amazon, cerrado, legal_amazon, pampa, pantanal"
# -------------------------------------------------
processing_filter="amazon, cerrado, legal_amazon, pampa, pantanal"
# -------------------------------------------------
# End configurations
# -------------------------------------------------
if [[ "$MODEL" = "YES" ]]; then
    # model construct. Remove and recreate all database objects.
    ./initialize-private-data-model-schema.sh $user $password $host $port $database
    ./initialize-public-data-model-schema.sh $user $password $host $port $database
fi

if [[ "$DATA" = "YES" ]]; then
    # data insert. Read all shapefiles and insert then into database.
    ./insert-local-of-interests.sh $user $password $host $port $database "$processing_filter"
    ./insert-raw-data.sh $user $password $host $port $database "$processing_filter"
fi

if [[ "$METADATA" = "YES" ]]; then
    # metadata insert. Insert all metadata, no matter what in processing_filter.
    # Generally used together the MODEL option.
    ./populate-metadata.sh $user $password $host $port $database
    #./populate-loinames.sh $user $password $host $port $database "$processing_filter"
    ./populate-loinames.sh $user $password $host $port $database
fi

if [[ "$FEATURES" = "YES" ]]; then
    # features processing
    # All database model should be ready and populated with the metadata and data.
    cd features
    ./run_all.sh $user $password $host $port $database "$processing_filter"
    #../exec_query.sh $user $host $port $database "UPDATE features f SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography)/1000000;"
fi