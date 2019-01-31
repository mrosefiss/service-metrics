CREATE EXTENSION postgis;

--Base Coverage

-- I select the base stops as those that belong to any route that offers what I define to be 
-- typical service, so I filter out the routes that are classified as "Rail Replacement", 
-- "Limited Service", or "Airport Shuttle" as these are either irregular or so specified as to 
-- warrant exemption for analysis intended to calculate how many people are connected to the 
-- transit system at large
CREATE TABLE base_stops AS
SELECT DISTINCT s.stop_name, s.the_geom
FROM gtfs_routes r
JOIN gtfs_trips t on r.route_id = t.route_id
JOIN gtfs_stop_times st on st.trip_id = t.trip_id
JOIN gtfs_stops s on s.stop_id = st.stop_id
WHERE r.route_desc NOT IN ('Limited Service','Rail Replacement Bus','Airport Shuttle');

-- This creates a table with a single cell: a geometry shape of the buffer zone around the
-- stops identified in the previous query. The distance, for simplification purposes, is as the crow flies
CREATE TABLE base_buffer AS
SELECT ST_UNION(
	ST_BUFFER(
		ST_TRANSFORM(the_geom,2163) --CRS 2163 = US NAtional Atlas Equal-Area projection
	,800) -- 800m 
) as buffer
FROM base_stops;

-- This table gives the names and locations of all stops on key bus routes or rabid transit lines,
-- which we will consider to be stops with frequent service
CREATE TABLE frequent_stops AS
SELECT DISTINCT s.stop_name, s.the_geom
FROM gtfs_routes r
JOIN gtfs_trips t on r.route_id = t.route_id
JOIN gtfs_stop_times st on st.trip_id = t.trip_id
JOIN gtfs_stops s on s.stop_id = st.stop_id
WHERE r.route_desc IN ('Key Bus','Rapid Transit');

-- This table makes a single shape that consists of the area within an 800 meter buffer of
-- a frequent stop as defined in the previous table
CREATE table frequent_buffer AS 
SELECT ST_UNION(
	ST_BUFFER(
		ST_TRANSFORM(the_geom,2163) --CRS 2163 = US NAtional Atlas Equal-Area projection
	,800) -- 800m 
) as buffer
FROM frequent_stops;


