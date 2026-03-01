-- ============================================================
-- PROJETO: Consultas SQL Básicas com Dataset de Vendas
-- Autor: Milene Caldeira
-- Data: 2024
-- Descrição: Demonstração de SELECT, WHERE, ORDER BY e
--            operadores fundamentais com dados de vendas
-- ============================================================


-- ============================================================
-- PARTE 1: CRIAÇÃO DA TABELA E CARGA DOS DADOS
-- ============================================================

CREATE TABLE vendas (
    id_venda       INT PRIMARY KEY,
    data_venda     DATE NOT NULL,
    cliente        VARCHAR(100),
    produto        VARCHAR(100),
    categoria      VARCHAR(50),
    quantidade     INT,
    preco_unitario DECIMAL(10,2),
    regiao         CHAR(2),
    status         VARCHAR(20)
);

-- Calcular valor total de cada venda (coluna calculada)
-- No SQL Server pode ser usado como coluna computada:
ALTER TABLE vendas
    ADD valor_total AS (quantidade * preco_unitario);

-- Importar dados do CSV (SQL Server)
-- BULK INSERT vendas
-- FROM 'C:\caminho\vendas.csv'
-- WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');


-- ============================================================
-- PARTE 2: SELECT SIMPLES
-- ============================================================

-- 2.1 Selecionar todas as colunas
SELECT *
FROM vendas;

-- 2.2 Selecionar colunas específicas
SELECT id_venda,
       data_venda,
       cliente,
       produto,
       valor_total
FROM vendas;

-- 2.3 Usar alias (apelido) nas colunas
SELECT cliente                    AS "Nome do Cliente",
       produto                    AS "Produto Comprado",
       quantidade * preco_unitario AS "Total Pago (R$)"
FROM vendas;

-- 2.4 Selecionar valores distintos
SELECT DISTINCT categoria
FROM vendas
ORDER BY categoria;

SELECT DISTINCT regiao
FROM vendas
ORDER BY regiao;


-- ============================================================
-- PARTE 3: FILTRANDO COM WHERE
-- ============================================================

-- 3.1 Filtrar por igualdade
SELECT *
FROM vendas
WHERE status = 'Concluída';

-- 3.2 Filtrar por valor numérico
SELECT cliente, produto, preco_unitario
FROM vendas
WHERE preco_unitario > 1000;

-- 3.3 Filtrar por intervalo (BETWEEN)
SELECT cliente, produto, preco_unitario
FROM vendas
WHERE preco_unitario BETWEEN 300 AND 1000;

-- 3.4 Filtrar por data
SELECT *
FROM vendas
WHERE data_venda BETWEEN '2024-02-01' AND '2024-02-29';

-- 3.5 Filtrar por lista de valores (IN)
SELECT *
FROM vendas
WHERE categoria IN ('Eletrônicos', 'Armazenamento');

-- 3.6 Filtrar por texto parcial (LIKE)
SELECT cliente, produto
FROM vendas
WHERE produto LIKE '%Notebook%';

-- 3.7 Combinar filtros com AND
SELECT *
FROM vendas
WHERE categoria = 'Eletrônicos'
  AND status = 'Concluída'
  AND preco_unitario > 2000;

-- 3.8 Combinar filtros com OR
SELECT *
FROM vendas
WHERE regiao = 'SP'
   OR regiao = 'RJ';

-- 3.9 Negar condição com NOT
SELECT *
FROM vendas
WHERE status NOT IN ('Cancelada', 'Pendente');

-- 3.10 Verificar nulos
SELECT *
FROM vendas
WHERE cliente IS NOT NULL;


-- ============================================================
-- PARTE 4: ORDENANDO COM ORDER BY
-- ============================================================

-- 4.1 Ordenar por data (mais recente primeiro)
SELECT *
FROM vendas
ORDER BY data_venda DESC;

-- 4.2 Ordenar por valor total (maior primeiro)
SELECT cliente,
       produto,
       quantidade * preco_unitario AS valor_total
