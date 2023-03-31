
-- the complete and canonical way to remove specific data from feature table
DELETE FROM public.features WHERE id_period::text || id_data_loi_loinames::text || id_data_class::text || gid_polygon in (
SELECT id_period::text || id_data_loi_loinames::text || id_data_class::text || gid_polygon
	FROM public.features as ft, public.period as p, public.data as d, public.data_filter as df, public.filter as f,
public.data_loi_loinames dll, public.loi_loinames ll, public.loi l, public.data_class as dc, public.class as c
WHERE ft.id_period=p.id
AND ft.id_data_class=dc.id
AND ft.id_data_loi_loinames=dll.id_loi_loinames
AND p.id_data=d.id
AND d.id=df.id_data
AND df.id_filter=f.id
AND dll.id_loi_loinames=ll.id
AND dll.id_data=d.id
AND ll.id_loi=l.id
AND dc.id_data=d.id
AND dc.id_class=c.id
AND (d.id=2 OR d.id=3) -- Filter by data origin, looking into public.data table.
AND c.id=1 -- Filter by classes, looking into public.class table. (only deforestation by now)
AND p.end_date='2019-07-31' -- Filter by specific date, looking into public.period table.
);

-- to clear the data simply using created_at as a reference, use the SQL below, setting the desired date.
DELETE FROM public.features WHERE created_at::date>='2021-10-20'::date;

-- to clear the all data for one biome. Eg.: pantanal (id_data_class=7)
DELETE FROM features WHERE id_data_class=7;

-- used to view all data for a biome for a specific LOI. Eg: pantanal and state (id_data_class=7 and id_data=7 and id_loi=1)
SELECT id_period, COUNT(*) as tt, SUM(area_km2) as area_km2
FROM features
WHERE id_data_class=7
AND id_data_loi_loinames IN (SELECT id FROM public.data_loi_loinames WHERE id_data=7 AND id_loi_loinames IN (SELECT id FROM public.loi_loinames WHERE id_loi=1))
GROUP BY 1 ORDER BY 1 ASC