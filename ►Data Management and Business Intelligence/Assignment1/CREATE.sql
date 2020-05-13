-- -----------------------------------------------------
-- Schema CRC
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS crc;
CREATE SCHEMA IF NOT EXISTS crc DEFAULT CHARACTER SET utf8 ;
USE crc ;

-- -----------------------------------------------------
-- Table CRC.category
-- -----------------------------------------------------

DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category(
idcategory INT NOT NULL auto_increment,
label VARCHAR(20),
catdescription VARCHAR(100),
PRIMARY KEY(idcategory));

-- -----------------------------------------------------
-- Table CRC.cars
-- -----------------------------------------------------

DROP TABLE IF EXISTS cars;
CREATE TABLE IF NOT EXISTS cars(
VIN VARCHAR(50),
idcategory INT NOT NULL,
description VARCHAR(100),
color VARCHAR(20),
brand VARCHAR(20),
model VARCHAR(20),
purchasedate DATE,
PRIMARY KEY(VIN),
FOREIGN KEY(idcategory) 
REFERENCES category(idcategory) 
ON DELETE CASCADE);

-- -----------------------------------------------------
-- Table CRC.customer
-- -----------------------------------------------------
 
 DROP TABLE IF EXISTS customer;
 CREATE TABLE IF NOT EXISTS customer(
 idcustomer INT NOT NULL auto_increment,
 SSN VARCHAR(20),
 custfirstname VARCHAR(50),
 custlastname VARCHAR(50),
 email VARCHAR(50),
 phone VARCHAR(20),
 state_abbrev VARCHAR(20),
 state_name VARCHAR(50),
 country VARCHAR(50),
 PRIMARY KEY (idcustomer));
 ALTER TABLE customer AUTO_INCREMENT=10000;
 
-- -----------------------------------------------------
-- Table CRC.location
-- -----------------------------------------------------
 
 DROP TABLE IF EXISTS location;
 CREATE TABLE IF NOT EXISTS location(
 idlocation INT NOT NULL auto_increment,
 street VARCHAR(20),
 stnumber INT,
 city VARCHAR(20),
 locstate VARCHAR(20),
 loccountry VARCHAR(20),
 PRIMARY KEY(idlocation));
 
-- -----------------------------------------------------
-- Table CRC.loctelnumbers
-- -----------------------------------------------------
 
 DROP TABLE IF EXISTS loctelnumbers;
 CREATE TABLE IF NOT EXISTS loctelnumbers(
 idlocation INT,
 Phone_Numbers VARCHAR(50),
 FOREIGN KEY(idlocation) 
 REFERENCES location(idlocation)  
 ON DELETE CASCADE);
 
-- -----------------------------------------------------
-- Table CRC.lease
-- -----------------------------------------------------
 
DROP TABLE IF EXISTS lease;
CREATE TABLE IF NOT EXISTS lease(
idlease  INT NOT NULL auto_increment,
amount DECIMAL(12,2) NOT NULL,
since DATETIME NOT NULL,
until DATETIME  NOT NULL,
PRIMARY KEY(idlease),
VIN VARCHAR(50),
idcustomer INT NOT NULL,
pickuploc INT(20) NOT NULL,
returnloc INT(20) NOT NULL,
CHECK(amount>0),
FOREIGN KEY(idcustomer) 
REFERENCES customer(idcustomer) 
ON DELETE CASCADE,
FOREIGN KEY(pickuploc) 
REFERENCES location(idlocation) 
ON DELETE CASCADE,
FOREIGN KEY(returnloc) 
REFERENCES location(idlocation) 
ON DELETE CASCADE,
FOREIGN KEY( VIN) 
REFERENCES cars(VIN) 
ON DELETE CASCADE);
 


