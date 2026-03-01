-- Criando a tabela original

CREATE TABLE orders (
    order_id        VARCHAR(20)    NOT NULL,
    order_date      DATE            NOT NULL,
    ship_date       DATE            NULL,
    delivery_date   DATE            NULL,
    order_status    VARCHAR(30)     NOT NULL,

    customer_id     VARCHAR(20)     NOT NULL,
    customer_name   VARCHAR(100)    NOT NULL,

    country         VARCHAR(50)     NOT NULL,
    state           VARCHAR(50)     NOT NULL,
    city            VARCHAR(50)     NOT NULL,

    product_id      VARCHAR(20)     NOT NULL,
    product_name    VARCHAR(100)    NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    sub_category    VARCHAR(50)     NOT NULL,
    brand           VARCHAR(100)    NOT NULL,

    quantity        INT             NOT NULL,
    unit_price      DECIMAL(12,2)   NOT NULL,
    discount        DECIMAL(5,2)    NOT NULL,
    shipping_cost   DECIMAL(10,2)   NOT NULL,
    total_sales     DECIMAL(14,4)   NOT NULL,

    payment_method  VARCHAR(30)     NOT NULL
);

-- Criando a tabela temporária

CREATE TABLE orders_stage (
    order_id        VARCHAR(50),
    order_date      VARCHAR(50),
    ship_date       VARCHAR(50),
    delivery_date   VARCHAR(50),
    order_status    VARCHAR(50),
    customer_id     VARCHAR(50),
    customer_name   VARCHAR(100),
    country         VARCHAR(50),
    state           VARCHAR(50),
    city            VARCHAR(50),
    product_id      VARCHAR(50),
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    sub_category    VARCHAR(50),
    brand           VARCHAR(100),
    quantity        VARCHAR(50),
    unit_price      VARCHAR(50),
    discount        VARCHAR(50),
    shipping_cost   VARCHAR(50),
    total_sales     VARCHAR(50),
    payment_method  VARCHAR(50)
);

-- Fazendo o Bulk Insert

BULK INSERT orders_stage
FROM 'C:\SQLData\sales_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    LASTROW = 3001,
    CODEPAGE = '65001'
);

-- Pasando os valores da tabela temporária para a original

INSERT INTO orders
SELECT
    order_id,
    CAST (order_date AS DATE),
    CAST (ship_date AS DATE),
    CAST (delivery_date AS DATE),
    order_status,
    customer_id,
    customer_name, 
    country,
    state,
    city,
    product_id,
    product_name,
    category,
    sub_category,
    brand,
    CAST (REPLACE(quantity, ',', '.') AS INT),
    CAST (REPLACE(unit_price, ',', '.') AS DECIMAL(12,2)),
    CAST (discount AS DECIMAL(5,2)),
    CAST (shipping_cost AS DECIMAL(10,2)),
    CAST (total_sales AS DECIMAL(14,4)),
    payment_method
FROM orders_stage;

-- Visualizando a tabela

SELECT * FROM orders;