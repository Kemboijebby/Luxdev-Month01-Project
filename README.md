# Northwind API → PostgreSQL ETL & Power BI Analytics

An end-to-end learning project that extracts operational data from the Northwind REST API, transforms nested JSON into analysis-ready pandas DataFrames, loads the results into PostgreSQL on Aiven, and explores the data with SQL and Power BI.

## Architecture

```text
Northwind REST API (7 resources)
          |
          v
Python + Requests
          |
          v
pandas transformation
- flatten nested address fields
- standardize column names
- handle selected missing values
- parse order dates
          |
          v
PostgreSQL (Aiven) — sales schema
          |
          +------> SQL analysis
          |
          +------> Power BI report
```

## What is implemented

- Extracts products, orders, customers, employees, suppliers, order details, and shippers from the API.
- Flattens nested address and shipping-address structures.
- Renames fields to consistent snake_case names.
- Handles selected missing values and converts order date fields to datetime.
- Loads products, orders, suppliers, customers, and shippers into PostgreSQL using SQLAlchemy and `DataFrame.to_sql()`.
- Includes SQL queries for customer/order joins, shipper analysis, open and delayed orders, order counts, and freight analysis.
- Includes a Power BI report file and dashboard screenshot.

## Repository contents

- `data_eng.ipynb` — API extraction, transformation, and PostgreSQL loading.
- `custo-9.sql` — SQL analysis queries and a fact-view definition.
- `Sales Analysis.pbix` — Power BI report.
- `Dashboard Screenshot.png` — report preview.
- `requirements.txt` — Python dependencies.
- `.env.example` — safe template for database settings.

## Setup

1. Create a Python virtual environment.
2. Install dependencies with `python -m pip install -r requirements.txt`.
3. Copy `.env.example` to `.env` and add your own Aiven connection details.
4. Load the environment variables in the notebook using `python-dotenv`.
5. Run the notebook cells in order.
6. Connect Power BI Desktop to PostgreSQL and refresh the report using your own connection settings.

## Environment variables

The notebook reads `AIVEN_USER`, `AIVEN_PASSWORD`, `AIVEN_HOST`, `AIVEN_PORT`, and `AIVEN_DATABASE`.

Do not commit `.env` or paste database credentials into notebooks. Rotate any credential that has previously been committed.

## Important implementation notes

- The notebook uses `to_sql(if_exists='replace')`, which replaces the target tables each time the load cells run. This is a full-refresh learning workflow, not an incremental production load.
- The pipeline currently runs from a notebook and does not include a scheduler, automated retries, data contracts, or monitoring.
- The SQL and dashboard assets demonstrate analysis workflows; no production service-level or business-impact metrics are claimed.

## Next improvements

- Move extraction, transformation, and loading into reusable Python modules.
- Add request timeouts, retries, API response validation, and structured logging.
- Add schema constraints, primary/foreign keys, and row-count reconciliation.
- Implement incremental loading and idempotent upserts.
- Add automated data-quality tests and pipeline orchestration.
- Document dashboard KPIs and provide reproducible screenshots.

## Technologies

Python · Requests · pandas · SQLAlchemy · PostgreSQL · Aiven · SQL · Power BI
