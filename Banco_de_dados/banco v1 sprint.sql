-- Criação e seleção do banco de dados do projeto
CREATE DATABASE SenseNoir;
USE SenseNoir;

-- Tabela para armazenar os dados cadastrais das empresas/vinícolas
CREATE TABLE empresa (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
nome_empresa VARCHAR(70) NOT NULL,
cnpj_empresa CHAR(18) NOT NULL UNIQUE,
email VARCHAR(50) NOT NULL UNIQUE,
senha VARCHAR(50) NOT NULL,
qtd_sensores INT NOT NULL, -- Quantidade de sensores contratados/instalados pela vinícola
ativo TINYINT,
dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Inserção de dados fictícios de vinícolas parceiras

INSERT INTO empresa(nome_empresa, cnpj_empresa, email, senha, qtd_sensores, ativo) VALUES
('Vinícola Vale Verde', '24.999.432/0001-16', 'contato@valeverdevinhos.com', 'FpGen1234', 6, 1),
('Quinta do Sol Vinhos Finos', '09.239.557/0001-54', 'safra@quintadosol.com.br', 'P321_f', 10, 1),
('Adega Serrana', '15.053.665/0001-30', 'producao@adegaserrana.com.br', 'gabFlc8776@', 27, 0),
('Vinhedos de Altitude', '86.475.320/0001-13', 'colheita@vinhedosdealtitude.com', 'lcs@nt13I', 26, 1),
('Espumantes Dom Bosco', '57.646.469/0001-10', 'enologia@domboscovinhos.com.br', 'ph36Fr_', 14, 0),
('Cantina Rota das Uvas', '65.753.786/0001-63', 'adm@rotadasuvas.com', 'Rg678$', 10, 1),
('Terroir dos Pampas', '12.147.968/0001-24', 'contato@terroirdospampas.com.br', 'Th20M&', 31, 0);

-- Consulta formatada da tabela de empresas com tradução do status numérico para texto

SELECT 
DATE_FORMAT(DATE(dt_cadastro), '%d/%m/%Y') AS 'Data de Cadastro', 
nome_empresa AS 'Nome da Empresa',
cnpj_empresa AS 'CNPJ',
email AS 'E-mail Cadastrado',
senha AS 'Senha',
qtd_sensores AS 'Quantidade de Sensores',
CASE
    WHEN ativo = 0 THEN 'Inativo'
    ELSE 'Ativo'
END AS 'Status'
FROM empresa;

-- Tabela para armazenar as capturas de dados dos sensores de temperatura e umidade (DHT11)

CREATE TABLE DHT11_Dados (
id INT PRIMARY KEY AUTO_INCREMENT,
umidade INT NOT NULL,
temperatura DECIMAL(5, 2) NOT NULL,
num_serie_sensor INT NOT NULL, -- Identifica o sensor e sua localização exata na safra
hr_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Inserção de leituras simuladas coletadas pelos sensores

INSERT INTO DHT11_Dados (umidade, temperatura, num_serie_sensor) VALUES
(65, 23.50, 1001),
(70, 22.80, 1001),
(58, 25.10, 1002),
(62, 24.30, 1002),
(80, 19.50, 1003),
(75, 20.10, 1003),
(55, 26.40, 1004),
(53, 27.00, 1004),
(68, 21.90, 1005),
(66, 22.20, 1005);

-- Inserção de um registro específico com valores dentro do padrão ideal (estável)

INSERT INTO DHT11_Dados (umidade, temperatura, num_serie_sensor) VALUES
(55, 14.00, 1001);

-- Consulta inteligente que analisa as leituras e aplica regras de negócio baseadas nas condições da plantação

SELECT 
DATE_FORMAT(DATE(hr_registro), '%d/%m/%Y') AS 'Data Registro', 
TIME(hr_registro) AS 'Hora do Registro', 
num_serie_sensor AS 'Nº Série Sensor',
CONCAT(umidade, '%') AS 'Umidade', 
CONCAT(temperatura, ' °C') AS 'Temperatura',
	CASE
		WHEN (temperatura < 12 OR temperatura > 15) AND (umidade < 50 OR umidade > 60)
        THEN 'Temperatura e Umidade Criticas'
        WHEN temperatura < 12 OR temperatura > 15 THEN 'Temperatura Crítica'
        WHEN umidade < 50 OR umidade > 60 THEN 'Umidade Crítica'
	ELSE 'Temperatura Estável'
    END AS 'Status Plantação'
FROM DHT11_Dados;