
# Terrabrasilis Dashboard Data Model - Execution Guide

This guide provides detailed instructions on how to run the project and set up the necessary data environment.

## Requirements

### 1. Database Created and Structured
Ensure that the required database is created and properly structured.


### 2. Add Period in `period` table
Add the desired period in the period table. An example for the Cerrado Prodes period is as follows:

```sql
INSERT INTO public.period(id, id_data, start_date, end_date) 
VALUES (19, 1, '2023-08-01', '2024-07-31');
```

Each biome has a corresponding `data_id`, to check the biome's `data_id`, check the `m̀etadata.sql` file

### 3. Database Connection Configuration
In the `tools` folder, create a file named pgconfig containing the database connection details:

```bash
user=""
host=""
port=""
schema=""
password=""
```

### 4. Define Processing Year
In the `export_data_to_shp.sh` file, define the desired year for data processing. Example:

```bash
REF_YEAR="2024"
```

### 5. Define Target Biome for Processing
In the same folder, define the `TARGETS` variable with the biome(s) you wish to process:

```bash
TARGETS=("cerrado")
```

### 6. Updated Database
Make sure the database has the updated data for the desired biome. For example, for the Cerrado biome, the `prodes_cerrado_nb_p2024` database should be set up. These data will be used to generate the shapefiles for the specified biome.

### 7. Running the `export_data_to_shp.sh` Script
With the variables correctly configured, run the `export_data_to_shp.sh` script to generate the shapefile.

If everything goes well, the shapefile will be generated in `raw-data-processing/cerrado`.

### 8. Initial Configuration in `main.sh`
In the `main.sh` file, enable only the `DATA` and `FEATURES` variables. If other variables are enabled, the database will be recreated from scratch.

```bash
MODEL="NO"
METADATA="NO"
LOIS="NO"
DATA="YES"
FEATURES="YES"
```

### 9. Define Biomes for Processing
In the `main.sh` file, inside the `processing_filter` variable, define the biomes you wish to process. Example:

```bash
processing_filter="cerrado"
```

### 10. Adjust Connection in `run_all.sh` File
In the `run_all.sh` file, adjust the database connection settings, so the command looks like this:

```bash
./main.sh localhost postgres postgres dashboard-data-model 5432 >> ./run_all_${dt}.log 2>&1
```

### 11. Running the `run_all.sh` Script
Finally, run the `run_all.sh` file.

### 12. Verify Process
If the processing is successful, the generated log file should contain a line similar to this at the end:

```bash
UPDATE features f 
SET area_km2 = ST_Area(ST_Transform(f.geom, 4326)::geography) / 1000000 
WHERE area_km2 IS NULL;

PSQL Return: UPDATE 275772
Execution time: 01:28:26
```