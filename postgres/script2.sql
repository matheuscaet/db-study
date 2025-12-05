DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id),
    amount NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL,
    created_at DATE NOT NULL
);


INSERT INTO customers (name, country) VALUES
('Alice', 'USA'),
('Bob', 'USA'),
('Carlos', 'Brazil'),
('Daniela', 'Brazil'),
('Emma', 'Canada'),
('Frank', 'Canada');


INSERT INTO orders (customer_id, amount, status, created_at) VALUES
(1, 120, 'paid',     '2024-01-10'),
(1, 250, 'paid',     '2024-02-11'),
(1, 300, 'pending',  '2024-02-20'),

(2, 150, 'paid',     '2024-01-05'),
(2, 200, 'canceled', '2024-02-15'),

(3, 500, 'paid',     '2024-02-20'),
(3, 700, 'paid',     '2024-03-01'),
(3, 50,  'pending',  '2024-03-10'),

(4, 90,  'paid',     '2024-01-09'),
(4, 70,  'paid',     '2024-02-11'),

(5, 1000,'paid',     '2024-01-01'),

(6, 300, 'canceled', '2024-01-01'),
(6, 200, 'paid',     '2024-01-10');

-- EXERCISE 1
SELECT c.name, SUM(o.amount) as total_spent from customers c
INNER JOIN orders o
ON c.id = o.customer_id
WHERE o.status = 'paid'
GROUP BY c.name;


-- EXERCISE 2
SELECT o.customer_id
FROM orders o
WHERE o.status = 'paid'
GROUP BY o.customer_id
HAVING SUM(o.amount) > 500
LIMIT 3;


-- EXERCISE 3
SELECT c.name
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id
WHERE c.country = 'Brazil' and o.status = 'paid'
GROUP BY c.name
HAVING COUNT(*) > 1;

-- EXERCISE 4
SELECT o.customer_id, SUM(o.amount) as total_spent
FROM orders o
WHERE o.status = 'paid'
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- EXERCISE 5
SELECT 
  c.name,
  SUM(o.amount) as total_spent,
  RANK() OVER (ORDER BY SUM(o.amount) DESC)
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id
WHERE o.status = 'paid'
GROUP BY c.id;

-- EXERCISE 6
SELECT
  c.id,
  c.name,
  SUM(o.amount) as total_spent
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id
WHERE DATE_TRUNC('month', o.created_at) = '2024-02-01'
GROUP BY c.id, c.name;




-- EXAMPLE WITH CTE APPROACH

WITH totals AS (
    SELECT 
        c.id,
        c.name,
        SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.id
    WHERE o.status = 'paid'
    GROUP BY c.id, c.name
)
SELECT 
    *,
    RANK() OVER (ORDER BY total_spent DESC) as rank
FROM totals;



