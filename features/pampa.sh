#!/bin/bash

# Defining data name
data="PRODES PAMPA"
echo "Initializing ${data} features script..."
echo "Defining class"
class="deforestation"
echo "Defining loi=${1}"
loi=$1

# to define, look the shapefile name into raw-data-processing/ directory (Ex.: prodes_pampa_deforestation_d)
raw_data_table_prefix="prodes_pampa_deforestation_d"

echo "Defining start date"
start_date=("2000-01-01" "2017-08-01")

echo "Defining end date"
end_date=("2016-07-31" "2018-07-31")

echo "Defining years"
years=("2016" "2018")

. ./query_by_year.sh