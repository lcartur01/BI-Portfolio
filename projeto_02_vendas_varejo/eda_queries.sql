-- CONFERIR CONSISTÊNCIA DOS DADOS
SELECT * FROM fatos_vendas WHERE lucro <> receita-custo;

-- CONCENTRAÇÃO DE VENDAS POR PRODUTO
SELECT 
	produto_id, 
	SUM (quantidade) AS total_vendido,
	SUM (receita) AS receita_total
FROM fatos_vendas
GROUP BY produto_id
ORDER BY receita_total DESC;

-- DISTRIBUIÇÃO DE VENDAS POR LOJA
SELECT 
	loja_id,
	SUM (receita) AS venda_total,
	SUM (lucro) AS lucro_total
FROM fatos_vendas
GROUP BY loja_id
ORDER BY venda_total DESC;

-- MÉTODO POR VENDAS
SELECT
	pagamento_id,
	COUNT (*) AS total_transacoes,
	SUM (receita) AS receita_total
FROM fatos_vendas
GROUP BY pagamento_id
ORDER BY receita_total DESC;

-- TICKET MÉDIO
SELECT
	AVG(receita) AS ticket_medio
FROM fatos_vendas;

-- VARIABILIDADE (OUTLIERS) DAS VENDAS
SELECT
	MIN(receita) AS menor_venda,
	MAX(receita) AS maior_venda,
	AVG(receita) AS media_vendas
FROM fatos_vendas;

-- PRODUTOS COM MAIOR MARGEM
SELECT
	produto_id,
	SUM(receita) AS receita_total,
	SUM(custo) AS custo_total,
	SUM(lucro) AS lucro_total
FROM fatos_vendas
GROUP BY produto_id
ORDER BY lucro_total DESC;

-- DISTRIBUIÇÃO DE QUANTIDADE POR VENDA
SELECT
	quantidade,
	COUNT(*) AS total_transacoes
FROM fatos_vendas
GROUP BY quantidade
ORDER BY quantidade;

-- EXPLORAR A PERFORMANCE DE PRODUTO POR LOJA
SELECT
	produto_id,
	loja_id,
	SUM(receita) AS receita_total
FROM fatos_vendas
GROUP BY produto_id, loja_id
ORDER BY receita_total DESC;