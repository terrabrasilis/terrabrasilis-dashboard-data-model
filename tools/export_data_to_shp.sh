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

# if you want a mask, enable this lines
YEARS_MASK="1500_2007"
SHP_NAME="${TARGET}_${YEARS_MASK}"
pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT uid as gid, geom FROM $schema.accumulated_deforestation_2007"

# for export increments for each year
YEARS=("2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019" "2020" "2021")

for CLS in ${YEARS[@]}
do
    SHP_NAME="${TARGET}_${CLS}"
    pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT uid as gid, geom FROM $schema.yearly_deforestation WHERE class_name='d${CLS}'"
done
