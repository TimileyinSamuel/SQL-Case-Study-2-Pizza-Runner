############################################# CASE STUDY 2: PIZZA RUNNER
### CREATING DATABASE
CREATE DATABASE pizza_runner;
USE pizza_runner;

### CREATING TABLES
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);


INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);


INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);

INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  

############################################################ DATA CLEANING #################################################################
#### The tables customer_orders AND runner_orders need some cleaning

#### Checking Data Types of the customer_orders table
### First check the DATA TYPE for each column
SELECT Column_name, Data_type
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'customer_orders';

#### Cleaning required for the customer_orders table
### 1. Turning Rows with 'null' in both columns (exclusion and extras) to NULL

## To do this, I need to set safe updates to 0
## Changing from safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = 'null' 
				 THEN NULL
				 WHEN exclusions = ''
				 THEN NULL
				 END
WHERE exclusions = 'null'
OR exclusions = '';

UPDATE customer_orders
SET extras = CASE WHEN extras = 'null'  
			 THEN NULL
			 WHEN extras = ''
		     THEN NULL
			 END
WHERE extras = 'null'
OR extras = '';

### Checking the updated table
SELECT *
FROM customer_orders;


#### Checking Data Types of the runner_orders table
### First check the DATA TYPE for each column
SELECT Column_name, Data_type
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'runner_orders';

#### Cleaning required for the RUNNER_ORDERS table

## 2. change 'null' in the pickup_time column to NULL
UPDATE runner_orders
SET pickup_time = CASE WHEN pickup_time = 'null' 
				  THEN NULL
				  END
WHERE pickup_time = 'null';

## 3. change null in the duration column to NULL
UPDATE runner_orders
SET duration = CASE WHEN duration = 'null' 
			   THEN NULL
			   END
WHERE duration = 'null';

## 4. remove the 'km' added at the end of rows in distance
UPDATE runner_orders
SET distance = REPLACE(distance, 'km', '');

## 5. Trim the Distance column after removing 'km'
UPDATE runner_orders
SET distance = TRIM(distance);

## 6. change null in the distance column to NULL using CASE WHEN statement
UPDATE runner_orders
SET distance = CASE WHEN distance = 'null' 
				THEN NULL
				END
WHERE distance = 'null';

## 7. remove the 'minutes'/mins/minute added at the end of the duration column and TRIM the whole column
UPDATE runner_orders
SET duration = SUBSTRING(duration, 1, 2);

## 8. Trim the column Duration after this
UPDATE runner_orders
SET duration = TRIM(duration);

## 9. in the cancellation column, turn rows with NaN and null to NULL 
UPDATE runner_orders
SET cancellation = CASE WHEN cancellation = 'null'
				   THEN NULL
				   WHEN cancellation = '' 
				   THEN NULL
				   END
WHERE cancellation = 'null'
OR cancellation = '';

### Checking the updated table
SELECT *
FROM runner_orders;

############ CHANGING COLUMN DATATYPES
## 1. change pickup_time column datatype from varchar to datetime
ALTER TABLE runner_orders
MODIFY pickup_time DATETIME;

## 2. change duration column datatype from varchar to integer
ALTER TABLE runner_orders
MODIFY distance FLOAT;

## 3. change order_time column datatype to datetime
ALTER TABLE customer_orders
MODIFY order_time DATETIME;


######################################################### CASE STUDY QUESTIONS ###############################################

########################################################### A. PIZZA METRICS ################################################################
### How many pizzas were ordered?
SELECT 
	COUNT(order_id) AS total_orders
FROM customer_orders;
## 14 total orders


### How many unique customer orders were made?
SELECT 
	COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders;
## 10 unique orders were placed


### How many successful orders were delivered by each runner?
SELECT 
	runner_id, 
    COUNT(*) AS successful_deliveries
FROM runner_orders r
WHERE r.cancellation IS NULL
GROUP BY r.runner_id;
## Runner 1 made 4 successful deliveries
## Runner 2 made 3 successful deliveries 
## Runner 3 made 1 successful deliveries


### How many of each type of pizza was delivered?
SELECT 
	p.pizza_id,
    p.pizza_name,
    COUNT(*) AS total_delivered
FROM runner_orders r
LEFT JOIN customer_orders c
USING (order_id)
LEFT JOIN pizza_names p
USING (pizza_id)
WHERE r.cancellation IS NULL
GROUP BY p.pizza_id, p.pizza_name
ORDER BY total_delivered DESC;
## 9 meatlovers and 3 vegetarian pizza types were delivered


### How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
    c.customer_id,
    p.pizza_name, 
    COUNT(*) AS number_of_orders
FROM runner_orders r
LEFT JOIN customer_orders c
USING (order_id)
LEFT JOIN pizza_names p
USING (pizza_id)
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;
## Customer 101 ordered 2 Meatlovers and 1 vegetarian
## Customer 102 ordered 2 Meatlovers and 1 vegetarian
## Customer 103 ordered 3 Meatlovers and 1 vegetarian
## Customer 104 ordered 3 Meatlovers
## Customer 105 only 1 vegetarian


### What was the maximum number of pizzas delivered in a single order?
SELECT  
	MAX(daily_delivery) AS maximum_order
FROM
	(SELECT 
    c.order_id,
    COUNT(*) AS daily_delivery
FROM runner_orders r
LEFT JOIN customer_orders c
USING (order_id)
WHERE r.cancellation IS NULL
GROUP BY order_id) AS count_table;
## 3 pizzas were delivered in a single order


### For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id,
		COUNT(CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL 
        THEN 'changes' 
        END) AS changes_made,
        COUNT(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL
        THEN 'no changes'
        END) AS no_changes
