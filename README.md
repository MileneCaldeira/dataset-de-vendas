# 📊 SQL Consultas Básicas — Dataset de Vendas

![SQL](https://img.shields.io/badge/SQL-Server-blue?style=flat-square&logo=microsoftsqlserver)
![Status](https://img.shields.io/badge/status-concluído-brightgreen?style=flat-square)
![Nível](https://img.shields.io/badge/nível-iniciante-yellow?style=flat-square)

> Projeto **Dia 1** da série [28 dias de Dados no GitHub](https://github.com/MileneCaldeira).  
> Demonstração prática dos fundamentos de SQL com um dataset real de vendas de e-commerce.

---

## 🎯 Objetivo

Aplicar os principais conceitos de consultas SQL para responder perguntas de negócio reais sobre um dataset de vendas, cobrindo:

- `SELECT` com colunas, alias e expressões calculadas
- `WHERE` com filtros por igualdade, intervalo, lista e texto parcial
- `AND`, `OR`, `NOT`, `BETWEEN`, `IN`, `LIKE`
- `ORDER BY` simples e múltiplo
- `TOP` / `LIMIT` para limitar resultados
- Funções de agregação: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`

---

## 🗂️ Estrutura do Repositório

```
sql-consultas-basicas/
│
├── data/
│   └── vendas.csv          # Dataset com 30 registros de vendas
│
├── scripts/
│   ├── setup.sql           # Criação da tabela e carga dos dados
│   └── consultas.sql       # Todas as consultas comentadas
│
└── README.md
```

---

## 📋 Sobre o Dataset

O arquivo `vendas.csv` simula transações de um e-commerce com os seguintes campos:

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_venda` | INT | Identificador único da venda |
| `data_venda` | DATE | Data da transação |
| `cliente` | VARCHAR | Nome do cliente |
| `produto` | VARCHAR | Produto comprado |
| `categoria` | VARCHAR | Categoria do produto |
| `quantidade` | INT | Quantidade adquirida |
| `preco_unitario` | DECIMAL | Preço unitário em R$ |
| `regiao` | CHAR(2) | UF de origem da venda |
| `status` | VARCHAR | Situação: Concluída / Cancelada / Pendente |

**Período:** Janeiro a Março de 2024  
**Registros:** 30 vendas  
**Categorias:** Eletrônicos, Periféricos, Armazenamento, Outros

---

## ❓ Perguntas Respondidas com SQL

As consultas do projeto foram organizadas para responder às seguintes perguntas:

1. **Quais vendas foram concluídas com sucesso?**
2. **Quais produtos custam mais de R$ 1.000?**
3. **Quais vendas ocorreram em fevereiro de 2024?**
4. **Quais produtos têm "Notebook" no nome?**
5. **Qual foi a receita total por categoria?**
6. **Qual região tem mais vendas concluídas?**
7. **Qual cliente gastou mais no período?**
8. **Qual é a taxa de cancelamento por categoria?**
9. **Quais produtos foram mais vendidos em quantidade?**
10. **Qual foi o ticket médio das vendas concluídas?**

---

## 🚀 Como Executar

### Pré-requisitos
- SQL Server, PostgreSQL ou MySQL instalado
- Ou ferramenta online: [db-fiddle.com](https://www.db-fiddle.com) / [sqliteonline.com](https://sqliteonline.com)

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/MileneCaldeira/sql-consultas-basicas.git

# 2. Abra seu client SQL (SSMS, DBeaver, Azure Data Studio...)

# 3. Execute primeiro o setup para criar a tabela
-- Abra: scripts/setup.sql → Execute

# 4. Execute as consultas
-- Abra: scripts/consultas.sql → Execute por partes
```

---

## 💡 Conceitos Demonstrados

```sql
-- Exemplo: Top 3 clientes por receita
SELECT TOP 3
       cliente,
       SUM(quantidade * preco_unitario) AS total_gasto
FROM vendas
WHERE status = 'Concluída'
GROUP BY cliente
ORDER BY total_gasto DESC;
```

```sql
-- Exemplo: Taxa de cancelamento por categoria
SELECT categoria,
       COUNT(*) AS total,
       CAST(
           SUM(CASE WHEN status = 'Cancelada' THEN 1 ELSE 0 END) * 100.0
           / COUNT(*) AS DECIMAL(5,2)
       ) AS pct_cancelamento
FROM vendas
GROUP BY categoria
ORDER BY pct_cancelamento DESC;
```

---

## 📚 Referências

- [Documentação SQL Server - SELECT](https://learn.microsoft.com/pt-br/sql/t-sql/queries/select-transact-sql)
- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)
- [Mode Analytics SQL Tutorial](https://mode.com/sql-tutorial/)

---

## 📅 Série: 28 Dias de Dados

Este é o **Dia 1** de uma série de projetos de dados publicados diariamente:

| Dia | Projeto | Tecnologia |
|-----|---------|------------|
| ✅ 01 | [sql-consultas-basicas](.) | SQL |
| 🔜 02 | sql-joins-pratica | SQL |
| 🔜 03 | sql-agrupamentos | SQL |
| 🔜 04 | sql-subqueries | SQL |
| 🔜 ... | ... | ... |

---

## 👩‍💻 Sobre

**Milene Caldeira** — Apaixonada por dados, engenharia de software e resolução de problemas.  
Atualmente expandindo habilidades em SQL Server, Power BI e ferramentas de cloud.

[![GitHub](https://img.shields.io/badge/GitHub-MileneCaldeira-black?style=flat-square&logo=github)](https://github.com/MileneCaldeira)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/milenecaldeira)
