CREATE database zomato;

CREATE TABLE zomato.goldusers_signup(
userid integer,
gold_signup_date date
); 

INSERT INTO zomato.goldusers_signup(userid,gold_signup_date) VALUES (1,'2017-09-22'), (3,'2017-04-21');

CREATE TABLE zomato.users(
userid integer,
signup_date date
); 

INSERT INTO zomato.users(userid,signup_date) VALUES (1,'2014-09-02'), (2,'2015-01-15'), (3,'2014-04-11');

CREATE TABLE zomato.sales(
userid integer,
created_date date,
product_id integer); 

INSERT INTO zomato.sales(userid,created_date,product_id) 
VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

CREATE TABLE zomato.product(
product_id integer,
product_name text,
price integer); 

INSERT INTO zomato.product(product_id,product_name,price) VALUES(1,'p1',980),(2,'p2',870),(3,'p3',330);

select * from zomato.sales;
select * from zomato.product;
select * from zomato.goldusers_signup;
select * from zomato.users;

1. What is the total amount each customer spend on zomato?
SELECT userid, SUM(price) AS total_amt_spent
FROM zomato.sales a
INNER JOIN zomato.product b ON a.product_id = b.product_id
GROUP BY a.userid;

2. How many days has each customer visited zomato?
SELECT userid, COUNT(DISTINCT created_date) AS distinct_days
FROM zomato.sales
GROUP BY userid;

3. What was the first product purchased by each customer?
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
    FROM zomato.sales
) AS a
WHERE rnk = 1;

4. What is the most purchased item on the menu and how many times was it parchased by all customers?
SELECT userid, COUNT(product_id) AS cnt
FROM zomato.sales
WHERE product_id = (
    SELECT product_id
    FROM zomato.sales
    GROUP BY product_id
    ORDER BY COUNT(product_id) DESC
    LIMIT 1
)
GROUP BY userid;

5. Which items was the most popular for each customer?
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY userid ORDER BY cnt DESC) AS rnk
    FROM (
        SELECT userid,
               product_id,
               COUNT(product_id) AS cnt
        FROM zomato.sales
        GROUP BY userid, product_id
    ) AS a
) AS b
WHERE rnk = 1;

