#!/bin/bash

echo "Populating metadata..."

# pass username, password, host and database name as parameter
user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

psql postgresql://$user:$password@$host:$port/$database << EOF
  /* insert application */

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_cerrado', 'Dashboard of the Prodes in the Cerrado', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_amazon', 'Dashboard of the Prodes in the Amazon', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_legal_amazon', 'Dashboard of the Prodes in the Legal Amazon Forest', now());

  /* insert class */

  INSERT INTO public.class(id, name, description) VALUES (1, 'deforestation', 'It is the process of complete and permanent disappearance of forests');

  /* instert data */

  INSERT INTO public.data(id, name, description) VALUES (1, 'PRODES CERRADO', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (2, 'PRODES AMAZON', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (3, 'PRODES LEGAL AMAZON', '1 year temporal resolution');

  /* insert data_class */

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (1, 1, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (2, 2, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (3, 3, 1);

  /* insert filter */

  INSERT INTO public.filter(type) VALUES ('fid_area >= 0.0625');

  INSERT INTO public.filter(type) VALUES ('fid_area >= 0.01');

  /* insert data_filter */

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (1, 1, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (2, 1, 2);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (3, 2, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (4, 2, 2);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (5, 3, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (6, 3, 2);

  /* insert period */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (1, 1, '01/08/1988', '31/07/2000');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (2, 1, '01/08/2000', '31/07/2002');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (3, 1, '01/08/2002', '31/07/2004');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (4, 1, '01/08/2004', '31/07/2006');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (5, 1, '01/08/2006', '31/07/2008');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (6, 1, '01/08/2008', '31/07/2010');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (7, 1, '01/08/2010', '31/07/2012');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (8, 1, '01/08/2012', '31/07/2013');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (9, 1, '01/08/2013', '31/07/2014');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (10, 1, '01/08/2014', '31/07/2015');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (11, 1, '01/08/2015', '31/07/2016');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (12, 1, '01/08/2016', '31/07/2017');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (19, 1, '01/08/2017', '31/07/2018');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (13, 2, '01/08/2012', '31/07/2013');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (14, 2, '01/08/2013', '31/07/2014');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (15, 2, '01/08/2014', '31/07/2015');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (16, 2, '01/08/2015', '31/07/2016');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (17, 2, '01/08/2016', '31/07/2017');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (18, 2, '01/08/2017', '31/07/2018');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (20, 3, '01/08/2012', '31/07/2013');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (21, 3, '01/08/2013', '31/07/2014');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (22, 3, '01/08/2014', '31/07/2015');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (23, 3, '01/08/2015', '31/07/2016');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (24, 3, '01/08/2016', '31/07/2017');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (25, 3, '01/08/2017', '31/07/2018');

  /* insert loi */

  INSERT INTO public.loi(id, name, description) VALUES (1, 'uf', 'States of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (2, 'mun', 'Municipalities of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (3, 'consunit', 'Conservation units of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (4, 'indi', 'Indigeneous Areas of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (5, 'pathrow', 'Landsat WSR2 Descending Path Row');

EOF