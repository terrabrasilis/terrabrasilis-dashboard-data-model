#!/bin/bash
#
# Used to prepare input shapefiles for Dashboard data model scripts.
#
# uncomment the next line to delete all existing files exported before
find ${PWD}/../raw-data-processing -regex ".*\.\(cpg\|shx\|shp\|dbf\|prj\)" -delete
#
# If the data is priority scenes of Legal Amazon or Amazon biome, use the pattern for the target tables.
# Is the Prioriry data? (expected values: "yes" or "no")
IS_PRIORITY="yes"
#
# Is the MARCO UE databases? (expected values: "yes" or "no")
IS_MARCO="no"
#
#
# list of names used as reference for each database and the YEAR for each database
# PRODES_DBS=("amazon" "legal_amazon" "amazon_nf" "cerrado" "pantanal" "pampa" "mata_atlantica" "caatinga")
PRODES_DBS=("amazon" "legal_amazon")
# Used as a database name suffix. Consider that the default database name is prodes_<biome>_nb_p<BASE_YEAR>
# BASE_YEARS=("2024" "2024" "2024" "2025" "2025" "2024" "2024" "2024")
BASE_YEARS=("2025" "2025")

# loop to export all tables of each database for an schema define into pgconfig file
length=${#PRODES_DBS[@]}
for ((i=0; i<$length; ++i));
do
    TARGET=${PRODES_DBS[$i]}
    BASE_YEAR=${BASE_YEARS[$i]}

    # Priority database?
    PRIORITY_PATTERN=""
    if [[ "yes" = "${IS_PRIORITY}" ]]; then
        PRIORITY_PATTERN="_${BASE_YEAR}_pri"
    fi;

    database="prodes_${TARGET}_nb_p${BASE_YEAR}"
    table_suffix="${PRIORITY_PATTERN}"
    if [[ "${TARGET}" = "amazon_nf" || "${TARGET}" = "amazon" || "${TARGET}" = "legal_amazon" ]];then
        database="prodes_amazonia_nb_p${BASE_YEAR}"
        if [[ "${TARGET}" = "amazon" ]];then
            table_suffix="${PRIORITY_PATTERN}_biome"
        fi;
        if [[ "${TARGET}" = "amazon_nf" ]];then
            table_suffix="_nf_biome"
        fi;
    else
        table_suffix=""
    fi;
    # Marco UE database?
    if [[ "yes" = "${IS_MARCO}" ]]; then
        database="${database}_marco"
    fi;

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
        if [[ "${CLS}" = "${YEAR_END}" ]]; then
            SHP_NAME="${TARGET}_${YEAR_END}"
            EXPORT_QUERY="SELECT gid, geom FROM ( "
            EXPORT_QUERY="${EXPORT_QUERY}    SELECT uid as gid, geom FROM public.accumulated_deforestation_${YEAR_END}${table_suffix} "
            EXPORT_QUERY="${EXPORT_QUERY}    UNION "
            EXPORT_QUERY="${EXPORT_QUERY}    SELECT uid as gid, geom FROM public.residual${table_suffix} "
            EXPORT_QUERY="${EXPORT_QUERY}) tb1 "
        else
            SHP_NAME="${TARGET}_${CLS}"
            EXPORT_QUERY="SELECT uid as gid, geom FROM $schema.yearly_deforestation${table_suffix} WHERE class_name='d${CLS}'"
            SHP_NAME_MARCO="${TARGET}_marco_${CLS}"
            EXPORT_QUERY_MARCO="SELECT uid as gid, geom FROM $schema.yearly_deforestation${table_suffix} WHERE class_name='marco_d${CLS}'"
        fi;
        
        pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME" -h $host -p $port -u $user $database "${EXPORT_QUERY}"

        if [[ "${CLS}" = "2020" ]]; then
            pgsql2shp -f "$OUTPUT_DATA/$SHP_NAME_MARCO" -h $host -p $port -u $user $database "${EXPORT_QUERY_MARCO}"
        fi;
    done

done # end of TARGETS