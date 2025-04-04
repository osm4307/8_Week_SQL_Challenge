# Case Study #1 - Danny's Diner

[Case Study #1 - Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)

### Entity Relationship Diagram:

![image](https://github.com/user-attachments/assets/d3cd2f7d-0e84-4530-90d0-b9f09d6aae62)



```
CREATE SCHEMA dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');****
```
### Case Study Questions

#### 1. What is the total amount each customer spent at the restaurant?
```
SELECT 
	customer_id, 
    SUM(price) AS price
FROM sales
	INNER JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id;
```
Answer: 

customer_id, price

A	76

B	74

C	36

#### 2. How many days has each customer visited the restaurant?
```
SELECT 
	customer_id, 
	COUNT(DISTINCT order_date) AS visited
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
```
Answer: 

customer_id, visited

A	4

B	6

C	2

#### 3. What was the first item from the menu purchased by each customer?
```
-- I did
SELECT DISTINCT product_name, customer_id, order_date
FROM sales
	INNER JOIN menu
    ON sales.product_id = menu.product_id
WHERE order_date = '2021-01-01' -- I should have used the WITH clause...
ORDER BY customer_id;
```
Answer:

product_name, customer_id, order_date

sushi	A	2021-01-01

curry	A	2021-01-01

curry	B	2021-01-01

ramen	C	2021-01-01

```
-- Query I found on Google
WITH ordered_items AS
(SELECT 
  customer_id, product_name, order_date, RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rnk 
FROM sales s JOIN menu m 
ON s.product_id = m.product_id)

SELECT 
  customer_id, order_date, product_name 
FROM ordered_items 
WHERE rnk = 1;
```
Answer:
customer_id, order_date, product_name
A	2021-01-01	sushi
A	2021-01-01	curry
B	2021-01-01	curry
C	2021-01-01	ramen
C	2021-01-01	ramen

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
