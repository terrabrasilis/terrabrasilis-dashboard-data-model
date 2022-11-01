#!/bin/bash

# Configure what date you want processing. Only if DATA parameter is equal YES.
# Common values are the one-year or multi-year list: ("2019" "2020" "2021")
# Used to import new raw data.
# -------------------------------------------------
years=("1500_2000" "2004" "2006" "2008" "2010" "2011" "2013" "2014" "2016" "2017" "2018" "2019" "2020" "2021")
#
# years for exportation script
# for sequential data years
years_to_export=("2004" "2006" "2008" "2010" "2011" "2013" "2014" "2016" "2017" "2018" "2019" "2020" "2021")
# for mask data
YEAR_END="2000"
YEAR_MASK="1500_${YEAR_END}"