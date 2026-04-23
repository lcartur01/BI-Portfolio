CREATE TABLE vendas_cafeteria (
	hora_dia INT,
	tipo_pagamento VARCHAR(5),
	valor DECIMAL(4,2),
	nome_cafe VARCHAR(30),
	periodo_dia VARCHAR(20),
	dia VARCHAR(3),
	mes VARCHAR(3),
	clas_dia INT,
	clas_mes INT,
	data DATE,
	hora VARCHAR(20)
);

BULK INSERT vendas_cafeteria
FROM 'C:\SQLData\Coffe_sales.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);

SELECT * FROM vendas_cafeteria;