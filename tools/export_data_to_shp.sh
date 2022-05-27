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
# #"cerrado" "amazon" "legal_amazon"
# TARGET="cerrado"

source ./pgconfig
export PGPASSWORD=$password

# Set the output directory
OUTPUT_DATA="../raw-data-processing/${TARGET}"

# creating output directory to put files, if do not exists
mkdir -p "$OUTPUT_DATA"

YEARS=("d2000" "d2002" "d2004" "d2006" "d2008" "d2010" "d2012" "d2013" "d2014" "d2015" "d2016" "d2017" "d2018" "d2019" "d2020" "d2021")

for CLS in ${YEARS[@]}
do
    SHP_NAME="${TARGET}_${CLS}"
    pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT id as gid, geom FROM $schema.yearly_deforestation WHERE class_name='$CLS'"
done
