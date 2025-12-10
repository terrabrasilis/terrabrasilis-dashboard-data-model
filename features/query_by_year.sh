#!/bin/bash

# load functions
. ./build_query.sh

length=${#years[@]}

echo ""
echo "Processing for loi_id=$loi" >> "output_${data_features}.log"
echo "==========================" >> "output_${data_features}.log"

for ((i=0; i<$length; ++i));
do
  # define current table name for each year
  CURRENT_DATA_TABLE="${raw_data_table_prefix}${years[$i]}_subdivided"

  TB_EXISTS="SELECT 'YES' WHERE (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'private' AND table_name = '${CURRENT_DATA_TABLE}' ));"
  HAS_TABLE=($(psql -p $port -d $database -U $user -h $host -t -c "$TB_EXISTS"))

  # If table exists, process than.
  if [[ "$HAS_TABLE" = "YES" ]]; then

      Query=$(build_query_by_year "${start_date[$i]}" "${end_date[$i]}" "${data}" "${class}" "${CURRENT_DATA_TABLE}" "${loi}")
      echo $Query
      RESPONSE_QUERY=$(../exec_query.sh $user $host $port $database "$Query")
      echo "PSQL Return: $RESPONSE_QUERY"
  else
    # If table no exists, continue to next.
    echo "Abort because input table (${CURRENT_DATA_TABLE}) not exists!"
  fi;

  # To process Marco UE data
  if [[ "${years[$i]}" = "2020" ]]; then
    # define current table name for MARCO UE
    CURRENT_DATA_TABLE_MARCO="${raw_data_table_prefix}marco_${years[$i]}_subdivided"

    TB_EXISTS_MARCO="SELECT 'YES' WHERE (SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'private' AND table_name = '${CURRENT_DATA_TABLE_MARCO}' ));"
    HAS_TABLE_MARCO=($(psql -p $port -d $database -U $user -h $host -t -c "$TB_EXISTS_MARCO"))
    # If table exists, process than.
    if [[ "$HAS_TABLE_MARCO" = "YES" ]]; then

        Query=$(build_query_by_year "2020-08-01" "2020-12-31" "${data}" "${class}" "${CURRENT_DATA_TABLE_MARCO}" "${loi}")
        echo $Query
        RESPONSE_QUERY=$(../exec_query.sh $user $host $port $database "$Query")
        echo "PSQL Return: $RESPONSE_QUERY"
    fi;
  fi;


done >> "output_${data_features}.log"