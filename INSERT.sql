USE SAMS;

INSERT INTO airline VALUES 
('Vueling', 300),
('AirEuropa', 50),
('RyanAir', 10);

INSERT INTO location VALUES 
('loc1'),
('loc2'),
('loc3');

INSERT INTO airport  VALUES 
('JFK', 'John F. Kennedy International Airport', 'New York', 'NY', 'USA', 'loc1'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'USA', 'loc2'),
('ORD', 'O\'Hare International Airport', 'Chicago', 'IL', 'USA', 'loc3');

INSERT INTO airplane VALUES 
('Vueling', '12345', 180, 600, 'loc1', 'Boeing 737', FALSE, 0, 2),
('AirEuropa', '23456', 220, 650, 'loc2', 'Airbus A320', FALSE, 0, 2),
('RyanAir', '34567', 150, 580, 'loc3', 'Boeing 737', FALSE, 0, 2);

INSERT INTO leg VALUES 
('l1', 2475, 'JFK', 'LAX'),
('l2', 1744, 'LAX', 'ORD'),
('l3', 740, 'ORD', 'JFK');

INSERT INTO route VALUES 
('r1'),
('r2'),
('r3');

INSERT INTO route_path VALUES 
('r1', 'l1', 1),
('r2', 'l2', 2);

INSERT INTO flight VALUES 
('f1', 'r1', 'Vueling', '12345', 0, 'on_ground', '2024-07-19 08:00:00', 300),
('f2', 'r2', 'AirEuropa', '23456', 0, 'on_ground', '2024-07-19 09:00:00', 350),
('f3', 'r3', 'RyanAir', '34567', 0, 'in_flight', '2024-07-19 10:00:00', 250);