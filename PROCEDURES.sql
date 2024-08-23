/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;	
set SQL_SAFE_UPDATES = 0;

-- set @thisDatabase = 'flight_tracking';
-- use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
	returns time reads sql data
begin
	declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);
end //
delimiter ;

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on its type, like skids or some number
of engines.  Finally, an airplane must have a new and database-wide unique location
since it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in p_airlineID varchar(50), in p_tailNumber varchar(50),
	in p_seatCapacity integer, in p_speed integer, in p_locationID varchar(50),
    in p_planeType varchar(100), in p_skids boolean, in p_propellers integer,
    in p_jetEngines integer)
sp_main: begin
	if p_locationID not in (select locID from location) and
       p_speed > 0 and
       p_seatCapacity > 0 and
       p_airlineID in (select airlineID from airline) and 
       p_tailNumber not in (select tail_num from airplane join airline on airplane.airlineID = airline.airlineID) then
		insert into airplane values (p_airlineID, p_tailNumber, p_seatCapacity, p_speed, p_locationID, p_planeType, p_skids, p_propellers, p_jetEngines);
	end if;
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a new and database-wide unique location if it will be used
to support airplane takeoffs and landings.  An airport may have a longer, more
descriptive name.  An airport must also have a city, state, and country designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in p_airportID char(3), in p_airportName varchar(200),
    in p_city varchar(100), in p_state varchar(100), in p_country char(3), in p_locationID varchar(50))
sp_main: begin
	if p_locationID not in (select locID from location) and 
		p_airportID not in (select airportID from airport) then
		insert into airport values (p_airportID, p_airportName, p_city, p_state, p_country, p_locationID);
    end if;
end //
delimiter ;

-- [3] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  And
the airplane, if designated, must not be in use by another flight.  The flight
can be started at any valid location along the route except for the final stop,
and it will begin on the ground.  You must also include when the flight will
takeoff along with its cost. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in p_flightID varchar(50), in p_routeID varchar(50),
    in p_supportAirline varchar(50), in p_supportTail varchar(50), in p_progress integer,
    in p_nextTime time, in p_cost integer)
sp_main: begin
	if concat(p_supportAirline, p_supportTail) not in (select concat(support_airline, support_tail) from flight) and 
	   p_progress = (select max(sequence) from route_path where p_routeID = routeID) and
       p_routeID is not null then
       insert into flight values (p_flightID, p_routeID, p_supportAirline, p_supportTail, p_progress, 'on_ground', p_nextTime, p_cost);
    end if;
end //
delimiter ;

-- [4] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along its route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel. 
*/
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in p_flightID varchar(50))
sp_main: begin
    update flight
    set flight_status = 'on_ground',
        next_time = ADDTIME(next_time, '01:00:00')
    where 
        flightID = p_flightID;
end //
delimiter ;

-- [5] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route. */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in p_flightID varchar(50))
sp_main: begin
	if (select flight_status from flight where flightID = p_flightID) = 'on_ground' and 
       ((select progress from flight where flightID = p_flightID) = 0 or 
        (select progress from flight where flightID = p_flightID) = 
        (select max(sequence) from route_path join flight on flight.routeID = route_path.routeID where flightID = p_flightID)) then
        delete from flight where flightID = p_flightID;
    end if;
end //
delimiter ;
