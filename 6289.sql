create database NY_Restaurant;
show databases;
use NY_Restaurant;

show tables;

-- create table roster
CREATE TABLE roster (
    CAMIS INT PRIMARY KEY,
    DBA VARCHAR(255),
    BORO VARCHAR(100),
    BUILDING VARCHAR(100),
    STREET VARCHAR(255),
    ZIPCODE INT,
    PHONE BIGINT,
    CUISINE_DESCRIPTION VARCHAR(255),
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    Community_Board INT,
    Council_District INT,
    Census_Tract BIGINT,
    BIN BIGINT,
    BBL BIGINT,
    NTA VARCHAR(100)
);

-- create table for online order
CREATE TABLE OL_Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_name VARCHAR(255),
    cuisine_type VARCHAR(50),
    cost_of_the_order DECIMAL(5, 2),
    day_of_the_week ENUM('Weekday', 'Weekend'),
    rating TINYINT, -- Assuming rating is on a scale of 1-5; if 'Not given', it can be NULL.
    food_preparation_time INT,
    delivery_time INT,
    total_time INT
);
ALTER TABLE OL_Orders MODIFY rating TINYINT NULL;

select count(*) from ol_orders;
select distinct cuisine_type from ol_orders;

-- Create view: select top5 in Online order
CREATE VIEW top5_OL as
SELECT restaurant_name, 
       AVG(cost_of_the_order) AS average_cost, 
       AVG(rating) AS average_rating, 
       AVG(total_time) AS average_total_time
FROM ol_orders
WHERE cuisine_type = 'Italian'
-- change the cuisine type
AND rating IS NOT NULL 
GROUP BY restaurant_name
ORDER BY average_cost ASC, average_rating DESC, average_total_time ASC
-- Or change the sequence of these factors
LIMIT 5;        
-- LIMIT 10

SELECT restaurant_name, 
       AVG(cost_of_the_order) AS average_cost, 
       AVG(rating) AS average_rating, 
       AVG(total_time) AS average_total_time
FROM ol_orders
WHERE rating IS NOT NULL 
-- change the cuisine type
GROUP BY restaurant_name
ORDER BY average_cost ASC, average_rating DESC, average_total_time ASC
-- Or change the sequence of these factors
LIMIT 5;        
-- LIMIT 10

-- create table for manhattan_inspections with several constrains
CREATE TABLE manhattan_inspections(
    CAMIS INT PRIMARY KEY,  
    DBA VARCHAR(255) NOT NULL,  
    BORO VARCHAR(255) NOT NULL,  
    STREET VARCHAR(255) NOT NULL,  
    CUISINE_DESCRIPTION VARCHAR(255) NOT NULL,  
    INSPECTION_DATE DATE NOT NULL,  
    SCORE INT CHECK (SCORE >= 0 ),  
    Latitude DECIMAL(9,6) CHECK (Latitude >= -90 AND Latitude <= 90),  
    Longitude DECIMAL(9,6) CHECK (Longitude >= -180 AND Longitude <= 180)  
);

-- how constrain works in sql
INSERT INTO manhattan_inspections (
    CAMIS, DBA, BORO, STREET, CUISINE_DESCRIPTION, INSPECTION_DATE, SCORE, Latitude, Longitude
) VALUES (
    2, 'Test Cafe', 'Manhattan', '456 Elm St', 'Italian', '2024-04-23', -5, 85.123456, -74.0060
);

-- select top5 in manhattan 
CREATE VIEW top5_manhattan AS   
SELECT
    m.CAMIS,
    m.DBA,
    m.SCORE,
    m.Latitude,
    m.Longitude,
    r.PHONE
FROM
    manhattan_inspections AS m
INNER JOIN
    roster AS r ON m.CAMIS = r.CAMIS
WHERE
    m.cuisine_description = 'Italian'
ORDER BY
    m.SCORE DESC
LIMIT 5;

