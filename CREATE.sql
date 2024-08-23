set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'sams';

DROP DATABASE IF EXISTS SAMS;
CREATE DATABASE IF NOT EXISTS SAMS;

USE SAMS;

CREATE TABLE IF NOT EXISTS airline (
    airlineID VARCHAR(50),
    revenue INT NOT NULL,
    PRIMARY KEY (airlineID)
) engine = innodb;

CREATE TABLE IF NOT EXISTS location (
    locID VARCHAR(50),
    PRIMARY KEY (locID)
) engine = innodb;

CREATE TABLE IF NOT EXISTS airport (
    airportID CHAR(3),
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country CHAR(3) NOT NULL,
    locID VARCHAR(50),
    PRIMARY KEY (airportID),
    FOREIGN KEY (locID) REFERENCES location(locID) ON UPDATE CASCADE ON DELETE CASCADE
) engine = innodb;

CREATE TABLE IF NOT EXISTS airplane (
    airlineID VARCHAR(50),
    tail_num VARCHAR(50),
    seat_cap INT,
    speed INT,
    locID VARCHAR(50),
    plane_type VARCHAR(100),
    skids BOOLEAN,
    props INT,
    engines INT,
    PRIMARY KEY (airlineID, tail_num),
    FOREIGN KEY (airlineID) REFERENCES airline(airlineID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (locID) REFERENCES location(locID) ON UPDATE CASCADE ON DELETE CASCADE
) engine = innodb;

CREATE TABLE IF NOT EXISTS leg (
    legID VARCHAR(50),
    distance INT,
    departure CHAR(3) NOT NULL,
    arrival CHAR(3) NOT NULL,
    PRIMARY KEY (legID),
    FOREIGN KEY (departure) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (arrival) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE
) engine = innodb;

CREATE TABLE IF NOT EXISTS route (
    routeID VARCHAR(50),
    PRIMARY KEY (routeID)
) engine = innodb;

CREATE TABLE IF NOT EXISTS route_path (
    routeID VARCHAR(50),
    legID VARCHAR(50),
    sequence INT,
    PRIMARY KEY (routeID, legID, sequence),
    FOREIGN KEY (routeID) REFERENCES route(routeID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (legID) REFERENCES leg(legID) ON UPDATE CASCADE ON DELETE CASCADE
) engine = innodb;

CREATE TABLE IF NOT EXISTS flight (
    flightID VARCHAR(50),
    routeID VARCHAR(50) NOT NULL,
    support_airline VARCHAR(50),
    support_tail VARCHAR(50),
    progress INT,
    flight_status VARCHAR(10),
    next_time DATETIME,
    cost INT,
    PRIMARY KEY (flightID),
    FOREIGN KEY (routeID) REFERENCES route(routeID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (support_airline, support_tail) REFERENCES airplane(airlineID, tail_num) ON UPDATE CASCADE ON DELETE CASCADE
) engine = innodb;