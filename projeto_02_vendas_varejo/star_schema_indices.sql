CREATE TABLE dim_produto (
	produto_id INT IDENTITY PRIMARY KEY,
	produto VARCHAR (20),
	categoria VARCHAR (40)
);

INSERT INTO dim_produto (produto, categoria)
SELECT DISTINCT
	produto,
	categoria
FROM vendas;

CREATE TABLE dim_loja (
	loja_id INT IDENTITY PRIMARY KEY,
	loja VARCHAR(40)
);

INSERT INTO dim_loja (loja)
SELECT DISTINCT
	loja
FROM vendas;

CREATE TABLE dim_data (
	data_id INT PRIMARY KEY,
	data DATE,
	ano INT,
	mes INT,
	nome_mes VARCHAR(15),
	trimestre INT
);

INSERT INTO dim_data
SELECT DISTINCT
	CONVERT(INT, FORMAT(data_venda, 'yyyyMMdd')) AS data_id,
	data_venda,
	YEAR(data_venda),
	MONTH(data_venda),
	DATENAME(MONTH, data_venda),
	DATEPART(QUARTER, data_venda)
FROM vendas;

CREATE TABLE dim_pagamento (
	pagamento_id INT IDENTITY PRIMARY KEY,
	forma_pagamento VARCHAR(20)
);

INSERT INTO dim_pagamento (forma_pagamento)
SELECT DISTINCT
	forma_pagamento
FROM vendas;

CREATE TABLE fatos_vendas (
	fato_vendas_id INT IDENTITY PRIMARY KEY,
	data_id INT,
	CONSTRAINT fk_fatos_data FOREIGN KEY (data_id) REFERENCES dim_data(data_id),
	produto_id INT,
	CONSTRAINT fk_fatos_produto FOREIGN KEY (produto_id) REFERENCES dim_produto(produto_id),
	loja_id INT,
	CONSTRAINT fk_fatos_loja FOREIGN KEY (loja_id) REFERENCES dim_loja(loja_id),
	pagamento_id INT,
	CONSTRAINT fk_fatos_pagamento FOREIGN KEY (pagamento_id) REFERENCES dim_pagamento(pagamento_id),
	quantidade INT,
	receita DECIMAL(7,2),
	custo DECIMAL (18,2),
	lucro DECIMAL(18,2)
);

INSERT INTO fatos_vendas
SELECT
	da.data_id,
	pr.produto_id,
	lo.loja_id,
	pa.pagamento_id,
	ve.quantidade,
	ve.receita,
	ve.custo,
	ve.lucro
FROM vendas ve
JOIN dim_pagamento pa ON ve.forma_pagamento = pa.forma_pagamento
JOIN dim_produto pr ON ve.produto = pr.produto
JOIN dim_loja lo ON ve.loja = lo.loja
JOIN dim_data da ON ve.data_venda = da.data;

CREATE INDEX idx_fato_data ON fatos_vendas(data_id);
CREATE INDEX idx_fato_produto ON fatos_vendas(pagamento_id);
CREATE INDEX idx_fato_loja ON fatos_vendas(loja_id);
CREATE INDEX idx_fato_pagamento ON fatos_vendas(pagamento_id);
