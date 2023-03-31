#!/bin/bash
#
# Used to prepare the shapefiles to input to the scripts of the Dashboard data model.
#
# uncomment the next line to delete all existing files exported before
find ${PWD}/../raw-data-processing -regex ".*\.\(cpg\|shx\|shp\|dbf\|prj\)" -delete
#
# "cerrado" "amazon" "legal_amazon" "pantanal" "pampa" "mata_atlantica" "caatinga"
TARGETS=("pantanal" "pampa" "mata_atlantica" "caatinga")
for TARGET in ${TARGETS[@]}
do
    database="prodes_${TARGET}_nb"
    biome_table=""
    if [[ "${TARGET}" = "amazon" || "${TARGET}" = "legal_amazon" ]];then
        database="prodes_amazonia_nb"
        if [[ "${TARGET}" = "amazon" ]];then
            biome_table="_biome"
        fi;
    fi

    source ./pgconfig
    export PGPASSWORD=$password

    # from years configuration
    . ../raw-data-processing/${TARGET}/${TARGET}_config.sh

    # Set the output directory
    OUTPUT_DATA="../raw-data-processing/${TARGET}"

    # creating output directory to put files, if do not exists
    mkdir -p "$OUTPUT_DATA"

    for CLS in ${years[@]}
    do
        if [[ "${CLS}" = "${YEAR_END}" ]];then
            SHP_NAME="${TARGET}_${YEAR_END}"
            EXPORT_QUERY="SELECT uid as gid, geom FROM $schema.accumulated_deforestation_${YEAR_END}${biome_table}"
        else
            SHP_NAME="${TARGET}_${CLS}"
            EXPORT_QUERY="SELECT uid as gid, geom FROM $schema.yearly_deforestation${biome_table} WHERE class_name='d${CLS}'"
        fi;
        
        pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "${EXPORT_QUERY}"
    done

done # end of TARGETS