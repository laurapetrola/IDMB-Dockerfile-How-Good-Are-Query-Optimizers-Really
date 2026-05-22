# IMDB Join Order Benchmark — PostgreSQL

Banco de dados IMDB containerizado para execução do [Join Order Benchmark (JOB)](https://github.com/gregrahn/join-order-benchmark).

## Origem dos dados

### Queries e schema (`join-order-benchmark/`)
Obtidos do repositório: https://github.com/gregrahn/join-order-benchmark

Contém as 113 queries do benchmark do paper *"How Good Are Query Optimizers, Really?"* (Leis et al., VLDB 2015), além dos scripts `schema.sql` e `fkindexes.sql`.

### CSVs (`data/`)
Snapshot do IMDB de maio de 2013, disponibilizado pelo CWI:
http://event.cwi.nl/da/job/imdb.tgz

São os mesmos dados usados no paper original (*"A Resource-Aware Deep Cost Model for Big Data Query Processing"* — Yan Li, Liwei Wang, Sheng Wang, Yuan Sun, Zhiyong Peng, IEEE 2022).

## Como rodar

### Pré-requisitos
- [Docker](https://www.docker.com/) instalado

### 0. Baixar os dados

Os CSVs não estão no repositório por serem muito grandes (~4.8GB). Baixe o arquivo antes de fazer o build:

```bash
mkdir -p data
cd data
wget http://event.cwi.nl/da/job/imdb.tgz
tar -xzf imdb.tgz
cd ..
```

### 1. Build da imagem

```bash
docker build -t imdb-postgres .
```

> A primeira execução demora alguns minutos — o PostgreSQL cria as tabelas e importa todos os CSVs durante o build.

### 2. Subir o container

```bash
docker run -d \
  --name imdb \
  -p 5432:5432 \
  imdb-postgres
```

> Se a porta 5432 já estiver em uso na sua máquina (ex: PostgreSQL local rodando), troque a porta do host: `-p 5434:5432`

### 3. Conectar ao banco

```bash
docker exec -it imdb psql -U postgres -d imdb
```

Ou via qualquer cliente PostgreSQL (DBeaver, psql, etc.) com:

| Parâmetro | Valor     |
|-----------|-----------|
| Host      | localhost |
| Porta     | 5432      |
| Banco     | imdb      |
| Usuário   | postgres  |
| Senha     | postgres  |

### 4. Executar uma query do benchmark

```bash
docker exec -i imdb psql -U postgres -d imdb < join-order-benchmark/1a.sql
```
