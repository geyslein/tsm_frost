# TSM-STA-Interface

## Getting Started

Start frost with own Postgres-Database:
    
    docker-compose up -d

Open the database in your postgres-client and remove following Frost-tables:

- LOCATIONS_HIST_LOCATIONS
- HIST_LOCATIONS 
- LOCATIONS 
- MULTI_DATASTREAMS
- MULTI_DATASTREAMS_OBS_PROPERTIES
- **THINGS**
- **DATASTREAMS**
- **OBSERVATIONS**


Run [ufz_tsm_changes.sql](/sql/ufz_tsm_changes.sql) with credentials of one project scheme.

> Note: the replacement of "OBSERVATIONS" has to be done with a Materialized View. A standard view is extremely slow in this case.

Open your browser and navigate to:

  
    http://localhost:8080/FROST-Server/v1.1


Walk through Datastreams and Observations

> Note: links are sometimes broken in the web-interface due to a missing ')' at the end

> Note: Some columns/properties are still missing and need to be added before production.

## Resources

- https://fraunhoferiosb.github.io/FROST-Server/deployment/docker.html
- https://www.postgresql.org/docs/current/postgres-fdw.html

