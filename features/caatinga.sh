#!/bin/bash

# Defining data name
data="PRODES CAATINGA"
echo "Initializing ${data} features script..."
echo "Defining class"
class="deforestation"
echo "Defining loi=${1}"
loi=$1
TARGET="caatinga"

# to define, look the shapefile name into raw-data-processing/ directory (Ex.: prodes_caatinga_deforestation_d)
raw_data_table_prefix="${TARGET}_"

echo "Defining start date"
start_date=("1500-08-01" "2000-08-01" "2002-08-01" "2004-08-01" "2006-08-01" "2008-08-01" "2010-08-01" "2011-08-01" "2012-08-01" "2013-08-01" "2014-08-01" "2015-08-01" "2016-08-01" "2017-08-01" "2018-08-01" "2019-08-01" "2020-08-01")

echo "Defining end date"
end_date=("2000-07-31" "2002-07-31" "2004-07-31" "2006-07-31" "2008-07-31" "2010-07-31" "2011-07-31" "2012-07-31" "2013-07-31" "2014-07-31" "2015-07-31" "2016-07-31" "2017-07-31" "2018-07-31" "2019-07-31" "2020-07-31" "2021-07-31")

echo "Defining years"
# the temporal suffix of raw data table on private schema (from years configuration)
. ../raw-data-processing/${TARGET}/${TARGET}_config.sh

. ./query_by_year.sh