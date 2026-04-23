
CREATE TABLE dim_data (
	data_id INT PRIMARY KEY,
	data_inteira DATE NOT NULL,
	year INT NOT NULL,
	month INT NOT NULL,
	month_name VARCHAR(15) NOT NULL,
	quarter INT NOT NULL
);

INSERT INTO dim_data
SELECT DISTINCT
	CONVERT(INT, FORMAT(data_abertura, 'yyyyMMdd')) AS data_id,
	data_abertura,
	YEAR(data_abertura),
	MONTH(data_abertura),
	DATENAME(MONTH, data_abertura),
	DATEPART(QUARTER, data_abertura)
FROM servicos;

SELECT * FROM dim_data;

CREATE TABLE dim_cliente (
	cliente_id INT IDENTITY PRIMARY KEY,
	nome_cliente VARCHAR(20)
);

INSERT INTO dim_cliente
SELECT DISTINCT
	cliente
FROM servicos;

DROP TABLE dim_cliente;
ALTER TABLE dim_cliente ALTER COLUMN nome_cliente VARCHAR(20)
SELECT * FROM dim_cliente;

CREATE TABLE dim_servico(
	servico_id INT IDENTITY PRIMARY KEY,
	tipo_servico VARCHAR(20)
);

INSERT INTO dim_servico
SELECT DISTINCT
	tipo_servico
FROM servicos;

CREATE TABLE dim_cidade(
	cidade_id INT IDENTITY PRIMARY KEY,
	cidade VARCHAR(50)
);

INSERT INTO dim_cidade
SELECT DISTINCT
	cidade
FROM servicos;

CREATE TABLE dim_tecnico(
	tecnico_id INT IDENTITY PRIMARY KEY,
	tecnico VARCHAR(20)
);

INSERT INTO dim_tecnico
SELECT DISTINCT
	tecnico
FROM servicos;

CREATE TABLE fato_servicos ( 
	fato_id INT IDENTITY PRIMARY KEY,
	data_id INT,
	CONSTRAINT fk_fatos_data FOREIGN KEY (data_id) REFERENCES dim_data(data_id),
	cliente_id INT,
	CONSTRAINT fk_fatos_cliente FOREIGN KEY (cliente_id) REFERENCES dim_cliente(cliente_id),
	servico_id INT,
	CONSTRAINT fk_fatos_servico FOREIGN KEY (servico_id) REFERENCES dim_servico(servico_id),
	cidade_id INT,
	CONSTRAINT fk_fatos_cidade FOREIGN KEY (cidade_id) REFERENCES dim_cidade(cidade_id),
	tecnico_id INT,
	CONSTRAINT fk_fatos_tecnico FOREIGN KEY (tecnico_id) REFERENCES dim_tecnico(tecnico_id),
	horas_trabalhadas INT,
	valor_hora INT,
	receita DECIMAL(7,2),
	custo DECIMAL(7,2),
	desconto DECIMAL(7,2),
	lucro DECIMAL(4,2),
	avaliacao_cliente INT
);

ALTER TABLE fato_servicos ALTER COLUMN lucro DECIMAL(7,2);
SELECT * FROM fato_servicos;

INSERT INTO fato_servicos
SELECT
	da.data_id,
	cl.cliente_id,
	sv.servico_id,
	cd.cidade_id,
	tc.tecnico_id,
	se.horas_trabalhadas,
	se.custo_hora,
	se.receita,
	se.custo,
	se.desconto,
	se.lucro,
	se.avaliacao_cliente
FROM servicos se
JOIN dim_data da ON se.data_abertura = da.data_inteira
JOIN dim_cliente cl ON se.cliente = cl.nome_cliente
JOIN dim_servico sv ON se.tipo_servico = sv.tipo_servico
JOIN dim_cidade cd ON se.cidade = cd.cidade
JOIN dim_tecnico tc ON se.tecnico = tc.tecnico;

SELECT cliente
FROM servicos
WHERE LEN(cliente) > 20;

SELECT se.cliente
FROM servicos se
LEFT JOIN dim_cliente cl ON se.cliente = cl.nome_cliente
WHERE cl.cliente_id IS NULL;

SELECT MAX(lucro), MIN(lucro)
FROM servicos;

select * from fato_servicos;