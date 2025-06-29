# 📊 Northwind End-to-End Data Pipeline

---

## ✅ Project Goal

Build an **end-to-end data pipeline** that:

- Extracts data from the **Northwind API**
- Cleans and normalizes the data using **Python & pandas**
- Loads cleaned data into a **relational database** (`northwind_dw` with a `sales` schema)
- Connects to **Power BI** for live reporting and dashboarding

---

## 📌 Data Sources

**API:** [Northwind REST API](https://northwind.vercel.app/)

**Tables used:**
- `customers`
- `orders`
- `products`
- `suppliers`
- `shippers`

---

## 🔄 Key Steps

### 1️⃣ Extraction

- Use **`requests`** to fetch JSON from API endpoints.
- Store each endpoint’s response in a **separate pandas DataFrame**.

### 2️⃣ Cleaning

- Normalize nested fields (e.g. `address` → `street`, `city`, `region`, etc.)
- Rename columns to **snake_case**; make keys explicit (`id` → `customer_id`).
- Handle missing data:
  - Drop rows only if necessary.
  - Fill `NaN` for optional fields like `region` or `postal_code` with `"N/A"`.

### 3️⃣ Load

- Create the **`northwind_dw`** database.
- Create a **`sales`** schema for logical organization.
- Push cleaned DataFrames to database tables with **`.to_sql()`** using `if_exists="replace"`.

### 4️⃣ Validation

- Verify tables and columns in **DBeaver**.
- Confirm keys align for joins (`customer_id`, `shipper_id`, `supplier_id`).

### 5️⃣ Visualization

- Connect **Power BI Desktop** to the database using the correct driver (e.g. PostgreSQL).
- Build relationships in the Power BI **model view**.
- Create interactive dashboards & visuals.

---

## ⚙️ Tech Stack

- **Python:** `requests`, `pandas`, `sqlalchemy`
- **Database:** PostgreSQL (hosted on Aiven)
- **DB Tool:** DBeaver
- **BI Tool:** Power BI Desktop

---

## ✅ Final Tables

| Schema | Table Name |
|--------|-------------|
| `sales` | `customers` |
| `sales` | `orders` |
| `sales` | `products` |
| `sales` | `suppliers` |
| `sales` | `shippers` |

---
**
