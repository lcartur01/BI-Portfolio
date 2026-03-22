CREATE TABLE vendas (
	data_venda DATE NOT NULL,
	produto VARCHAR(20),
	loja VARCHAR(40),
	quantidade INT,
	forma_pagamento VARCHAR(20),
	categoria VARCHAR(40),
	preco_unitario DECIMAL(7,2),
	receita DECIMAL(7,2),
	custo DECIMAL (18,2),
	lucro DECIMAL(18,2)
);

BULK INSERT vendas
FROM 'C:\SQLData\dataset_varejo.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);