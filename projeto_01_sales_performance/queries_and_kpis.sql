-- Queries anlíticas

-- Agrupado de venda por dia
SELECT date_id, SUM(total_sales) AS totalsales
FROM fact_sales
GROUP BY date_id
ORDER BY date_id;

-- Descobrindo as sub-categorias mais vendidas
SELECT p.sub_category, SUM(f.total_sales) AS Vendas_totais
FROM dim_product p JOIN fact_sales f ON p.product_id = f.product_id
GROUP BY p.sub_category;

-- Descobrindo o ticket médio
SELECT AVG(total_sales) AS Ticket_Médio
FROM fact_sales;

SELECT SUM(total_sales)/COUNT(*) AS Ticket_médio
from fact_sales

-- Descobrindo a quantidade vendida por estado
SELECT l.state, SUM(f.total_sales) AS Vendas_totais
FROM dim_location l JOIN fact_sales f ON l.location_id = f.location_id
GROUP BY l.state
ORDER BY Vendas_totais;

-- Descobrindo o desconto médio por categoria
SELECT AVG((f.quantity*f.unit_price)-((f.quantity*f.unit_price)*discount)) AS Média
FROM fact_sales f JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.sub_category

-- KPIs

-- KPI de receita total
SELECT SUM(total_sales)  AS Total_de_vendas FROM fact_sales;

-- KPI quantidade vendidade
SELECT SUM(quantity) AS Quantidade_vendida FROM fact_sales;

-- KPI de Total de compradores
SELECT COUNT(DISTINCT customer_id) AS Total_de_usuários FROM fact_sales;

-- KPI de Média dos fretes
SELECT AVG(shipping_cost) AS Frete_médio FROM fact_sales;

-- KPI de frete como parte da receita
SELECT SUM(shipping_cost)/SUM(total_sales) FROM fact_sales;