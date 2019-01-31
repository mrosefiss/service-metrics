-- Now we create the "block membership" table, which has a row for each census block and contains 
-- its id, its population, its geometry, as well as booleans that indicate whether it is 
-- in the service area, near a base service stop, near a stop that receives frequent service, and
-- whether it is "high density" (meaning contains more than 7000 people per square mile)
CREATE TABLE block_membership AS
SELECT c.gid, c.poptotal, c.geom as block_geom, 
	bb.buffer as base_buffer, fb.buffer as frequent_buffer, s.service_area, 
	ST_INTERSECTS(ST_TRANSFORM(c.geom, 2163), s.service_area) as in_service_area, --Checks to see if the block geometry intersects at all with the mbta service area polygon
	ST_INTERSECTS(ST_TRANSFORM(c.geom, 2163), bb.buffer) as near_base_stop, -- This and the next line are similar to the above line but for the two stop buffers
	ST_INTERSECTS(ST_TRANSFORM(c.geom, 2163), fb.buffer) as near_frequent_stop,
	CASE WHEN poptotal / (ST_AREA(c.geom::geography)/(1609.34^2)) > 7000 
		THEN TRUE 
		ELSE FALSE 
		END AS high_dens -- Divides the population by the area of the block, converted to be in square miles, and classifies it as high density if it is > 7000 people/square mile
FROM census c, base_buffer bb, frequent_buffer fb, mbta_service_area s;
