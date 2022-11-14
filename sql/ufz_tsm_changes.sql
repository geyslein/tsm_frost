
CREATE extension postgres_fdw;

CREATE SERVER rdm_tsm FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '<TSM_DATABASE_HOST>', dbname '<TSM_DATABASE_NAME>', port '5432');

CREATE USER MAPPING FOR sensorthings SERVER rdm_tsm OPTIONS (user '<PROJECT_INSTANCE_SCHEMA_NAME>', password '<PROJECT_INSTANCE_SCHEMA_PASS>');




CREATE FOREIGN TABLE thing (
    id          bigserial,
    name        varchar(200) not null,
    uuid        uuid         not null,
    description text,
    properties  jsonb
)
        SERVER rdm_tsm
        OPTIONS (schema_name '<PROJECT_INSTANCE_SCHEMA_NAME>', table_name 'thing');


CREATE VIEW "THINGS" AS SELECT
id as "ID",
description as "DESCRIPTION",
properties as "PROPERTIES",
name as "NAME"
from thing;



CREATE FOREIGN TABLE datastream (
    id          bigserial,
    name        varchar(200) not null,
    description text,
    properties  jsonb,
    position    varchar(200) not null,
    thing_id    bigint       not null
)
        SERVER rdm_tsm
        OPTIONS (schema_name '<PROJECT_INSTANCE_SCHEMA_NAME>', table_name 'datastream');



CREATE VIEW "DATASTREAMS" AS SELECT
id as "ID",
name as "NAME",
description as "DESCRIPTION",
text '' as "OBSERVATION_TYPE",
null as "PHENOMENON_TIME_START",
null as "PHENOMENON_TIME_END",
null as "RESULT_TIME_START",
null as "RESULT_TIME_END",
bigint '1' as "SENSOR_ID",
bigint '1' as "OBS_PROPERTY_ID",
thing_id as "THING_ID",
varchar(255) '' as "UNIT_NAME",
varchar(255) '' as "UNIT_SYMBOL",
varchar(255) '' as "UNIT_DEFINITION",
null as "OBSERVED_AREA",
properties as "PROPERTIES",
bigint '0' as "LAST_FOI_ID"
from datastream;



CREATE FOREIGN TABLE observation (
    phenomenon_time_start timestamp with time zone,
    phenomenon_time_end   timestamp with time zone,
    result_time           timestamp with time zone not null,
    result_type           smallint                 not null,
    result_number         double precision,
    result_string         varchar(200),
    result_json           jsonb,
    result_boolean        boolean,
    result_latitude       double precision,
    result_longitude      double precision,
    result_altitude       double precision,
    result_quality        jsonb,
    valid_time_start      timestamp with time zone,
    valid_time_end        timestamp with time zone,
    parameters            jsonb,
    datastream_id         bigint                   not null,
    obs_id                bigint                   not null
)
        SERVER rdm_tsm
        OPTIONS (schema_name '<PROJECT_INSTANCE_SCHEMA_NAME>', table_name 'observation');


CREATE MATERIALIZED VIEW "OBSERVATIONS" AS SELECT
phenomenon_time_start as "PHENOMENON_TIME_START",
phenomenon_time_end as "PHENOMENON_TIME_END",
result_time as "RESULT_TIME",
CASE
   WHEN observation.result_type = 1 THEN 0
   WHEN observation.result_type = 2 THEN 1
   WHEN observation.result_type = 3 THEN 2
   ELSE
        observation.result_type
END as "RESULT_TYPE",
result_number as "RESULT_NUMBER",
result_boolean as "RESULT_BOOLEAN",
result_json as "RESULT_JSON",
result_string as "RESULT_STRING",
result_quality as "RESULT_QUALITY",
valid_time_start as "VALID_TIME_START",
valid_time_end as "VALID_TIME_END",
parameters as "PARAMETERS",
datastream_id "DATASTREAM_ID",
bigint '1' as "FEATURE_ID",
null as "MULTI_DATASTREAM_ID",
row_number() over() as "ID"
from observation;
