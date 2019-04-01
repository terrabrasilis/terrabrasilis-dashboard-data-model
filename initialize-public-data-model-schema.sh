#!/bin/bash

# pass username, password, host and database name as parameter
echo "Initializing public data model schema..."

user="$1"
password="$2"
host="$3"
port="$4"
database="$5"

psql postgresql://$user:$password@$host:$port/$database << EOF
	\timing
	
	/* create extension */
	CREATE EXTENSION postgis;

	/* initialize database model */
	CREATE TABLE public.data
	(
		name text UNIQUE,
		description text

	);

	ALTER TABLE public.data ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE TABLE public.period
	(
		start_date date,
		end_date date,
		id_data int,
		CONSTRAINT id_data_FK FOREIGN KEY (id_data) REFERENCES data (id)
	);

	ALTER TABLE public.period ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE INDEX period_id_data_idx ON period (id_data);

	CREATE TABLE public.class
	(
		name text UNIQUE,
		description text

	);

	ALTER TABLE public.class ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE TABLE public.data_class
	(
		id_data int,
		CONSTRAINT id_data_FK FOREIGN KEY (id_data) REFERENCES data (id),
		id_class int,
		CONSTRAINT id_class_FK FOREIGN KEY (id_class) REFERENCES class (id)
	);

	ALTER TABLE public.data_class ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE INDEX data_class_id_class_FK_idx ON data_class (id_class);

	CREATE INDEX data_class_id_data_FK_idx ON data_class (id_data);

	CREATE TABLE public.filter
	(
		type text
	);

	ALTER TABLE public.filter ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE TABLE public.data_filter
	(
		id_data int,
		CONSTRAINT id_data_FK FOREIGN KEY (id_data) REFERENCES data (id),
		id_filter int,
		CONSTRAINT id_filter_FK FOREIGN KEY (id_filter) REFERENCES filter (id)
	);

	ALTER TABLE public.data_filter ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE INDEX data_filter_id_filter_FK_idx ON data_filter (id_filter);

	CREATE INDEX data_filter_id_data_FK_idx ON data_class (id_data);

	CREATE TABLE public.loi
	(
		name text UNIQUE,
		description text
	);

	ALTER TABLE public.loi ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE TABLE public.loinames
	(
		name text,
		description text
	);

	ALTER TABLE public.loinames ADD COLUMN gid SERIAL PRIMARY KEY;

	SELECT AddGeometryColumn ('public', 'loinames', 'geom', 4674, 'MULTIPOLYGON', 2);

	CREATE INDEX loinames_geom_idx ON loinames USING GIST (geom);

	CREATE TABLE public.loi_loinames
	(
		id_loi int,
		CONSTRAINT id_loi_FK FOREIGN KEY (id_loi) REFERENCES loi (id),
		gid_loinames int,
		CONSTRAINT gid_loinames_FK FOREIGN KEY (gid_loinames) REFERENCES loinames (gid)
	);

	ALTER TABLE public.loi_loinames ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE TABLE public.data_loi_loinames
	(
		id_data int,
		CONSTRAINT id_data_FK FOREIGN KEY (id_data) REFERENCES data (id),
		id_loi_loinames int,
		CONSTRAINT id_loi_loinames_FK FOREIGN KEY (id_loi_loinames) REFERENCES loi_loinames (id)
	);

	ALTER TABLE public.data_loi_loinames ADD COLUMN id SERIAL PRIMARY KEY;

	CREATE INDEX data_loi_loinames_id_data_FK_idx ON data_loi_loinames (id_data);

	CREATE INDEX data_loi_loinames_id_loi_loinames_FK_idx ON data_loi_loinames (id_loi_loinames);

	CREATE TABLE public.features
	(
		id_period int,
		id_data_loi_loinames int,
		id_data_class int,
		created_at timestamp,
		gid_polygon text,
		CONSTRAINT id_period_FK FOREIGN KEY (id_period) REFERENCES period (id),
		CONSTRAINT id_data_class_FK FOREIGN KEY (id_data_class) REFERENCES data_class (id),
		CONSTRAINT id_data_loi_loinames_FK FOREIGN KEY (id_data_loi_loinames) REFERENCES data_loi_loinames (id),
		PRIMARY KEY (id_period, id_data_loi_loinames, id_data_class, gid_polygon)
	);

	SELECT AddGeometryColumn ('public', 'features', 'geom', 4674, 'MULTIPOLYGON', 2);

	CREATE INDEX features_geom_idx ON features USING GIST (geom);

	CREATE INDEX features_id_data_loi_loinames_FK_idx ON features (id_data_loi_loinames);

	CREATE INDEX features_id_period_FK_idx ON features (id_period);

	CREATE INDEX features_id_data_class_FK_idx ON features (id_data_class);

	ALTER TABLE public.features ADD COLUMN area_km2 double precision DEFAULT NULL;

	CREATE SEQUENCE public.application_id_seq INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

	ALTER SEQUENCE public.application_id_seq OWNER TO postgres;

	CREATE TABLE public.application
	(
		id bigint NOT NULL DEFAULT nextval('application_id_seq'::regclass),
		created timestamp without time zone,
		identifier character varying(255) COLLATE pg_catalog."default",
		name character varying(255) COLLATE pg_catalog."default",
		updated timestamp without time zone,
		uuid character varying(255) COLLATE pg_catalog."default",
		CONSTRAINT application_pkey PRIMARY KEY (id)
	)
	WITH (
		OIDS = FALSE
	)
	TABLESPACE pg_default;

	ALTER TABLE public.application OWNER to postgres;
EOF