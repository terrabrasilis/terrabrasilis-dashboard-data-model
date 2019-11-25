## Instruction to add new data into database that has data

ATENTION: Make one backup of the database before continue.

1 - Put your new shapefiles into raw-data-processing/dir/ directory following the existing structure;

    - The name of shapefile must to following the pattern: prodes_<the biome name or legal amazon>_deforestation_d<year> (Ex.: prodes_amazon_deforestation_d2019)
    - If you want change this, edit the scripts into features directory.

2 - Check the run_all.sh script setting to ensure the correct flow. Only enable the DATA="YES" and FEATURES="YES" otherwise the scripts will delete your data;

3 - If new data is related to new periods not yet defined in the period table, so, you must insert this periods before processing these data;

See in the metadata.sql file to learn how to proceed with ids, example:
 > INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (31, 2, '2018-08-01', '2019-07-31');

4 - Edit the scripts inside features directory, related with your target data type, changing the parameters of start_date, end_date, years and length;

5 - Check the database configurations into pg_config.sh to ensure the connection string is ok;

OK, now you are ready to run the main script run_all.sh to proccessing the new data.