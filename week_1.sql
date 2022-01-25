-- Question 3. Count records
-- How many taxi trips were there on January 15?
-- Consider only trips that started on January 15.

SELECT TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

								'dd-mon') AS DT,
	COUNT(*) AS COUNT_OF_STARTED_RIDES
FROM YELLOW_TAXI_DATA YTD
WHERE TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

							'dd-mon') = '15-jan'
GROUP BY TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

										'dd-mon') ;

-- Count of rides started on 15-JAN
-- ANSWER : "15-jan" : 53024

 -- Question 4. Largest tip for each day
 -- Find the largest tip for each day. On which day it was the largest tip in January?
 -- Use the pick up time for your calculations.
 -- (note: it's not a typo, it's "tip", not "trip")

SELECT TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

								'dd-mon') AS DT,
	MAX(YTD.TIP_AMOUNT) AS MAX_TIP,
	COUNT(*)
FROM YELLOW_TAXI_DATA YTD -- WHERE TO_CHAR(YTD.TPEP_PICKUP_DATETIME,
 -- 							'dd-mon') = '15-jan'
GROUP BY TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

										'dd-mon')
ORDER BY 2 DESC
LIMIT 1;

-- ANSWER : 2021-01-20 : 1140.44


 -- Question 5. Most popular destination
 -- What was the most popular destination for passengers picked up in central park on January 14?
 -- Use the pick up time for your calculations.
 -- Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"

SELECT DROP_ZONE,
	COUNT(*)
FROM
	(SELECT YTD."PULocationID",
			YTD."DOLocationID",
			ZONES_PICK_UP."LocationID" PICKUP_ID,
			COALESCE(ZONES_PICK_UP."Zone",

				'Unknown') AS PICKUP_ZONE,
			ZONES_DROP."LocationID" DROP_ID,
			COALESCE(ZONES_DROP."Zone",

				'Unknown') AS DROP_ZONE
		FROM YELLOW_TAXI_DATA AS YTD
		LEFT OUTER JOIN ZONES AS ZONES_PICK_UP ON YTD."PULocationID" = ZONES_PICK_UP."LocationID"
		LEFT OUTER JOIN ZONES AS ZONES_DROP ON YTD."DOLocationID" = ZONES_DROP."LocationID"
		WHERE TO_CHAR(YTD.TPEP_PICKUP_DATETIME,

									'dd-mon') = '14-jan'
			AND ZONES_PICK_UP."Zone" = 'Central Park') AS CENTRAL_PARK_PICKUPS
GROUP BY DROP_ZONE
ORDER BY COUNT(*) DESC ;

-- ANSWER : Upper East Side South:97

SELECT ZONES."Zone",
	COALESCE(ZONES."Zone",

		'Unknown')
FROM ZONES;

-- QUESTION 6. MOST EXPENSIVE LOCATIONS 
-- What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?
 -- Enter two zone names separated by a slash
 -- For example:
 -- "Jamaica Bay / Clinton East"
 -- If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East".

SELECT ALL_RIDES.PICKUP_ZONE || '/' || ALL_RIDES.DROP_ZONE, 
	AVG(ALL_RIDES.TOTAL_AMOUNT) AVERAGE_RIDE_PRICE
FROM 
	(SELECT YTD."PULocationID", 
			YTD."DOLocationID", 
			ZONES_PICK_UP."LocationID" PICKUP_ID, 
			COALESCE(ZONES_PICK_UP."Zone", 
				
				'Unknown') AS PICKUP_ZONE, 
			ZONES_DROP."LocationID" DROP_ID, 
			COALESCE(ZONES_DROP."Zone", 
				
				'Unknown') AS DROP_ZONE,
			YTD.TOTAL_AMOUNT
		FROM YELLOW_TAXI_DATA AS YTD
		LEFT OUTER JOIN ZONES AS ZONES_PICK_UP ON YTD."PULocationID" = ZONES_PICK_UP."LocationID"
		LEFT OUTER JOIN ZONES AS ZONES_DROP ON YTD."DOLocationID" = ZONES_DROP."LocationID") AS ALL_RIDES
GROUP BY ALL_RIDES.PICKUP_ZONE,
	ALL_RIDES.DROP_ZONE
ORDER BY AVG(ALL_RIDES.TOTAL_AMOUNT) DESC;

-- ANSWER : Alphabet City/Unknown