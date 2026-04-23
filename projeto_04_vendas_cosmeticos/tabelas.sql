CREATE TABLE cosmeticos (
	id_venda INT NOT NULL,
	data_venda DATE NULL,
	marca VARCHAR(20) NULL,
	tipo_produto VARCHAR(20) NULL,
	pais_origem VARCHAR(20) NULL,
	canal_venda VARCHAR(20) NULL,
	meio_pagamento VARCHAR(20) NULL,
	preco_venda DECIMAL(5,2) NULL,
	unidade_vendida INT NULL,
	receita_dolar DECIMAL (6,2) NULL
);

BULK INSERT cosmeticos
FROM 'C:\SQLData\makeup_sales_dataset_2025.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);

SELECT * FROM cosmeticos;