FROM customer_orders c
LEFT JOIN runner_orders r
USING (order_id)
WHERE r.cancellation IS NULL
GROUP BY c.customer_id;
## For Customer 101, no delivered pizza had at least 1 change, 2 had no change
## For Customer 102, no delivered pizza had at least 1 change, 3 had no change
## For Customer 103, 3 delivered pizza had at least 1 change
## For Customer 104, 2 delivered pizza had at least 1 change, 1 had no change
## For Customer 105, 1 delivered pizza had at least 1 change

  
### How many pizzas were delivered that had both exclusions and extras?
SELECT  
    COUNT(*) AS count
FROM customer_orders c
LEFT JOIN runner_orders r
USING (order_id)
WHERE c.exclusions IS NOT NULL 
AND c.extras IS NOT NULL
AND r.cancellation IS NOT NULL; 
## 1 pizza was delivered with both exclusions and extras


### What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(HOUR FROM order_time) AS hour_of_the_day,
	   COUNT(*) AS total_orders
FROM customer_orders
GROUP BY hour_of_the_day
ORDER BY hour_of_the_day;
## 11th hour - 1 pizza
## 13th hour - 3 pizza
## 18th hour - 3 pizza
## 19th hour - 1 pizza
## 21st hour - 3 pizza
## 23rd hour - 3 pizza


### What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS weekday,
	   COUNT(*) AS total_orders
FROM customer_orders
GROUP BY weekday;
## Wednesdays had 5 orders
## Thursdays had 3 orders
## Saturdays had 5 orders
## Fridays had 1 orders



################################################## B. RUNNER AND CUSTOMER EXPERIENCE ##########################################################
### How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
		WEEK(registration_date) AS week,
		COUNT(runner_id) as runners
FROM runners
GROUP BY week;


### What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT r.runner_id,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time)),2) AS average_minutes
FROM runner_orders r
LEFT JOIN customer_orders c
USING (order_id)
GROUP BY r.runner_id;
## Runner_id 1 arrived average of 15 minutes
## Runner_id 2 arrived average of 23 minutes
## Runner_id 1 arrived average of 10 minutes


### Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT 
	   COUNT(*) AS number_of_pizzas,
       TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS preparation_time
FROM customer_orders c
LEFT JOIN runner_orders r
USING (order_id)
WHERE c.order_time IS NOT NULL 
	AND r.pickup_time IS NOT NULL
GROUP BY c.order_time, r.pickup_time
ORDER BY number_of_pizzas, preparation_time;


### What was the average distance travelled for each customer?
SELECT c.customer_id,
	ROUND(AVG(r.distance),2) AS average_distance
FROM customer_orders c
LEFT JOIN runner_orders r
USING (order_id)
GROUP BY c.customer_id;
## For Customer 101, 20km on average
## For Customer 102, 16.73km on average
## For Customer 103, 23.4km on average
## For Customer 104, 10km on average
## For Customer 105, 25km on average


### What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration) AS time_difference
FROM runner_orders;
## The difference was 30 minutes


### What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT r.runner_id,
	   r.order_id,
	   ROUND((r.distance / r.duration) * 60, 2) AS average_speed
FROM runner_orders r
INNER JOIN customer_orders c
USING (order_id)
WHERE r.distance IS NOT NULL AND r.duration IS NOT NULL
GROUP BY runner_id, order_id, r.distance, r.duration
ORDER BY runner_id;
## The average speed increased overtime for each runner as they made more deliveries


### What is the successful delivery percentage for each runner?
## Delivery percentage = number_of_successful_deliveries / number_of_orders * 100
WITH count_table AS (
SELECT r.runner_id,
	COUNT(CASE WHEN r.cancellation IS NULL
    THEN 'successful_deliveries'
    END) AS successful_delivery,
    COUNT(CASE WHEN order_id IS NOT NULL
    THEN 'total_order'
    END) AS total_orders
FROM runner_orders r
GROUP BY r.runner_id)
	SELECT runner_id, 
		   ROUND((successful_delivery / total_orders) * 100,2) AS success_percentage
	FROM count_table;
## Runner id 1 had a successful delivery percentage of 100
## Runner id 2 had a successful delivery percentage of 75
## Runner id 1 had a successful delivery percentage of 50



########################################################### PART 2 BEGINS ####################################################################

##################################################### C. INGREDIENT OPTIMIZATION ##############################################################
### What are the standard ingredients for each pizza?
SELECT pn.pizza_name, GROUP_CONCAT(pt.topping_name) AS ingredients
FROM pizza_names pn
LEFT JOIN pizza_recipes pr
USING (pizza_id)
LEFT JOIN pizza_toppings pt
ON pr.toppings = pt.topping_id
GROUP BY pn.pizza_name;


SELECT 
	SUBSTRING_INDEX(toppings, ',', 1),
    SUBSTRING_INDEX(toppings, ',', 2),
    SUBSTRING_INDEX(toppings, ',', 3)
FROM pizza_recipes;


### What was the most commonly added extra?
SELECT extras, COUNT(extras)
FROM customer_orders
WHERE extras IS NOT NULL
GROUP BY extras;


WITH union_table AS (
	SELECT SUBSTRING_INDEX(extras, ',', 1) AS extra
	FROM customer_orders
	WHERE extras IS NOT NULL
	UNION ALL
	SELECT SUBSTRING_INDEX(extras, ',', -1) AS extra
	FROM customer_orders
	WHERE extras IS NOT NULL)
		SELECT extra, COUNT(*)
        FROM union_table
        GROUP BY extra;

SELECT SUBSTRING_INDEX(extras, ',', 1) AS extra
	FROM customer_orders;
	UNION ALL
	SELECT SUBSTRING_INDEX(extras, ',', -1) AS extra
	FROM customer_orders
	WHERE extras IS NOT NULL;

### What was the most common exclusion?







