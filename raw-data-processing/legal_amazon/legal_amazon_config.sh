#!/bin/bash

# Configure what date you want processing. Only if DATA parameter is equal YES.
# Common values are the one-year or multi-year list: ("2019" "2020" "2021")
# Used to import new raw data.
# -------------------------------------------------
#years=("1500_2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019" "2020" "2021")
years=("2022")
#
# years for exportation script
# for sequential data years
#years_to_export=("2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019" "2020" "2021")
years_to_export=("2022")
# for mask data
YEAR_END="2007"
YEAR_MASK="1500_${YEAR_END}"