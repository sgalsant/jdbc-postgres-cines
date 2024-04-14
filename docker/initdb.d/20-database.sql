-- usuario que podrá modificar el modelo del esquema 'cines'. Por ejemplo, creando y borrando tablas
CREATE USER admin_cines WITH ENCRYPTED PASSWORD 'admin';

CREATE DATABASE bdcines WITH OWNER admin_cines ENCODING 'UTF8';

REVOKE ALL PRIVILEGES ON DATABASE bdcines FROM public;

GRANT ALL PRIVILEGES ON DATABASE bdcines TO admin_cines;


-- Cuando se realice búsquedas de objetos (como tablas) se buscará por defecto en el esquema 'cines'
ALTER DATABASE bdcines SET search_path TO cines;


-- se conecta a la base de datos 'bdcines'
\connect bdcines;


DROP SCHEMA IF EXISTS cines CASCADE;
CREATE SCHEMA IF NOT EXISTS cines AUTHORIZATION admin_cines;

-- usuario que se usaría desde la aplicación web con permisos para consultar y modificar los datos, nunca el modelo.
CREATE USER app_cines WITH ENCRYPTED PASSWORD 'app';

GRANT CONNECT ON DATABASE bdcines TO app_cines;
GRANT USAGE ON SCHEMA cines TO app_cines;

-- al utilizar "default privileges" haremos que para todas las tablas y secuencias que se creen en este esquema se otorguen permisos al usuario 'app_cines'
ALTER DEFAULT PRIVILEGES IN SCHEMA cines
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_cines;

-- Asignar permisos para ejecutar secuencias en el esquema cines
ALTER DEFAULT PRIVILEGES IN SCHEMA cines
    GRANT USAGE ON SEQUENCES TO app_cines;