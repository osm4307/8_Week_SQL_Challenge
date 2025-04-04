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
  ('B', '2021-01-09');
  
/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	customer_id, 
    SUM(price) AS price
FROM sales
	INNER JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id;

-- SELECT column_name(s)
-- FROM table1
-- INNER JOIN table2
-- ON table1.column_name = table2.column_name;

-- 2. How many days has each customer visited the restaurant?
SELECT 
	customer_id, 
	COUNT(DISTINCT order_date) AS visited
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
-- 중복되는 order_date를 카운트 하는 구문을 사용해 며칠이나 방문했는지 조회함

-- 3. What was the first item from the menu purchased by each customer?
-- 내가 한거
SELECT DISTINCT product_name, customer_id, order_date
FROM sales
	INNER JOIN menu
    ON sales.product_id = menu.product_id
WHERE order_date = '2021-01-01'
ORDER BY customer_id;

-- 구글에서 찾은 쿼리
WITH ordered_items AS
(SELECT 
  customer_id, product_name, order_date, RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rnk 
FROM sales s JOIN menu m 
ON s.product_id = m.product_id)

SELECT 
  customer_id, order_date, product_name 
FROM ordered_items 
WHERE rnk = 1;

-- WITH 절을 사용했어야 했는데 생각이 나지 않아 'WHERE order_date = '2021-01-01'을 사용하게 됨..

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?