FROM vendas
ORDER BY valor_total DESC;

-- 4.3 Ordenar por múltiplas colunas
SELECT *
FROM vendas
ORDER BY categoria ASC,
         preco_unitario DESC;

-- 4.4 Ordenar por posição da coluna
SELECT cliente, produto, preco_unitario
FROM vendas
ORDER BY 3 DESC;


-- ============================================================
-- PARTE 5: LIMITANDO RESULTADOS (TOP / LIMIT)
-- ============================================================

-- 5.1 Top 5 vendas mais caras (SQL Server)
SELECT TOP 5
       cliente,
       produto,
       quantidade * preco_unitario AS valor_total
FROM vendas
ORDER BY valor_total DESC;

-- 5.2 Top 3 clientes com mais compras
SELECT TOP 3
       cliente,
       COUNT(*) AS total_compras
FROM vendas
WHERE status = 'Concluída'
GROUP BY cliente
ORDER BY total_compras DESC;


-- ============================================================
-- PARTE 6: FUNÇÕES DE AGREGAÇÃO BÁSICAS
-- ============================================================

-- 6.1 Contar registros
SELECT COUNT(*)        AS total_vendas,
       COUNT(DISTINCT cliente) AS clientes_unicos
FROM vendas;

-- 6.2 Somar, média, mínimo e máximo
SELECT SUM(quantidade * preco_unitario) AS receita_total,
       AVG(quantidade * preco_unitario) AS ticket_medio,
       MIN(preco_unitario)              AS menor_preco,
       MAX(preco_unitario)              AS maior_preco
FROM vendas
WHERE status = 'Concluída';

-- 6.3 Totais por categoria
SELECT categoria,
       COUNT(*)                         AS qtd_vendas,
       SUM(quantidade * preco_unitario) AS receita
FROM vendas
WHERE status = 'Concluída'
GROUP BY categoria
ORDER BY receita DESC;

-- 6.4 Receita por mês
SELECT YEAR(data_venda)  AS ano,
       MONTH(data_venda) AS mes,
       SUM(quantidade * preco_unitario) AS receita_mensal
FROM vendas
WHERE status = 'Concluída'
GROUP BY YEAR(data_venda), MONTH(data_venda)
ORDER BY ano, mes;


-- ============================================================
-- PARTE 7: CONSULTAS ANALÍTICAS (PERGUNTAS DE NEGÓCIO)
-- ============================================================

-- 7.1 Qual foi a venda de maior valor?
SELECT TOP 1
       id_venda, cliente, produto,
       quantidade * preco_unitario AS valor_total
FROM vendas
ORDER BY valor_total DESC;

-- 7.2 Qual região tem mais vendas concluídas?
SELECT regiao,
       COUNT(*) AS vendas_concluidas
FROM vendas
WHERE status = 'Concluída'
GROUP BY regiao
ORDER BY vendas_concluidas DESC;

-- 7.3 Qual cliente gastou mais?
SELECT cliente,
       SUM(quantidade * preco_unitario) AS total_gasto
FROM vendas
WHERE status = 'Concluída'
GROUP BY cliente
ORDER BY total_gasto DESC;

-- 7.4 Taxa de cancelamento por categoria
SELECT categoria,
       COUNT(*) AS total,
       SUM(CASE WHEN status = 'Cancelada' THEN 1 ELSE 0 END) AS canceladas,
       CAST(
           SUM(CASE WHEN status = 'Cancelada' THEN 1 ELSE 0 END) * 100.0
           / COUNT(*) AS DECIMAL(5,2)
       ) AS pct_cancelamento
FROM vendas
GROUP BY categoria
ORDER BY pct_cancelamento DESC;

-- 7.5 Produtos mais vendidos (em quantidade)
SELECT produto,
       SUM(quantidade) AS unidades_vendidas,
       SUM(quantidade * preco_unitario) AS receita_total
FROM vendas
WHERE status = 'Concluída'
GROUP BY produto
ORDER BY unidades_vendidas DESC;
