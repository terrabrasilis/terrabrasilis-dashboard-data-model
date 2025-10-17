#!/bin/bash
#
# Used to prepare input shapefiles for Dashboard data model scripts.
#
# uncomment the next line to delete all existing files exported before
find ${PWD}/../raw-data-processing -regex ".*\.\(cpg\|shx\|shp\|dbf\|prj\)" -delete
#
# A reference year to append on database name and table name
REF_YEAR="2025"
#
# If the data is priority scenes of Legal Amazon or Amazon biome, use the pattern for the target tables.
# default is no value
PRIORITY_PATTERN=""
# example: "2023_pri"
PRIORITY_PATTERN="_${REF_YEAR}_pri"
#
# "cerrado" "amazon" "legal_amazon" "amazon_nf" "pantanal" "pampa" "mata_atlantica" "caatinga"
TARGETS=("cerrado")

for TARGET in ${TARGETS[@]}
do
    database="prodes_${TARGET}_nb_p${REF_YEAR}"
    table_suffix="${PRIORITY_PATTERN}"
    if [[ "${TARGET}" = "amazon_nf" || "${TARGET}" = "amazon" || "${TARGET}" = "legal_amazon" ]];then
        database="prodes_amazonia_nb_p${REF_YEAR}"
        if [[ "${TARGET}" = "amazon" ]];then
            table_suffix="${PRIORITY_PATTERN}_biome"
        fi;
        if [[ "${TARGET}" = "amazon_nf" ]];then
            table_suffix="_nf_biome"
        fi;
    else
        table_suffix=""
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
            EXPORT_QUERY="SELECT gid, geom FROM ( "
            EXPORT_QUERY="${EXPORT_QUERY}    SELECT uid as gid, geom FROM public.accumulated_deforestation_${YEAR_END}${table_suffix} "
            EXPORT_QUERY="${EXPORT_QUERY}    UNION "
            EXPORT_QUERY="${EXPORT_QUERY}    SELECT uid as gid, geom FROM public.residual${table_suffix} "
            EXPORT_QUERY="${EXPORT_QUERY}) tb1 "
        else
            SHP_NAME="${TARGET}_${CLS}"
            EXPORT_QUERY="SELECT uid as gid, geom FROM $schema.yearly_deforestation${table_suffix} WHERE class_name='d${CLS}'"
        fi;
        
        pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "${EXPORT_QUERY}"
    done

done # end of TARGETS