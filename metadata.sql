  BEGIN;
  
  /* clean all metadata tables using disable check constraints  */
  ALTER TABLE public.features DISABLE TRIGGER ALL;
  ALTER TABLE public.application DISABLE TRIGGER ALL;
  ALTER TABLE public.class DISABLE TRIGGER ALL;
  ALTER TABLE public.data DISABLE TRIGGER ALL;
  ALTER TABLE public.data_class DISABLE TRIGGER ALL;
  ALTER TABLE public.filter DISABLE TRIGGER ALL;
  ALTER TABLE public.data_filter DISABLE TRIGGER ALL;
  ALTER TABLE public.period DISABLE TRIGGER ALL;
  ALTER TABLE public.loi DISABLE TRIGGER ALL;

  DELETE FROM public.application;
  ALTER SEQUENCE public.application_id_seq RESTART WITH 1;
  DELETE FROM public.class;
  DELETE FROM public.data;
  DELETE FROM public.data_class;
  DELETE FROM public.filter;
  DELETE FROM public.data_filter;
  DELETE FROM public.period;
  DELETE FROM public.loi;

  
  /* insert application */

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_cerrado', 'Dashboard of the Prodes in the Cerrado', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_amazon', 'Dashboard of the Prodes in the Amazon', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_legal_amazon', 'Dashboard of the Prodes in the Legal Amazon Forest', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_pampa', 'Dashboard of the Prodes in the Pampa', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_pantanal', 'Dashboard of the Prodes in the Pantanal', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_caatinga', 'Dashboard of the Prodes in the Caatinga', now());

  INSERT INTO public.application(identifier, name, created) VALUES ('prodes_mata_atlantica', 'Dashboard of the Prodes in the Mata Atlantica', now());


  /* insert class */

  INSERT INTO public.class(id, name, description) VALUES (1, 'deforestation', 'It is the process of complete and permanent disappearance of forests');

  /* insert data */

  INSERT INTO public.data(id, name, description) VALUES (1, 'PRODES CERRADO', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (2, 'PRODES AMAZON', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (3, 'PRODES LEGAL AMAZON', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (4, 'PRODES PAMPA', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (5, 'PRODES MATA ATLANTICA', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (6, 'PRODES CAATINGA', '1 year temporal resolution');

  INSERT INTO public.data(id, name, description) VALUES (7, 'PRODES PANTANAL', '1 year temporal resolution');

  /* insert data_class */

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (1, 1, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (2, 2, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (3, 3, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (4, 4, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (5, 5, 1);
  
  INSERT INTO public.data_class(id, id_data, id_class) VALUES (6, 6, 1);

  INSERT INTO public.data_class(id, id_data, id_class) VALUES (7, 7, 1);

  /* insert filter */

  INSERT INTO public.filter(id, type) VALUES (1, 'fid_area >= 0.0625');

  INSERT INTO public.filter(id, type) VALUES (2, 'fid_area >= 0.01');

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

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (11, 6, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (12, 6, 2);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (13, 7, 1);

  INSERT INTO public.data_filter(id, id_data, id_filter) VALUES (14, 7, 2);
  /* insert period */

  /* PRODES CERRADO */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (1, 1, '1500-08-01', '2000-07-31');

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

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (13, 1, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (14, 1, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (15, 1, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (16, 1, '2020-08-01', '2021-07-31');

  /* PRODES AMAZON */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (30, 2, '1500-08-01', '2007-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (31, 2, '2007-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (32, 2, '2008-08-01', '2009-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (33, 2, '2009-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (34, 2, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (35, 2, '2011-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (36, 2, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (37, 2, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (38, 2, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (39, 2, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (40, 2, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (41, 2, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (42, 2, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (43, 2, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (44, 2, '2020-08-01', '2021-07-31');

  -- new years here ...

  /* PRODES LEGAL AMAZON */
  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (60, 3, '1500-08-01', '2007-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (61, 3, '2007-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (62, 3, '2008-08-01', '2009-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (63, 3, '2009-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (64, 3, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (65, 3, '2011-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (66, 3, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (67, 3, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (68, 3, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (69, 3, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (70, 3, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (71, 3, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (72, 3, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (73, 3, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (74, 3, '2020-08-01', '2021-07-31');

  -- new years here ...

  /* PRODES PAMPA */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (90, 4, '1500-08-01', '2000-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (91, 4, '2000-08-01', '2004-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (92, 4, '2004-08-01', '2006-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (93, 4, '2006-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (94, 4, '2008-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (95, 4, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (96, 4, '2011-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (97, 4, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (98, 4, '2014-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (99, 4, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (100, 4, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (101, 4, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (102, 4, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (103, 4, '2020-08-01', '2021-07-31');

  /* PRODES MATA ATLANTICA */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (120, 5, '1500-08-01', '2000-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (121, 5, '2000-08-01', '2002-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (122, 5, '2002-08-01', '2004-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (123, 5, '2004-08-01', '2006-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (124, 5, '2006-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (125, 5, '2008-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (126, 5, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (127, 5, '2011-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (128, 5, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (129, 5, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (130, 5, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (131, 5, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (132, 5, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (133, 5, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (134, 5, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (135, 5, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (136, 5, '2020-08-01', '2021-07-31');

  /* PRODES CAATINGA */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (150, 6, '1500-08-01', '2000-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (151, 6, '2000-08-01', '2002-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (152, 6, '2002-08-01', '2004-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (153, 6, '2004-08-01', '2006-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (154, 6, '2006-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (155, 6, '2008-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (156, 6, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (157, 6, '2011-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (158, 6, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (159, 6, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (160, 6, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (161, 6, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (162, 6, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (163, 6, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (164, 6, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (165, 6, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (166, 6, '2020-08-01', '2021-07-31');

  /* PRODES PANTANAL */

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (180, 7, '1500-08-01', '2000-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (181, 7, '2000-08-01', '2002-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (182, 7, '2002-08-01', '2004-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (183, 7, '2004-08-01', '2006-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (184, 7, '2006-08-01', '2008-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (185, 7, '2008-08-01', '2010-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (186, 7, '2010-08-01', '2011-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (187, 7, '2011-08-01', '2012-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (188, 7, '2012-08-01', '2013-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (189, 7, '2013-08-01', '2014-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (190, 7, '2014-08-01', '2015-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (191, 7, '2015-08-01', '2016-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (192, 7, '2016-08-01', '2017-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (193, 7, '2017-08-01', '2018-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (194, 7, '2018-08-01', '2019-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (195, 7, '2019-08-01', '2020-07-31');

  INSERT INTO public.period(id, id_data, start_date, end_date) VALUES (196, 7, '2020-08-01', '2021-07-31');
  

  /* insert loi */

  INSERT INTO public.loi(id, name, description) VALUES (1, 'uf', 'States of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (2, 'mun', 'Municipalities of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (3, 'consunit', 'Conservation units of Brazil');

  INSERT INTO public.loi(id, name, description) VALUES (4, 'indi', 'Indigeneous Areas of Brazil');

  -- INSERT INTO public.loi(id, name, description) VALUES (5, 'pathrow', 'Landsat WSR2 Descending Path Row');


  /* Enable all constraints after commit */
  ALTER TABLE public.features ENABLE TRIGGER ALL;
  ALTER TABLE public.application ENABLE TRIGGER ALL;
  ALTER TABLE public.class ENABLE TRIGGER ALL;
  ALTER TABLE public.data ENABLE TRIGGER ALL;
  ALTER TABLE public.data_class ENABLE TRIGGER ALL;
  ALTER TABLE public.filter ENABLE TRIGGER ALL;
  ALTER TABLE public.data_filter ENABLE TRIGGER ALL;
  ALTER TABLE public.period ENABLE TRIGGER ALL;
  ALTER TABLE public.loi ENABLE TRIGGER ALL;

  COMMIT;