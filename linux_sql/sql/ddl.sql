-- Switching to host_agent database
\c host_agent;
DROP DATABASE IF EXISTS host_agent;

CREATE DATABASE host_agent;
id,hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,L2_cache,total_mem,timestamp
-- Create host_info table if it doesn't already exist
CREATE TABLE IF NOT EXISTS PUBLIC.host_info
  (
     id               SERIAL NOT NULL PRIMARY KEY,
     hostname         VARCHAR NOT NULL UNIQUE,
     cpu_number       SMALLINT NOT NULL,
     cpu_architecture VARCHAR NOT NULL,
     cpu_model        VARCHAR NOT NULL,
     cpu_mhz          FLOAT NOT NULL,
     L2_cache         SMALLINT NOT NULL,
     total_mem        INT NOT NULL,
     timestamp        TIMESTAMP NOT NULL
  );

-- Create host_usage table if it doesn't already exist
CREATE TABLE IF NOT EXISTS PUBLIC.host_usage
  (
     "timestamp"    TIMESTAMP NOT NULL,
     host_id        SERIAL NOT NULL REFERENCES host_info(id) ON DELETE CASCADE,
     memory_free    INT NOT NULL,
     cpu_idle       SMALLINT NOT NULL,
     cpu_kernel     SMALLINT NOT NULL,
     disk_io        INT NOT NULL,
     disk_available INT NOT NULL
  );