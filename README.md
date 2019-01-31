# Coverage and Vehicle Hours Metrics
This repo provides code for calculating the Base Coverage and Frequent Service in Dense Areas Coverage metrics as defined in the MBTA's Service Delivery Policy, as well as calculating the number of revenue vehicle hours on a typical weekday, Saturday, and Sunday. The code is written in PostgreSQL and requires PostGIS. 

The files for calculating the coverage metrics are 1.1-1.4. The code to calculate vehicle revenue hours is contained within a single file.

## Data requirements
This project relies on census block data for the state of Massachusetts, shapefiles of MBTA's Highest and Secondary Assessment Areas, and GTFS data for the MBTA. Specifically, it makes use of the trips.txt, stop_times.txt, stops.txt, routes.txt, and calendar.txt files.

## Coverage Files
File 1.1 produces 2 tables that will be used in later code. One is the buffer zone around all stops that constitute the main MBTA service, and one is the buffer zone around all stops service by high frequency routes.

Running file 1.2 will produce a single table containing a polygon delineating the MBTA service areas. It requires the data on MBTA's highest and secondary assessment areas.

Running file 1.3 requires the census block data. It creates a table that has one row per block and additional information about whether this block group is in the service area, in either of the buffer zones, and whether it is considered "high density."

File 1.4 uses the table from 1.3 to produce the final output, a table with the total population within the service area, the population within block groups that intersect with the buffer of all base service stops, the percent of the population living ithin .5 miles of a stop, the total population living within high density block groups, the population living within high density block groups and within .5 miles of a high frequency transit stop, and the percent of high density blocks residents that live within .5 miles of a high frequency transit stop. 

