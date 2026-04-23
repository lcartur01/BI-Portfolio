CREATE TABLE dim_data (
	data_id INT PRIMARY KEY,
	data_inteira DATE NOT NULL,
	ano INT NOT NULL,
	mes INT NOT NULL,
	nome_mes VARCHAR(15) NOT NULL,
	quadrimestre INT NOT NULL
);

INSERT INTO dim_data
SELECT DISTINCT
	CONVERT(INT, FORMAT(data_venda, 'yyyyMMdd')) AS date_id,
	data_venda,
	YEAR(data_venda),
	MONTH(data_venda),
	DATENAME(MONTH, data_venda),
	DATEPART(QUARTER, data_venda)
FROM cosmeticos;

SELECT * FROM dim_data;

CREATE TABLE dim_produto (
	produto_id INT IDENTITY PRIMARY KEY,
	produto VARCHAR(20),
	marca VARCHAR(20)
);

INSERT INTO dim_produto (produto, marca)
SELECT DISTINCT 
	tipo_produto,
	marca
FROM cosmeticos;

SELECT * FROM dim_produto;

CREATE TABLE dim_origem (
	pais_id INT IDENTITY PRIMARY KEY,
	pais VARCHAR(20)
);

INSERT INTO dim_origem (pais)
SELECT DISTINCT
	pais_origem
FROM cosmeticos;

SELECT * FROM dim_origem;

CREATE TABLE dim_meio (
	meio_id INT IDENTITY PRIMARY KEY,
	canal_venda VARCHAR(20),
	meio_pagamento VARCHAR(20)
);

INSERT INTO dim_meio (canal_venda, meio_pagamento)
SELECT DISTINCT
	canal_venda,
	meio_pagamento
FROM cosmeticos;

SELECT * FROM dim_meio;

CREATE TABLE fato_cosmeticos ( 
	fato_id INT IDENTITY PRIMARY KEY,
	data_id INT,
	CONSTRAINT fk_fatos_data FOREIGN KEY (data_id) REFERENCES dim_data(data_id),
	produto_id INT,
	CONSTRAINT fk_fatos_produto FOREIGN KEY (produto_id) REFERENCES dim_produto(produto_id),
	origem_id INT,
	CONSTRAINT fk_fatos_origem FOREIGN KEY (origem_id) REFERENCES dim_origem(pais_id),
	meio_id INT,
	CONSTRAINT fk_fatos_meio FOREIGN KEY (meio_id) REFERENCES dim_meio(meio_id),
	preco DECIMAL(5,2),
	quantidade INT,
	receita DECIMAL (6,2)
);

INSERT INTO fato_cosmeticos
SELECT
	da.data_id,
	pr.produto_id,
	og.pais_id,
	me.meio_id,
	co.preco_venda,	
	co.unidade_vendida,
	co.receita_dolar
FROM cosmeticos co
JOIN dim_meio me ON co.meio_pagamento = me.meio_pagamento AND co.canal_venda = me.canal_venda
JOIN dim_produto pr ON co.tipo_produto = pr.produto AND co.marca = pr.marca
JOIN dim_origem og ON co.pais_origem = og.pais
JOIN dim_data da ON co.data_venda = da.data_inteira;

SELECT * FROM fato_cosmeticos;