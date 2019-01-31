-- This creates a single polygon which represents the MBTA service area
CREATE TABLE mbta_service_areas AS
SELECT ST_UNION(
	ST_TRANSFORM(p.geom, 2163), ST_TRANSFORM(s.geom, 2163)
) as service_area
FROM mbta_primary_area p, mbta_secondary_area s;

