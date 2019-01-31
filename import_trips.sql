DROP TABLE IF EXISTS gtfs_trips;

CREATE TABLE gtfs_trips (
  	route_id text , --REFERENCES gtfs_routes(route_id),
  	service_id    text , --REFERENCES gtfs_calendar(service_id),
  	trip_id text ,--PRIMARY KEY,
  	trip_headsign text,
	trip_short_name text,
  	direction_id  int , --REFERENCES gtfs_directions(direction_id),
  	block_id text,
  	shape_id text,  
  	wheelchair_accessible int, --FOREIGN KEY REFERENCES gtfs_wheelchair_accessible(wheelchair_accessible)
	trip_route_type int,
	route_pattern_id text,
	bikes_allowed int
);

COPY gtfs_trips FROM 'C:\Users\Anson\GTFS\Mass\January 2019\trips.txt' CSV HEADER; -- ENCODING 'windows-1252';

SELECT * FROM gtfs_trips LIMIT 10;