# IMDB Join Order Benchmark — PostgreSQL

Containerized IMDB database for running the [Join Order Benchmark (JOB)](https://github.com/gregrahn/join-order-benchmark).

## Data sources

### Queries and schema (`join-order-benchmark/`)
Obtained from the repository: https://github.com/gregrahn/join-order-benchmark

Contains the 113 benchmark queries from the paper *"How Good Are Query Optimizers, Really?"* (Leis et al., VLDB 2015), as well as the `schema.sql` and `fkindexes.sql` scripts.

### CSVs (`data/`)
IMDB snapshot from May 2013, made available by CWI:
http://event.cwi.nl/da/job/imdb.tgz

These are the same data used in the original paper (*"A Resource-Aware Deep Cost Model for Big Data Query Processing"* — Yan Li, Liwei Wang, Sheng Wang, Yuan Sun, Zhiyong Peng, IEEE 2022).

## How to run

### Prerequisites
- [Docker](https://www.docker.com/) installed
- ~10GB of free disk space (~4.8GB for the CSVs + ~5GB for the Docker image with the populated database)

### 0. Download the data

The CSVs are not included in the repository because they are too large (~4.8GB). Download the file before building:

```bash
mkdir -p data
cd data
wget http://event.cwi.nl/da/job/imdb.tgz
tar -xzf imdb.tgz
cd ..
```

### 1. Build the image

```bash
docker build -t imdb-postgres .
```

> The first run takes a few minutes — PostgreSQL creates the tables and imports all CSVs during the build.

### 2. Start the container

```bash
docker run -d \
  --name imdb \
  -p 5432:5432 \
  imdb-postgres
```

> If port 5432 is already in use on your machine (e.g., a local PostgreSQL instance running), change the host port: `-p 5434:5432`

### 3. Connect to the database

```bash
docker exec -it imdb psql -U postgres -d imdb
```

Or via any PostgreSQL client (DBeaver, psql, etc.) with:

| Parameter | Value     |
|-----------|-----------|
| Host      | localhost |
| Port      | 5432      |
| Database  | imdb      |
| User      | postgres  |
| Password  | postgres  |

### 4. Run a benchmark query

```bash
docker exec -i imdb psql -U postgres -d imdb < join-order-benchmark/1a.sql
```
