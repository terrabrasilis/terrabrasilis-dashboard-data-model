#!/bin/bash

# Defining data name
data="PRODES CAATINGA"
echo "Initializing ${data} features script..."
echo "Defining class"
class="deforestation"
echo "Defining loi=${1}"
loi=$1
TARGET="caatinga"

# compute years for target biome based in the year list at ../raw-data-processing/${TARGET}/${TARGET}_config.sh
. ./compute_years.sh

# insert intersection results into features table
. ./query_by_year.sh