build_query_by_year(){
    START_DATE="${1}"
    END_DATE="${2}"
    DATA_NAME="${3}"
    DATA_CLASS="${4}"
    DATA_TABLE="${5}"
    ID_LOI="${6}"

    QUERY="INSERT INTO features (id_period, id_data_loi_loinames, id_data_class, created_at, gid_polygon, geom)
    SELECT
    ( SELECT per.id FROM period as per
    INNER JOIN data ON (per.start_date = '${START_DATE}'
    AND per.end_date = '${END_DATE}'
    AND data.id = per.id_data
    AND data.name = '${DATA_NAME}') ) as id_period,
    dll.id as id_data_loi_loinames,
    ( SELECT dc.id FROM data_class as dc
    INNER JOIN class ON (class.id = dc.id_class AND class.name = '${DATA_CLASS}')
    INNER JOIN data ON (data.id = dc.id_data AND data.name = '${DATA_NAME}') ) as id_data_class,
    now() as created_at,
    mask.fid as gid_polygon,
    CASE WHEN ST_CoveredBy(mask.geom, l.geom)
    THEN ST_Multi(ST_MakeValid(mask.geom))
    ELSE ST_Multi(ST_CollectionExtract(ST_Intersection(mask.geom, l.geom), 3))
    END AS geom
    FROM private.${DATA_TABLE} AS mask
    INNER JOIN loinames l ON ( (mask.geom && l.geom) AND ST_Intersects(mask.geom, l.geom) )
    INNER JOIN loi_loinames ll ON (l.gid = ll.gid_loinames AND ll.id_loi = ${ID_LOI})
    INNER JOIN data_loi_loinames dll ON (dll.id_loi_loinames = ll.id)
    INNER JOIN data d ON (d.id = dll.id_data AND d.name = '${DATA_NAME}');"

    echo $QUERY
}