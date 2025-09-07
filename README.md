
# 📊 Layoffs Data Exploration with SQL

This project explores global layoffs data using SQL.  
The goal is to analyze patterns, trends, and insights around layoffs across companies, industries, countries, and time periods.

---

## 📑 Table of Contents

1. [Extended Description](#-extended-description)  
2. [Features](#-features)  
3. [Dataset](#-dataset)  
4. [Data Cleaning & Deduplication](#-data-cleaning--deduplication-sql)  
5. [SQL Queries Breakdown](#-sql-queries-breakdown)  
6. [Insights You Can Extract](#-insights-you-can-extract)  
7. [Tech Stack](#-tech-stack)  
8. [Example Output](#-example-output-optional)  
9. [How to Use](#-how-to-use)  
10. [Future Improvements](#-future-improvements)  
11. [Contributing](#-contributing)  
12. [License](#-license)  

---

## 📖 Extended Description

Mass layoffs have been a recurring theme in the global economy, especially across tech, finance, and startups.  
This project dives deep into a structured dataset of company layoffs to uncover **patterns, causes, and impacts** using SQL.

By leveraging simple to advanced SQL queries, the project answers important questions such as:

- Which companies laid off the most employees?  
- Were some industries or locations more impacted than others?  
- How did layoffs evolve over the years (especially during downturns like COVID-19)?  
- Which companies experienced **100% workforce layoffs**, and how much funding had they raised beforehand?  
- What is the **cumulative trend of layoffs month-over-month**?  

This repository is designed for **data analysts, SQL learners, and researchers** who want to:

- Practice **SQL querying techniques** (aggregation, grouping, ranking, window functions, and CTEs).  
- Perform **real-world data exploration** and storytelling with SQL.  
- Understand how **economic challenges impact different sectors and regions**.  

---

## 🚀 Features

- **Data Exploration** → Preview and explore the dataset with `SELECT *`.  
- **Data Cleaning** → Remove duplicates, standardize fields, and fix data types.  
- **Easier Queries** →  
  - Find maximum layoffs  
  - Identify companies with 100% layoffs  
  - Check percentages and funding details  
- **Aggregated Insights** →  
  - Top companies, locations, countries, and industries by layoffs  
  - Year-wise and stage-wise summaries  
- **Advanced Analysis** →  
  - Rolling totals of layoffs by month  
  - CTEs for cumulative layoffs  
  - Ranking companies with most layoffs per year (Top 3 each year)  

---

## 📂 Dataset

The dataset is stored in a table called **`standralising`**, containing:

- `company`  
- `industry`  
- `total_laid_off`  
- `percentage_laid_off`  
- `location`  
- `country`  
- `date`  
- `stage`  
- `funds_raised`  

---

## 🧼 Data Cleaning & Deduplication (SQL)

### 1) Create a staging table (work safely on a copy)

```sql
CREATE TABLE `standralising` LIKE layoffs;
INSERT `standralising`
SELECT * FROM layoffs;
2) Inspect potential duplicates
sql
Copy code
SELECT company, industry, total_laid_off, `date`,
       ROW_NUMBER() OVER (
         PARTITION BY company, industry, total_laid_off, `date`
         ORDER BY company
       ) AS row_num
FROM standralising;
3) Remove duplicate rows
sql
Copy code
SET SQL_SAFE_UPDATES = 0;

DELETE s
FROM standralising AS s
JOIN (
  SELECT company, industry, total_laid_off, `date`, percentage_laid_off, stage, country,
         ROW_NUMBER() OVER (
           PARTITION BY company, industry, total_laid_off, `date`
           ORDER BY company
         ) AS row_num
  FROM standralising
) AS r
  ON s.company = r.company
 AND s.industry = r.industry
 AND s.total_laid_off = r.total_laid_off
 AND s.`date` = r.`date`
WHERE r.row_num > 1;

SET SQL_SAFE_UPDATES = 1;
4) Normalize text fields
sql
Copy code
UPDATE standralising
SET company = TRIM(company);
5) Convert date strings to DATE type
sql
Copy code
UPDATE standralising
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
6) Identify missing values
sql
Copy code
SELECT *
FROM standralising
WHERE total_laid_off IS NULL
   OR funds_raised IS NULL
   OR industry IS NULL
   OR `date` IS NULL;
🛠️ SQL Queries Breakdown
🔹 Easier Queries
sql
Copy code
-- Maximum layoffs
SELECT MAX(total_laid_off) FROM standralising;

-- Companies with 100% layoffs
SELECT * FROM standralising WHERE percentage_laid_off = 1;
🔹 Aggregated Insights
sql
Copy code
-- Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM standralising
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM standralising
GROUP BY country
ORDER BY total_laid_off DESC;
🔹 Advanced Queries
sql
Copy code
-- Rolling total of layoffs per month
WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
  FROM standralising
  GROUP BY dates
  ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
📈 Insights You Can Extract
📌 Largest single-day layoffs by company

📌 Industries and countries most affected

📌 Year-over-year layoff trends

📌 Top 3 companies per year with the most layoffs

📌 Rolling and cumulative totals of layoffs

🧑‍💻 Tech Stack
SQL (MySQL / PostgreSQL compatible)

Relational Database to store and query data

Queries structured for exploration + insights

📸 Example Output (Optional)
Add charts or screenshots of query results / dashboards here for better presentation.

🌟 How to Use
Clone this repo:

bash
Copy code
git clone https://github.com/your-username/layoffs-sql-analysis.git
Import the dataset into your SQL database.

Run queries in your favorite SQL client (MySQL Workbench, DBeaver, pgAdmin, etc.).

Explore, analyze, and derive insights!

📌 Future Improvements
📊 Add visualizations (Tableau, Power BI, or Python)

⚡ Automate ETL pipeline for updated data

🤖 Extend to predictive analysis with ML models

🤝 Contributing
Pull requests are welcome!
For major changes, please open an issue first to discuss what you’d like to change.
