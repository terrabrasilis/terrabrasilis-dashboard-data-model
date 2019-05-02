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

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_pampa', 'Dashboard of the Prodes in the Pampa', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_pantanal', 'Dashboard of the Prodes in the Pantanal', now());

  /* insert class */

  INSERT INTO public.class(id, name, description) VALUES (1, 'deforestation', 'It is the process of complete and permanent disappearance of forests');

  /* instert data */

  INSERT INTO public.data(id, name, description) VALUES (1, 'PRODES CERRADO', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (2, 'PRODES AMAZON', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (3, 'PRODES LEGAL AMAZON', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (4, 'PRODES PAMPA', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (5, 'PRODES PANTANAL', '1 year temporal resolution');

  /* insert data_class */

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (1, 1, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (2, 2, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (3, 3, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (4, 4, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (5, 5, 1);

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

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (7, 4, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (8, 4, 2);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (9, 5, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (10, 5, 2);

  /* insert period */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (1, 1, '1988-08-01', '2000-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (2, 1, '2000-08-01', '2002-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (3, 1, '2002-08-01', '2004-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (4, 1, '2004-08-01', '2006-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (5, 1, '2006-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (6, 1, '2008-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (7, 1, '2010-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (8, 1, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (9, 1, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (10, 1, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (11, 1, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (12, 1, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (19, 1, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (13, 2, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (14, 2, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (15, 2, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (16, 2, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (17, 2, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (18, 2, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (20, 3, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (21, 3, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (22, 3, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (23, 3, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (24, 3, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (25, 3, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (26, 4, '2000-01-01', '2016-12-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (27, 5, '2000-01-01', '2016-12-31');

  /* insert loi */

  INSERT INTO public.loi(id, name, description) VALUES (1, 'uf', 'States of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (2, 'mun', 'Municipalities of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (3, 'consunit', 'Conservation units of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (4, 'indi', 'Indigeneous Areas of Brazil');

  -- INSERT INTO public.loi(id, name, description) VALUES (5, 'pathrow', 'Landsat WSR2 Descending Path Row');

EOF