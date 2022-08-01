#!/bin/bash

dt=$(date '+%Y_%m_%d_%H_%M')

./main.sh >> ./run_all_${dt}.log 2>&1