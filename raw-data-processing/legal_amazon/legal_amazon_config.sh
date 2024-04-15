#!/bin/bash

# Configure what date you want processing. Only if DATA parameter is equal YES.
# Common values are the one-year or multi-year list: ("2019" "2020" "2021")
# Used by exportation script and to import new raw data.
# -------------------------------------------------
years=("2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019" "2020" "2021" "2022" "2023")
#years=("2023")

# for mask data
YEAR_START="1500"
YEAR_END="2007"
YEAR_MASK="${YEAR_START}_${YEAR_END}"