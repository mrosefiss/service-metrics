# Coverage and Vehicle Hours Metrics
This repo provides code for calculating the Base Coverage and Frequent Service in Dense Areas Coverage metrics as defined in the MBTA's Service Delivery Policy, as well as calculating the number of revenue vehicle hours on a typical weekday, Saturday, and Sunday. The code is written in PostgreSQL and requires PostGIS. 

The files for calculating the coverage metrics are 1.1-1.4. The code to calculate vehicle revenue hours is contained within a single file.

## Coverage Files
File 1.1 produces 2 tables that will be used in later code. One is the buffer zone around all stops that constitute the main MBTA service, and one is the buffer zone around all stops service by high frequency routes.

Running file 1.2 will produce a single table containing a polygon delineating the MBTA service areas. It requires that the shapefiles for the primary and secondary MBTA service areas be loaded onto your local PostgreSQL server.

Running file 1.3 requires that data on the census blocks in Massachusetts be loaded onto your local PostgreSQL server to a table called "census." It creates a table that has one row per block and additional information about whether this block group is in the service area, in either of the buffer zones, and whether it is considered "high density."

File 1.4 uses the table from 1.3 to produce the final output, a table with the total population within the service area, the population within block groups that intersect with the buffer of all base service stops, the percent of the population living ithin .5 miles of a stop, the total population living within high density block groups, the population living within high density block groups and within .5 miles of a high frequency transit stop, and the percent of high density blocks residents that live within .5 miles of a high frequency transit stop. 
