#!/bin/bash
set -e

# Run the SQL init with --force so non-fatal warnings (like 1262 row truncations)
# don't kill the entrypoint process.
# Use root password provided by the container env during init.
mariadb --user=root --password="${MARIADB_ROOT_PASSWORD}" --force <<'SQL'

CREATE DATABASE IF NOT EXISTS spotfy_DB;
USE spotfy_DB;

CREATE TABLE IF NOT EXISTS spotfy_data (
    artist VARCHAR(255),
    song   VARCHAR(255),
    link   TEXT,
    text   LONGTEXT
);

LOAD DATA INFILE '/docker-entrypoint-initdb.d/spotify_millsongdata.csv'
INTO TABLE spotfy_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(artist, song, link, text);

SELECT CONCAT('Loaded rows: ', COUNT(*)) AS status FROM spotfy_data;

SQL
