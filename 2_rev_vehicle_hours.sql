-- This query calculates the length of each trip in the subquery by looking at the difference between
-- the latest stop departure time and the earliest stop arrival time per trip. 
-- It then sums up the durations of all trips, aggregating at the route description and 
-- day of week levels.
SELECT route_desc, 
	CASE WHEN weekdays = 5 THEN 'weekday' -- From calendar.txt, this means the service runs all weekdays
		WHEN saturday = 1 THEN 'saturday' -- From calendar.txt, this means the service runs saturday
		WHEN sunday = 1 THEN 'sunday' -- Included Sunday for comparison to Saturday
		ELSE NULL END as day_of_week,
	TRUNC(SUM(trip_duration)::numeric / 60, 2) as total_vehicle_hours -- Trip duration is calculated in minutes in the subquery so convert back to hours here
FROM ( -- This subquery calculates the length in minutes of each trip
SELECT t.trip_id, r.route_id, t.service_id, r.route_desc,  
-- The following code calculates the length in minutes of each trip by stripping the hours and minutes
-- from the text timestamps and multiplying the hours by 60
	MAX((left(departure_time, 2)::int * 60) + (substring(departure_time from 4 for 2)::int)) -
		MIN((left(arrival_time, 2)::int * 60) + (substring(arrival_time from 4 for 2)::int)) as trip_duration,
-- I include in this subquery details about the service. Namely, which days of the week does it run.
-- I sum up the booleans from the individual weekdays, but all service is either run on 5 weekdays or 0
	monday + tuesday + wednesday + thursday + friday as weekdays,
	saturday,
	sunday
FROM gtfs_routes r
JOIN gtfs_trips t on r.route_id = t.route_id
JOIN gtfs_stop_times st on st.trip_id = t.trip_id
JOIN gtfs_calendar c on c.service_id = t.service_id
WHERE c.end_date - c.start_date > 0 -- Filter out service types that were only run on 1 day
	AND route_desc ILIKE '%bus%' -- Only look at buses 
GROUP BY 1,2,3,4,6,7,8
--LIMIT 10
	) sub
WHERE sub.weekdays + sub.saturday + sub.sunday > 0 -- Filter out services that were not designated as typically weekday or saturday or sunday
GROUP BY 1,2
ORDER BY 1,2;