-- create table for queens_inspections
create table queens_inspections(
	CAMIS INT PRIMARY KEY,
    DBA VARCHAR(255),
    BORO VARCHAR(255),
    STREET VARCHAR(255),
    CUISINE_DESCRIPTION VARCHAR(255),
    INSPECTION_DATE DATE,
    SCORE INT,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- select top5 in queens 
CREATE VIEW top5_queens AS      
SELECT
    q.CAMIS,
    q.DBA,
    q.SCORE,
    q.Latitude,
    q.Longitude,
    r.PHONE
FROM
    queens_inspections AS q
INNER JOIN
    roster AS r ON q.CAMIS = r.CAMIS
WHERE
    q.cuisine_description = 'French'
ORDER BY
    q.SCORE DESC
LIMIT 5;

-- create table for brooklyn_inspections
create table brooklyn_inspections(
	CAMIS INT PRIMARY KEY,
    DBA VARCHAR(255),
    BORO VARCHAR(255),
    STREET VARCHAR(255),
    CUISINE_DESCRIPTION VARCHAR(255),
    INSPECTION_DATE DATE,
    SCORE INT,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- select top5 in brooklyn    
CREATE VIEW top5_brooklyn AS 
SELECT
    bn.CAMIS,
    bn.DBA,
    bn.SCORE,
    bn.Latitude,
    bn.Longitude,
    r.PHONE
FROM
    brooklyn_inspections AS bn
INNER JOIN
    roster AS r ON bn.CAMIS = r.CAMIS
WHERE
    bn.cuisine_description = 'French'
ORDER BY
    bn.SCORE DESC
LIMIT 5;

-- create table for bronx_inspections
create table bronx_inspections(
	CAMIS INT PRIMARY KEY,
    DBA VARCHAR(255),
    BORO VARCHAR(255),
    STREET VARCHAR(255),
    CUISINE_DESCRIPTION VARCHAR(255),
    INSPECTION_DATE DATE,
    SCORE INT,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- select top5 in bronx  
CREATE VIEW top5_bronx AS   
SELECT
    bx.CAMIS,
    bx.DBA,
    bx.SCORE,
    bx.Latitude,
    bx.Longitude,
    r.PHONE
FROM
    bronx_inspections AS bx
INNER JOIN
    roster AS r ON bx.CAMIS = r.CAMIS
WHERE
    bx.cuisine_description = 'Japanese'
ORDER BY
    bx.SCORE DESC
LIMIT 5;

-- create table for statenisland_inspections
create table statenisland_inspections(
	CAMIS INT PRIMARY KEY,
    DBA VARCHAR(255),
    BORO VARCHAR(255),
    STREET VARCHAR(255),
    CUISINE_DESCRIPTION VARCHAR(255),
    INSPECTION_DATE DATE,
    SCORE INT,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- select top5 in statenisland 
CREATE VIEW top5_statenisland AS    
SELECT
    s.CAMIS,
    s.DBA,
    s.SCORE,
    s.Latitude,
    s.Longitude,
    r.PHONE
FROM
    statenisland_inspections AS s
INNER JOIN
    roster AS r ON s.CAMIS = r.CAMIS
WHERE
    s.cuisine_description = 'Japanese'
ORDER BY
    s.SCORE DESC
LIMIT 5;

-- create table for subway
create table subway(
	stationID INT PRIMARY KEY,
    division VARCHAR(5),
    Line VARCHAR(50),
    StationName VARCHAR(200),
    StationLat DECIMAL(9,6),
    StationLong DECIMAL(9,6),
    ADA VARCHAR(5)
);

CREATE TABLE restaurant_reviews (
    restaurant VARCHAR(255),
    rating_review INT,
    sample ENUM('Positive', 'Negative'),
    review_id VARCHAR(255),
    title_review VARCHAR(255),
    review_date DATE,
    url_restaurant VARCHAR(255),
    author_id VARCHAR(255),
    PRIMARY KEY (review_id)
);

-- create index in roster to accelerate query
CREATE INDEX idx_dba ON roster (DBA);

-- select top5 in manhattan along with review
CREATE VIEW top5_manhattan_with_review AS 
SELECT
    m.CAMIS,
    m.DBA,
    m.SCORE,
    m.Latitude,
    m.Longitude,
    r.PHONE,
    rv.AvgRating,
    CONCAT(FORMAT(rv.PositiveRate * 100, 2), '%') AS PositiveRate
FROM
    manhattan_inspections AS m
INNER JOIN
    roster AS r ON m.CAMIS = r.CAMIS
LEFT JOIN (
    SELECT
        restaurant,
        AVG(rating_review) AS AvgRating,
        SUM(CASE WHEN sample = 'Positive' THEN 1 ELSE 0 END) / COUNT(*) AS PositiveRate
    FROM
        restaurant_reviews	
    GROUP BY
        restaurant
) AS rv ON m.DBA = rv.restaurant
WHERE
    m.cuisine_description = 'Italian'
ORDER BY
    m.SCORE DESC
LIMIT 5;

-- Tables needed for visualizations

-- Stack inspections data tables
create table inspections as
select * from bronx_inspections union
select * from brooklyn_inspections union
select * from manhattan_inspections union
select * from queens_inspections union
select * from statenisland_inspections;

-- add average rating and delivery time onto roster
create table rating_delivery as
select restaurant_name, avg(rating) as avg_rating, avg(delivery_time+food_preparation_time) as avg_total_time
from ol_orders
group by restaurant_name;

-- join number of subway stations surrounding restaurant
create table subway_count as
select round(StationLat, 2) as StationLat_round, round(StationLong, 2) as StationLong_round, count(*) as count_subway
from subway
group by StationLat_round, StationLong_round;

select * from subway_count;

create table rating_positiverate as
select restaurant, AVG(rating_review) AS AvgRating, SUM(CASE WHEN sample = 'Positive' THEN 1 ELSE 0 END) / COUNT(*) AS PositiveRate
FROM restaurant_reviews	
GROUP BY restaurant;

-- join inspection score and average rating/delivery, number of surrounding subway stations, average rating and positive rate
create table roster_2 as
select r.*, i.score, rd.avg_rating, rd.avg_total_time, 
case when avg_rating is not null then 'Yes' else 'No' end as restaurant_delivers, s.count_subway, 
case when rp.avgrating is not null then rp.avgrating else -1 end as avgrating, 
case when rp.positiverate is not null then rp.positiverate else -1 end as positiverate
from roster r left join inspections i
using(camis) left join rating_delivery rd on r.DBA = upper(rd.restaurant_name)
left join subway_count s
on round(r.Longitude,2) = s.StationLong_round and round(r.Latitude,2) = s.StationLat_round
left join rating_positiverate rp
on r.DBA = rp.restaurant;

-- identify subway stops near restaurants, and vice versa
create table subway_restaurant as
select r.*, s.*
from roster r 
left join subway s on 
round(r.Longitude,2) = round(s.StationLong,2) and round(r.Latitude,2) = round(s.StationLat,2);
