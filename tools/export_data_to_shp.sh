#!/bin/bash
#
# Used to prepare the shapefiles to input to the scripts of the Dashboard data model.
#
# uncomment the next line to delete all existing files exported before
find ${PWD}/../raw-data-processing -regex ".*\.\(cpg\|shx\|shp\|dbf\|prj\)" -delete
#
# "cerrado" "amazon" "legal_amazon" "pantanal" "pampa" "mata_atlantica" "caatinga"
TARGETS=("cerrado" "amazon" "legal_amazon" "pantanal" "pampa" "mata_atlantica" "caatinga")
for TARGET in ${TARGETS[@]}
do
    database="prodes_${TARGET}_nb"
    if [[ "${TARGET}" = "amazon" || "${TARGET}" = "legal_amazon" ]];then
        database="prodes_amazonia_nb"
    fi

    source ./pgconfig
    export PGPASSWORD=$password

    # from years configuration
    . ../raw-data-processing/${TARGET}/${TARGET}_config.sh

    # Set the output directory
    OUTPUT_DATA="../raw-data-processing/${TARGET}"

    # creating output directory to put files, if do not exists
    mkdir -p "$OUTPUT_DATA"

    # if you want a mask, enable this lines
    SHP_NAME="${TARGET}_${YEAR_MASK}"
    pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT uid as gid, geom FROM $schema.accumulated_deforestation_${YEAR_END}"

    for CLS in ${years_to_export[@]}
    do
        SHP_NAME="${TARGET}_${CLS}"
        pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "SELECT uid as gid, geom FROM $schema.yearly_deforestation WHERE class_name='d${CLS}'"
    done

done # end of TARGETS