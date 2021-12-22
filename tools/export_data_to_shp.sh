#!/bin/bash
#
# Used to prepare the shapefiles to input to the scripts of the Dashboard data model.
# Specific to PRODES CERRADO
#
# You must create a file with your the database configurations like follows
# user="postgres"
# host="hostname or IP"
# port="5432"
# database="prodes_cerrado"
# schema="public"
# password="postgres"

source ./pgconfig
export PGPASSWORD=$password

# Set the output directory
OUTPUT_DATA="../raw-data-processing/cerrado"

# creating output directory to put files, if do not exists
mkdir -p "$OUTPUT_DATA"

YEARS=("d2002" "d2004" "d2006" "d2008")

for CLS in ${YEARS[@]}
do
    SHP_NAME="prodes_cerrado_deforestation_${CLS}"
    pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT id as gid, geom FROM $schema.yearly_deforestation WHERE class_name='$CLS'"
done
