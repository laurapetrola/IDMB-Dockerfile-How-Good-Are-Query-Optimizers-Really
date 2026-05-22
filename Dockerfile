FROM postgres:15

# Configurações do Banco
ENV POSTGRES_DB=imdb
ENV POSTGRES_PASSWORD=postgres

# 1. Prepara o diretório de dados e copia os CSVs
RUN mkdir -p /data
COPY data/*.csv /data/

# 2. Scripts de Inicialização (Numerados para garantir a ordem lógica)
# Passo 01: Cria a estrutura das tabelas (agora buscando da subpasta)
COPY join-order-benchmark/schema.sql /docker-entrypoint-initdb.d/01_schema.sql

# Passo 02: Popula as tabelas (buscando da raiz)
COPY import_data.sql /docker-entrypoint-initdb.d/02_import.sql

# Passo 03: Cria chaves estrangeiras e índices (buscando da subpasta)
COPY join-order-benchmark/fkindexes.sql /docker-entrypoint-initdb.d/03_indexes.sql

# Garante que o Postgres consiga ler os arquivos CSV
RUN chmod -R 755 /data