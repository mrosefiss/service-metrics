-- This creates a single polygon which represents the MBTA service area 
-- It requires that the shapefile for the MBTA Highest Assessment Area be loaded into a table called "mbta_primary_area"
-- and that the shapefile for the MBTA Secondary Assessment Area be loaded into a table called "mbta_secondary_area"
CREATE TABLE mbta_service_areas AS
SELECT ST_UNION(
	ST_TRANSFORM(p.geom, 2163), ST_TRANSFORM(s.geom, 2163)
) as service_area
FROM mbta_primary_area p, mbta_secondary_area s;

