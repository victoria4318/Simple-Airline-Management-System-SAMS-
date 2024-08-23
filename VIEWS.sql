DROP VIEW IF EXISTS flights_air;
DROP VIEW IF EXISTS flights_ground;
DROP VIEW IF EXISTS alternative_airports;

CREATE VIEW flights_air AS 
WITH num_flights AS (
    SELECT l.legID, COUNT(*) AS flight_count
    FROM flight f
    JOIN route_path rp ON f.routeID = rp.routeID
    JOIN leg l ON rp.legID = l.legID
    WHERE f.flight_status = 'in_flight'
    GROUP BY l.legID
)
SELECT f.flightID, l.departure, l.arrival, f.next_time, 
       CONCAT(f.support_airline, f.support_tail) AS support_aircraft, nf.flight_count
FROM flight f
JOIN route_path rp ON f.routeID = rp.routeID
JOIN leg l ON rp.legID = l.legID
JOIN num_flights nf ON nf.legID = l.legID
WHERE f.flight_status = 'in_flight';

CREATE VIEW flights_ground AS 
WITH num_grounded AS (
    SELECT l.departure, COUNT(*) AS flight_count
    FROM flight f
    JOIN route_path rp ON f.routeID = rp.routeID
    JOIN leg l ON rp.legID = l.legID
    WHERE f.flight_status = 'on_ground'
    GROUP BY l.departure
)
SELECT f.flightID, l.departure, 
       CONCAT(f.support_airline, f.support_tail) AS support_aircraft, ng.flight_count
FROM flight f
JOIN route_path rp ON f.routeID = rp.routeID
JOIN leg l ON rp.legID = l.legID
JOIN num_grounded ng ON ng.departure = l.departure
WHERE f.flight_status = 'on_ground';

CREATE VIEW alternative_airports AS 
WITH num_airports AS (
    SELECT a.city, COUNT(*) AS airport_count
    FROM airport a
    GROUP BY a.city
)
SELECT a.city, a.state, na.airport_count, a.airportID, a.airport_name
FROM airport a
JOIN num_airports na ON a.city = na.city;