-- This performs our final calculations. It filters out entirely those blocks that are not in 
-- the service area. The entire population of a block groups is counted without consideration of 
-- the extent to which it overlaps with the mbta service area or either of the stop buffers. 
SELECT SUM(poptotal) as service_area_pop,
	SUM(
		CASE WHEN near_base_stop is true THEN poptotal 
		ELSE 0 END
	) as pop_near_base_stop, -- we sum the poptotal column of only those rows that have a true value in "near_base_stop"
	(SUM(
		CASE WHEN near_base_stop is true THEN poptotal 
		ELSE 0 END
		) * 100.0
	)::float / SUM(poptotal) as base_coverage, -- This is the ratio of the previous 2 calculations
	SUM(
		CASE WHEN high_dens is true THEN poptotal 
		ELSE 0 END
	) as pop_high_dens, -- Sum the populations of only the high density blocks
	SUM(
		CASE WHEN near_frequent_stop is true 
		AND high_dens is true THEN poptotal 
		ELSE 0 END
	) as high_dens_pop_near_frequent_stop, -- Sum the populations of only blocks that are both high density and close to a frequent stop
	(
		(
		SUM(
			CASE WHEN near_frequent_stop is true 
			AND high_dens is true THEN poptotal 
			ELSE 0 END
			)
		) * 100.0
	)::float / SUM(
		CASE WHEN high_dens is true THEN poptotal 
		ELSE 0 END
	) as frequent_high_dens_coverage -- Ratio of the previous 2.
FROM block_membership
WHERE in_service_area is true
	 ;

