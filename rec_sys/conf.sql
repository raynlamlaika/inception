-- here cleaning data just for taking and walkout into syntax

CREATE DATABASE IF NOT EXISTS spotfy_DB;
USE spotfy_DB;




CREATE TABLE IF NOT EXISTS spotfy_data (
    artist VARCHAR(255),
    song VARCHAR(255),
    link TEXT,
    text LONGTEXT
);

-- fisrt load data

LOAD DATA INFILE '/docker-entrypoint-initdb.d/spotify_millsongdata.csv'
INTO TABLE spotfy_data
FIELDS TERMINATED BY ',' -- define the separator of the data row
ENCLOSED BY '"' -- define the character used to enclose the data row
ESCAPED BY '"' -- standard CSV escaping: "" inside a quoted field = literal "
LINES TERMINATED BY '\n' -- Unix line endings (LF)
IGNORE 1 ROWS -- do ignore the first row of the data file which is the header
(artist, song, link, text); -- 4 columns: no pandas index in this CSV


-- print the first 5 argemment of the data
SELECT * FROM spotfy_data LIMIT 5;




