# Superstore Sales & Profitability Analysis

**An end-to-end data analysis project uncovering why discounting strategy was silently destroying profit — from raw CSV to a normalized PostgreSQL database to an interactive Tableau dashboard and narrative story.**

🔗 **[Live Interactive Dashboard](#)** *(https://public.tableau.com/app/profile/rakes.dey/viz/SuperstoreRetailAnalysisUncoveringa125KDiscountProblem_17860634414370/SuperstoreAnalysis-InteractiveDashboard?publish=yes)*





🔗 **[Live Story Walkthrough](#)** *(https://public.tableau.com/app/profile/rakes.dey/viz/SuperstoreRetailAnalysisUncoveringa125KDiscountProblem_17860634414370/SuperstoreProfitabilityDeep-DiveTheDiscountProblem?publish=yes)*

---

## Business Problem

Superstore, a national retail chain, wanted to understand what was driving (and eroding) profitability across products, regions, and customer segments. Leadership suspected discounting was hurting margins but had no quantified view of the impact.

**Key question:** Which products, regions, and customer segments drive the most profit — and where is the company losing money?

---

## Dataset

- **Source:** [Superstore Sales Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle)
- **Size:** 9,994 order line items, 2014–2017
- **Fields:** Order/ship dates, customer info, product info, sales, discount, profit, geography

---

## Tools & Tech Stack

| Stage | Tools |
|---|---|
| Data Cleaning & Wrangling | Python (pandas, numpy), Jupyter Notebook |
| Database | PostgreSQL, psycopg2 |
| Analysis | SQL (window functions, CTEs, CASE statements) |
| Visualization | Tableau Public |

---

## Approach

### 1. Data Cleaning (Python)
- Converted `Order Date` / `Ship Date` from string to datetime
- Fixed `Postal Code` type (categorical, not numeric)
- Created derived fields: `Shipping Days`, `Profit Margin %`
- Validated data integrity (no nulls, no duplicates, no date logic errors)

### 2. Database Design (PostgreSQL)
Designed a **3-table normalized schema** (customers, products, orders) rather than loading the flat file as-is — this required correcting an initial assumption: customer geography (city/state) turned out to be **order-level** (shipping address), not a fixed customer attribute, since 780 of 793 customers had shipped to multiple cities. Schema was corrected accordingly before load.

- Staging table + `COPY` + `ON CONFLICT` upsert pattern for idempotent loads
- Foreign key constraints + indexes on join/filter columns
- Verified referential integrity with anti-join queries (`LEFT JOIN ... WHERE ... IS NULL`)

### 3. SQL Analysis
Wrote a full analysis query set covering:
- KPI aggregation (total sales, profit, margin%)
- Top/bottom performing products (JOIN + GROUP BY)
- Month-over-month growth (`LAG()` window function)
- Customer segment profitability
- **Discount bucket analysis** (`CASE WHEN`) — the core insight
- Regional ranking (`RANK()`, `DENSE_RANK()`)

See [`SQL/sql-analysis-queries.sql`](SQL/sql-analysis-queries.sql) for the full query set.

### 4. Dashboard & Story (Tableau)
- Built an **interactive dashboard** with a global region filter, KPI cards, trend analysis, and drill-down charts
- Built a **4-point narrative story** for stakeholder presentation

---

## Key Findings

**1. Discounting is destroying profit above a 20% threshold**

| Discount Tier | Orders | Avg Margin | Total Profit |
|---|---|---|---|
| 0% | 4,798 | 34.0% | $320,988 |
| 1–10% | 94 | 15.6% | $9,029 |
| 11–20% | 3,709 | 17.5% | $91,757 |
| 21–30% | 227 | **-11.6%** | **-$10,369** |
| 30%+ | 1,166 | **-91.5%** | **-$125,007** |

Discounts above 30% alone cost the company **over $125K** in the analysis period.

**2. Geography doesn't guarantee profitability**
California and New York — two of the largest markets by sales volume — show the heaviest losses, suggesting over-discounting or high operating costs are concentrated in high-volume regions rather than low-volume ones.

**3. Sub-category losses concentrate in Furniture**
Tables and Bookcases are the two biggest loss-making sub-categories, consistent with the discounting pattern found above.

**4. Overall business is growing**
Despite the discount problem, monthly sales trend up consistently from 2014 to 2017, with strong Q4 seasonality (Nov/Dec outperform every year).

---

## Recommendation

Cap discounts at 20% company-wide, and conduct a targeted pricing review for the Tables and Bookcases sub-categories, which show the strongest correlation between heavy discounting and losses.

---

## Repository Structure
```
retail-sales-analysis/
├── README.md
├── Jupyter_Notebooks/
│   └── data_cleaning_and_export.ipynb
├── SQL/
│   ├── schema.sql
│   └── sql-analysis-queries.sql
├── images/
│   └── Interactive Dashboard Image.png
└── Data/
    └── (sample rows only — full dataset via Kaggle link above)
```

---

## What I'd Do With More Time
- Build a Python ETL script (not just notebook) to automate re-loading fresh exports
- Add a simple forecasting model on the monthly sales trend
- A/B test discount cap recommendation against historical data to quantify projected profit recovery
