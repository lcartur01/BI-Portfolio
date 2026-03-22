-- Criando as tabelas dimensões

-- Criando a Dim_date
CREATE TABLE dim_date (
	date_id INT PRIMARY KEY,
	full_date DATE NOT NULL,
	year INT NOT NULL,
	month INT NOT NULL,
	mont_name VARCHAR(15) NOT NULL,
	quartet INT NOT NULL
);

-- PopulandO a Dim_date
INSERT INTO dim_date
SELECT DISTINCT
	CONVERT(INT, FORMAT(order_date, 'yyyyMMdd')) AS date_id,
	order_date,
	YEAR(order_date),
	MONTH(order_date),
	DATENAME(MONTH, order_date),
	DATEPART(QUARTER, order_date)
FROM orders;

-- Criando a Dim_customer
CREATE TABLE dim_customer (
	customer_id VARCHAR(20) PRIMARY KEY,
	customer_name VARCHAR(100) NOT NULL
);

-- Populando a Dim_customer
INSERT INTO dim_customer (customer_id, customer_name)
SELECT
    customer_id,
    MIN(LTRIM(RTRIM(customer_name))) AS customer_name
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

-- Criando a Dim_product
CREATE TABLE dim_product(
	product_id VARCHAR(20) PRIMARY KEY,
	product_name VARCHAR(100),
	category VARCHAR(50),
	sub_category VARCHAR(50),
	brand VARCHAR(100)
);

-- Populando a Dim_product
INSERT INTO dim_product
SELECT
    product_id,
    MIN(LTRIM(RTRIM(product_name))) AS product_name,
    MIN(category)      AS category,
    MIN(sub_category)  AS sub_category,
    MIN(brand)         AS brand
FROM orders
WHERE product_id IS NOT NULL
GROUP BY product_id;

-- Criando a Dim_location
CREATE TABLE dim_location(
	location_id INT IDENTITY PRIMARY KEY,
	country VARCHAR(50),
	state VARCHAR(50),
	city VARCHAR(50)
);

-- Populando a Dim_location
INSERT INTO dim_location (country, state, city)
SELECT DISTINCT
	country,
	state,
	city
FROM orders;

-- Criando a Dim_payment
CREATE TABLE dim_payment (
	payment_id INT IDENTITY PRIMARY KEY,
	payment_method VARCHAR(30)
);

-- Populando a Dim_payment
INSERT INTO dim_payment (payment_method)
SELECT DISTINCT
	payment_method
FROM orders;

-- Criando a tabela fato

-- Criando a Fact_sales
CREATE TABLE fact_sales (
	fact_sales_id INT IDENTITY PRIMARY KEY,
	date_id INT NOT NULL,
	customer_id VARCHAR(20) NOT NULL,
	product_id VARCHAR(20) NOT NULL,
	location_id INT NOT NULL,
	payment_id INT NOT NULL,
	quantity INT NOT NULL,
	unit_price DECIMAL(12,2) NOT NULL,
	discount DECIMAL(5,2),
	shipping_cost DECIMAL(10,2),
	total_sales DECIMAL(14,4),
);

-- Populando a Fact_sales
INSERT INTO fact_sales
SELECT
    d.date_id,
    o.customer_id,
    o.product_id,
	l.location_id,
	p.payment_id,
	o.quantity,
    o.unit_price,
    o.discount,
    o.shipping_cost,
    o.total_sales
FROM orders o
JOIN dim_date d
ON d.full_date = o.order_date
JOIN dim_location l
ON l.country = o.country
AND l.state = o.state
AND l.city = o.city
JOIN dim_payment p
ON p.payment_method = o.payment_method;


-- Criando Foreign Keys para a garantia de integridade dos dados entre as tabelas

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_date FOREIGN KEY (date_id)
REFERENCES dim_date (date_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id)
REFERENCES dim_customer (customer_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_product FOREIGN KEY (product_id)
REFERENCES dim_product (product_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_location FOREIGN KEY (location_id)
REFERENCES dim_location (location_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_payment FOREIGN KEY (payment_id)
REFERENCES dim_payment (payment_id);

-- Criando índices para consultas mais ágeis

CREATE INDEX idx_fact_date
ON fact_sales (date_id);

CREATE INDEX idx_fact_customer
ON fact_sales (customer_id);

CREATE INDEX idx_fact_product
ON fact_sales (product_id);

CREATE INDEX idx_fact_location
ON fact_sales (location_id);

CREATE INDEX idx_fact_payment
ON fact_sales (payment_id);

CREATE INDEX idx_dim_product_category
ON dim_product (category);

CREATE INDEX idx_dim_location_country
ON dim_location (country);