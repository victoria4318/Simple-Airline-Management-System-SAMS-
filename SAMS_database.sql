DROP DATABASE SAMS;
CREATE DATABASE IF NOT EXISTS SAMS;

USE SAMS;

CREATE TABLE IF NOT EXISTS airline (
    airlineID VARCHAR(50) PRIMARY KEY,
    revenue DECIMAL(15, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS location (
    locID VARCHAR(50) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS airport (
    airportID CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country CHAR(3) NOT NULL,
    locID VARCHAR(50),
    FOREIGN KEY (locID) REFERENCES location(locID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS airplane (
    airlineID VARCHAR(50),
    tail_num VARCHAR(50),
    seat_cap INT,
    speed DECIMAL,
    locID VARCHAR(50),
    plane_type VARCHAR(20),
    skids BOOLEAN,
    props INT,
    engines INT,
    PRIMARY KEY (airlineID, tail_num),
    FOREIGN KEY (airlineID) REFERENCES airline(airlineID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (locID) REFERENCES location(locID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS leg (
    legID VARCHAR(50) PRIMARY KEY,
    distance DECIMAL,
    departure CHAR(3),
    arrival CHAR(3),
    FOREIGN KEY (departure) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (arrival) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS route (
    routeID INT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS route_path (
    routeID INT,
    legID VARCHAR(50),
    sequence INT CHECK (sequence > 0),
    PRIMARY KEY (routeID, sequence),
    FOREIGN KEY (routeID) REFERENCES route(routeID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (legID) REFERENCES leg(legID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS flight (
    flightID INT PRIMARY KEY,
    routeID INT NOT NULL,
    support_airline VARCHAR(50),
    support_tail VARCHAR(50),
    progress INT,
    status VARCHAR(10) CHECK (status IN ('on_ground', 'in_flight')),
    next_time TIMESTAMP,
    cost DECIMAL(10, 2),
    FOREIGN KEY (routeID) REFERENCES route(routeID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (support_airline, support_tail) REFERENCES airplane(airlineID, tail_num) ON UPDATE CASCADE ON DELETE CASCADE
);