CREATE TABLE servicos(
	id_servico INT,
	data_abertura DATE,
	data_fechamento DATE,
	cliente VARCHAR(20),
	cidade VARCHAR(20),
	tipo_servico VARCHAR(20),
	tecnico VARCHAR(20),
	prioridade VARCHAR(20),
	horas_trabalhadas INT,
	valor_hora INT,
	receita DECIMAL(7,2),
	custo_hora DECIMAL(7,2),
	custo DECIMAL(7,2),
	desconto DECIMAL(7,2),
	lucro DECIMAL(4,2),
	avaliacao_cliente INT
);

BULK INSERT servicos
FROM 'C:\SQLData\dataset_servicos.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT * FROM servicos;

ALTER TABLE servicos
ALTER COLUMN lucro DECIMAL(6,2);