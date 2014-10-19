-- Database init script for CP voting db.
-- WARNING:  This script will destroy an otherwise healthy database.
-- USE WITH CAUTION

DROP DATABASE IF EXISTS cp;
CREATE DATABASE cp;
USE cp;

CREATE TABLE vote(
  vote_id  INT UNSIGNED NOT NULL auto_increment,
  video_id  CHAR(8) NOT NULL,
  ip_address  CHAR(15) NULL,
  datestamp  DATETIME NOT NULL,
  
  PRIMARY KEY (vote_id)
);

CREATE USER 'cp'@'localhost' IDENTIFIED BY 'cp';
GRANT ALL PRIVILEGES ON cp.* to 'cp'@'localhost';
FLUSH PRIVILEGES;