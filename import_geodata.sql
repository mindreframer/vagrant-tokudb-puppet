create table


geonameid         : integer id of record in geonames database
name              : name of geographical point (utf8) varchar(200)
asciiname         : name of geographical point in plain ascii characters, varchar(200)
alternatenames    : alternatenames, comma separated varchar(5000)
latitude          : latitude in decimal degrees (wgs84)
longitude         : longitude in decimal degrees (wgs84)
feature class     : see http://www.geonames.org/export/codes.html, char(1)
feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
country code      : ISO-3166 2-letter country code, 2 characters
cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
admin1 code       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)
admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
admin3 code       : code for third level administrative division, varchar(20)
admin4 code       : code for fourth level administrative division, varchar(20)
population        : bigint (8 byte int)
elevation         : in meters, integer
dem               : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
timezone          : the timezone id (see file timeZone.txt) varchar(40)
modification date




CREATE DATABASE test_db CHARACTER SET utf8 COLLATE utf8_general_ci;
use test_db;

DROP TABLE if exists geonames;
CREATE TABLE geonames (
   geonameid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(100),
   asciiname VARCHAR(200),
   alternatenames varchar(5000),
   latitude DECIMAL(10,7),
   longitude DECIMAL(10,7),
   feature_class char(1),
   feature_code varchar(10),
   country_code varchar(2),
   cc2 varchar(60),
   admin1_code varchar(20),
   admin2_code varchar(20)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

DROP TABLE if exists geonames_inno;
CREATE TABLE geonames_inno (
   geonameid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(100),
   asciiname VARCHAR(200),
   alternatenames varchar(5000),
   latitude DECIMAL(10,7),
   longitude DECIMAL(10,7),
   feature_class char(1),
   feature_code varchar(10),
   country_code varchar(2),
   cc2 varchar(60),
   admin1_code varchar(20),
   admin2_code varchar(20)
) CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=InnoDB;

/*
cp /vagrant/data/UA/UA.txt /tmp
cp /vagrant/data/RU/RU.txt /tmp
sudo chown mysql:mysql /tmp/*.txt
*/

LOAD DATA INFILE '/tmp/RU.txt' INTO
TABLE geonames_inno (geonameid,name, asciiname, alternatenames, latitude, longitude, feature_class,
feature_code, country_code, cc2, admin1_code, admin2_code);

LOAD DATA INFILE '/tmp/UA.txt' INTO
TABLE geonames_inno (geonameid,name, asciiname, alternatenames, latitude, longitude, feature_class,
feature_code, country_code, cc2, admin1_code, admin2_code);

LOAD DATA INFILE '/tmp/RU.txt' INTO
TABLE geonames (geonameid,name, asciiname, alternatenames, latitude, longitude, feature_class,
feature_code, country_code, cc2, admin1_code, admin2_code);

LOAD DATA INFILE '/tmp/UA.txt' INTO
TABLE geonames (geonameid,name, asciiname, alternatenames, latitude, longitude, feature_class,
feature_code, country_code, cc2, admin1_code, admin2_code);



ALTER TABLE `geonames_inno` ADD INDEX `index_feature_class` (`feature_class`);
ALTER TABLE `geonames` ADD INDEX `index_feature_class` (`feature_class`);
